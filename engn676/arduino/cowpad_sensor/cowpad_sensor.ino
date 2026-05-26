// ═══════════════════════════════════════════════════════════════════════
//  CowPad EC Sensor — Arduino Nano
//  ENGN676 · Lincoln University · 2026
//
//  Reads electrical conductivity via soil moisture sensor probes.
//  As biochar absorbs NH4+ ions from cow urine, conductivity rises.
//  Displays saturation % on 4-digit screen + LED colour indicator.
//
//  RAIN DISCRIMINATION (3-layer):
//    1. Physical  — probe tips sit at tile base (deep in biochar).
//                   Rain wets top surface; probes measure bottom → unaffected.
//    2. Hardware  — raindrop sensor module on D4 detects active rainfall.
//                   During rain: freeze displayed saturation, suppress red alarm.
//    3. Software  — EC derivative tracking.
//                   Rising EC  → urine absorption  → update saturation normally.
//                   Falling EC → rain dilution      → hold last saturation value.
//
//  WIRING:
//    Moisture sensor  VCC → 5V
//    Moisture sensor  GND → GND
//    Moisture sensor  AO  → A0
//
//    Raindrop sensor  VCC → 5V
//    Raindrop sensor  GND → GND
//    Raindrop sensor  DO  → D4  (LOW = rain detected)
//
//    Green  LED → D9  → 220Ω → GND
//    Yellow LED → D10 → 220Ω → GND
//    Red    LED → D11 → 220Ω → GND
//
//    TM1637 display  CLK → D2
//    TM1637 display  DIO → D3
//    TM1637 display  VCC → 5V
//    TM1637 display  GND → GND
//
//  LIBRARY NEEDED:
//    Arduino IDE → Tools → Manage Libraries → search "TM1637" →
//    install "TM1637" by Avishay Orpaz
// ═══════════════════════════════════════════════════════════════════════

#include <TM1637Display.h>

// ── Pins ──────────────────────────────────────────────────────────────
#define SENSOR_PIN   A0
#define RAIN_PIN     4    // raindrop sensor DO  (LOW = rain, HIGH = dry)
#define LED_GREEN    9
#define LED_YELLOW   10
#define LED_RED      11
#define DISPLAY_CLK  2
#define DISPLAY_DIO  3

// ── Thresholds (tune these after testing with real salt water) ────────
// Raw analogRead values: 0 = no conductivity, 1023 = max conductivity
#define THRESH_YELLOW  380   // above → yellow (biochar 60% full)
#define THRESH_RED     650   // above → red    (biochar 85% full, replace now)

// ── Rain / derivative tracking ───────────────────────────────────────
#define HISTORY_LEN   5     // number of past readings kept for trend
#define TREND_WINDOW  3     // min samples needed to declare a trend
#define RAIN_HOLD_MS  10000 // freeze display for 10 s after rain clears

int    ecHistory[HISTORY_LEN];  // ring buffer of raw EC readings
int    histIdx   = 0;
int    histCount = 0;           // how many valid entries so far
int    frozenRaw = 0;           // last valid (non-rain) EC reading
bool   frozen    = false;       // true when rain suppression is active
unsigned long rainClearAt = 0;  // millis() when rain sensor last went HIGH

// ── Display ───────────────────────────────────────────────────────────
TM1637Display display(DISPLAY_CLK, DISPLAY_DIO);

// ── Segment patterns ─────────────────────────────────────────────────
const uint8_t SEG_GOOD[] = {
  SEG_A | SEG_B | SEG_C | SEG_D | SEG_F | SEG_G,  // G
  SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_F,  // O
  SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_F,  // O
  SEG_B | SEG_C | SEG_D | SEG_E | SEG_G            // d
};
const uint8_t SEG_FULL[] = {
  SEG_A | SEG_E | SEG_F | SEG_G,   // F
  SEG_D | SEG_E | SEG_F | SEG_G,   // u
  SEG_D | SEG_E | SEG_F,           // L
  SEG_D | SEG_E | SEG_F            // L
};
// "rAIn" — shown on display while rain suppression is active
const uint8_t SEG_RAIN[] = {
  SEG_E | SEG_G,                              // r
  SEG_A | SEG_B | SEG_C | SEG_E | SEG_F | SEG_G, // A
  SEG_E | SEG_F | SEG_B | SEG_C,             // I (1)
  SEG_C | SEG_E | SEG_G                       // n
};

