// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Manual Trigger Lever  ·  V2 Demo Component
//  ENGN676  ·  Lincoln University  ·  2026
//
//  For DEMO USE: press button end to release platform latch.
//  For V2 PRODUCTION: replace lever with solenoid pin.
//    Solenoid pin engages same latch notch — no tile modification needed.
//    Arduino GPIO → MOSFET → 12V solenoid → cartridge ejected.
//
//  HOW TRIGGER WORKS:
//    Lever pivots on a pin through the tile outer wall.
//    Hook end engages latch notch on platform underside.
//    Press button → lever rotates → hook lifts out of notch → platform fires.
//    Release button → torsion spring returns hook to catch position.
//
//  ► PRINT 1 COPY
//  ► Orientation : flat side DOWN
//  ► Layer height : 0.2mm  ·  Infill 30%  ·  No supports
//  ► Material     : PLA
//  ► Est. time    : ~20 min
//
//  ALSO PRINT: 1× PivotPin (last module in this file)
// ═══════════════════════════════════════════════════════════════════════

$fn = 48;

// ── Tile parameters ───────────────────────────────────────────────────
OR = 145;
ANG = 45;
BASE_H = 6;
CAV_WALL = 5;

// ── Lever geometry ────────────────────────────────────────────────────
LEVER_T    = 4;     // lever arm thickness
LEVER_W    = 7;     // lever arm width
HOOK_L     = 12;    // hook arm length (toward platform latch)
BTN_L      = 22;    // button arm length (user presses this)
PIVOT_D    = 4.2;   // pivot hole diameter (3mm wire + 0.6 clearance)

// Hook tip (catches platform latch notch)
HOOK_TIP_W = 6;
HOOK_TIP_H = 3.5;
HOOK_TIP_D = 3;

// Button cap (larger face for easy press)
BTN_W = 14;
BTN_H = 8;

// ── Pivot placement ───────────────────────────────────────────────────
// Lever mounts on outer face of tile at mid-arc
PIVOT_ANG = ANG / 2;   // 22.5° — midpoint of tile arc
PIVOT_R   = OR + 3;    // just outside tile outer wall

// ═══════════════════════════════════════════════════════════════════════
// LEVER BODY
// An L-shaped lever arm with pivot hole in the middle.
// Hook arm goes INWARD (toward platform); button arm goes OUTWARD/UPWARD.
// ═══════════════════════════════════════════════════════════════════════

module lever_body() {
  difference() {
    union() {
      // Hook arm (short, toward latch notch)
      translate([-HOOK_L, -LEVER_W/2, 0])
        cube([HOOK_L, LEVER_W, LEVER_T]);

      // Button arm (long, toward operator)
      translate([0, -LEVER_W/2, 0])
        cube([BTN_L, LEVER_W, LEVER_T]);

      // Hook tip (engages latch notch)
      translate([-HOOK_L, -HOOK_TIP_W/2, LEVER_T - 0.1])
        cube([HOOK_TIP_D, HOOK_TIP_W, HOOK_TIP_H]);

      // Button cap (enlarged press face)
      translate([BTN_L - 0.1, -BTN_W/2, 0])
        cube([LEVER_T, BTN_W, BTN_H]);
    }

    // Pivot hole (centred at origin of this module)
    translate([0, 0, -0.1])
      cylinder(d=PIVOT_D, h=LEVER_T+0.2);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// PIVOT MOUNT BRACKET
// Clips to the tile outer face. Provides pivot pin housing.
// Press-fit onto tile outer rim (OR edge).
// ═══════════════════════════════════════════════════════════════════════

BRKT_W     = LEVER_W + 8;
BRKT_H     = BASE_H;
BRKT_DEPTH = 6;
PIN_D      = 3.1;   // pivot pin diameter (3mm nail or wire)

module pivot_bracket() {
  difference() {
    union() {
      // Main bracket body
      cube([BRKT_W, BRKT_DEPTH, BRKT_H], center=true);

      // Side walls that wrap over tile outer edge (C-clip)
      for(s=[-1,1])
        translate([s*(BRKT_W/2 - 1.5), -CAV_WALL/2, 0])
          cube([3, BRKT_DEPTH + CAV_WALL, BRKT_H], center=true);
    }

    // Pivot pin channel (horizontal, through bracket walls)
    rotate([0,90,0])
      translate([0, 0, -BRKT_W/2 - 0.1])
        cylinder(d=PIN_D, h=BRKT_W + 0.2);

    // Lever clearance slot (lever swings through bracket body)
    cube([LEVER_W + 0.6, BRKT_DEPTH + 0.2, LEVER_T + 1.5], center=true);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// PIVOT PIN (print this separately — acts as hinge axle)
// 3mm dia × BRKT_W long. Or use a real 3mm nail instead.
// ═══════════════════════════════════════════════════════════════════════

module pivot_pin() {
  translate([0, 40, 0])  // offset so it prints next to bracket
    cylinder(d=2.9, h=BRKT_W + 1);
}

// ═══════════════════════════════════════════════════════════════════════
// RENDER
// Print lever and bracket together (spaced apart on build plate)
// ═══════════════════════════════════════════════════════════════════════

lever_body();

translate([50, 0, 0])
  pivot_bracket();

translate([50, 0, 0])
  pivot_pin();