// ═══════════════════════════════════════════════════════════════════════
// Compute linear trend slope of the EC history buffer.
// Returns > 0 if rising, < 0 if falling, 0 if flat or too few samples.
// ═══════════════════════════════════════════════════════════════════════
int ecTrend() {
  if (histCount < TREND_WINDOW) return 0;

  // Use oldest TREND_WINDOW entries (most recent are at head of ring)
  long sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
  int  n    = min(histCount, HISTORY_LEN);
  for (int i = 0; i < n; i++) {
    // Walk back through ring buffer — 0 = most recent
    int idx = ((histIdx - 1 - i) + HISTORY_LEN) % HISTORY_LEN;
    sumX  += i;
    sumY  += ecHistory[idx];
    sumXY += i * ecHistory[idx];
    sumX2 += i * i;
  }
  long denom = (long)n * sumX2 - sumX * sumX;
  if (denom == 0) return 0;
  long numer = (long)n * sumXY - sumX * sumY;
  // slope > 0 means EC rising with increasing i (older samples have higher i)
  // we stored newest=0, oldest=n-1, so rising slope means EC was higher in past
  // → numer < 0 means EC is currently higher than history → RISING
  return (int)(-numer);  // positive = currently rising
}

// ═══════════════════════════════════════════════════════════════════════
void setup() {
  pinMode(LED_GREEN,  OUTPUT);
  pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED,    OUTPUT);
  pinMode(RAIN_PIN,   INPUT_PULLUP);  // raindrop module pulls LOW on rain

  display.setBrightness(5);
  Serial.begin(9600);

  // Initialise history buffer
  for (int i = 0; i < HISTORY_LEN; i++) ecHistory[i] = 0;

  // Startup flash
  digitalWrite(LED_GREEN,  HIGH);
  digitalWrite(LED_YELLOW, HIGH);
  digitalWrite(LED_RED,    HIGH);
  display.setSegments(SEG_GOOD);
  delay(800);
  digitalWrite(LED_GREEN,  LOW);
  digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED,    LOW);
}

// ═══════════════════════════════════════════════════════════════════════
void loop() {
  // ── Read sensors ──────────────────────────────────────────────────
  int  raw        = analogRead(SENSOR_PIN);
  bool raining    = (digitalRead(RAIN_PIN) == LOW);

  // ── Update EC history ─────────────────────────────────────────────
  ecHistory[histIdx] = raw;
  histIdx = (histIdx + 1) % HISTORY_LEN;
  if (histCount < HISTORY_LEN) histCount++;

  // ── Rain suppression logic ─────────────────────────────────────────
  int  trend = ecTrend();   // positive = EC rising, negative = falling

  if (raining) {
    // Hardware rain sensor active — suppress immediately
    frozen       = true;
    rainClearAt  = millis() + RAIN_HOLD_MS;
  } else if (trend < -8) {
    // Software: EC derivative strongly negative → rain dilution
    frozen       = true;
    rainClearAt  = millis() + RAIN_HOLD_MS;
  } else if (frozen && millis() > rainClearAt) {
    // Hold period over AND EC trend no longer falling → resume
    if (trend >= 0) {
      frozen = false;
    }
  }

  // If not frozen and EC rising (urine absorption) → update frozen snapshot
  if (!frozen && trend >= 0) {
    frozenRaw = raw;
  } else if (!frozen) {
    frozenRaw = raw;  // flat trend — accept reading
  }

  // ── Choose displayed value ─────────────────────────────────────────
  int displayRaw = frozen ? frozenRaw : raw;
  int pct        = map(displayRaw, 0, 1023, 0, 100);

  // ── Display ────────────────────────────────────────────────────────
  if (frozen) {
    display.setSegments(SEG_RAIN);         // "rAIn" flashes while suppressed
  } else if (displayRaw >= THRESH_RED) {
    display.setSegments(SEG_FULL);
  } else {
    display.showNumberDec(pct, false);
  }

  // ── LED logic ──────────────────────────────────────────────────────
  // During rain suppression: hold last colour, never trigger fresh RED alarm
  if (!frozen) {
    if (displayRaw < THRESH_YELLOW) {
      digitalWrite(LED_GREEN,  HIGH);
      digitalWrite(LED_YELLOW, LOW);
      digitalWrite(LED_RED,    LOW);
    } else if (displayRaw < THRESH_RED) {
      digitalWrite(LED_GREEN,  LOW);
      digitalWrite(LED_YELLOW, HIGH);
      digitalWrite(LED_RED,    LOW);
    } else {
      digitalWrite(LED_GREEN,  LOW);
      digitalWrite(LED_YELLOW, LOW);
      digitalWrite(LED_RED,    HIGH);
    }
  }
  // (if frozen: LEDs stay at last state — no digitalWrite → no change)

  // ── Serial monitor ────────────────────────────────────────────────
  Serial.print("Raw: ");     Serial.print(raw);
  Serial.print("  Trend: "); Serial.print(trend);
  Serial.print("  Rain: ");  Serial.print(raining ? "YES" : "no");
  Serial.print("  Frozen: ");Serial.print(frozen  ? "YES" : "no");
  Serial.print("  Display: ");Serial.print(pct);
  Serial.print("%  Status: ");
  if      (frozen)                         Serial.println("RAIN — reading frozen");
  else if (displayRaw < THRESH_YELLOW)     Serial.println("GOOD - absorbing");
  else if (displayRaw < THRESH_RED)        Serial.println("MONITOR - getting full");
  else                                     Serial.println("REPLACE NOW");

  delay(400);
}
