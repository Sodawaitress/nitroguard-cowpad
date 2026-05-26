# CowPad — 3D Print Guide
ENGN676 Demo Prototype · Lincoln University Library Printer

---

## Print list

### Core demo (4 pieces · ~7–9 hr · submit today)
| File | Copies | Demonstrates |
|---|---|---|
| `cowpad_tile_arc.scad` | **2** | snap connection + channels + ribs |
| `cowpad_tile_sensor.scad` | **1** | EC probe holes + wire channel |
| `cowpad_cartridge.scad` | **1** | biochar replacement |

### V2 ejector system (4 pieces · ~3–4 hr · print separately)
| File | Copies | Demonstrates |
|---|---|---|
| `cowpad_eject_platform.scad` | **1** | spring-flip platform with launch ramp |
| `cowpad_spring.scad` | **2** | coil spring — print vertical, 100% infill, 20mm/s |
| `cowpad_eject_magazine.scad` | **1** | gravity cartridge stack (mounts on trough wall, not tile top) |
| `cowpad_eject_trigger.scad` | **1** | manual trigger lever + pivot bracket |

Total for everything: ~500–600g PLA · ~12–13 hr
Print core set first. If time allows, add ejector system.

---

## Export STL from OpenSCAD

1. Download OpenSCAD free: **openscad.org**
2. Open each `.scad` file
3. Press **F6** (render)
4. File → Export → Export as STL
5. Upload STL to library printer queue

---

## Print settings

| Setting | Value |
|---|---|
| Layer height | 0.2mm |
| Infill | 20% gyroid |
| Supports | **NONE** |
| Orientation | Flat base DOWN (ribs on build plate) |
| Material | PLA |

---

## Demo sequence (3 minutes)

**1. Snap together** (30 sec)
Press tile 1 and tile 2 edge-to-edge. Tab clicks into slot.
Say: *"Same connector on every tile — LEGO principle. In production, 8 tiles ring a full trough."*

**2. Show channels** (20 sec)
Tilt tile, show radial grooves on top.
Say: *"Urine hits here, channels spread it from 0.37m² to 2m² — 82% lower N concentration."*

**3. Show ribs** (20 sec)
Flip tile, show structural ribs on bottom.
Say: *"5 ribs. FoS >8× for cow hoof load. 450kg cow, 4 hooves, 150cm² contact = 1.1 kg/cm²."*

**4. Replace cartridge** (30 sec)
Grab pull tab, lift cartridge out. Drop in new one.
Say: *"Biochar saturated after ~15 days. Pull tab, swap cartridge, done. Gas-cylinder model."*

**5. Sensor demo** (60 sec)
Pick up sensor tile with Arduino connected.
Drip salt water into probe holes.
LED: green → amber → red.
Say: *"Conductivity rises as biochar absorbs nitrogen. Red = replace now. In V2 this pings the farmer's phone via LoRa."*

---

## After printing: prep the cartridge

1. Fill cartridge shell with real biochar granules (from Bunnings garden section or Countdown)
2. Cover top with a small piece of mesh fabric (cut from onion bag or gauze)
3. Insert into any tile's fill cavity

---

## Sensor wiring (Arduino Nano)

```
Nail probe 1 ──── A0 pin + 10kΩ resistor to 5V
Nail probe 2 ──── GND
Green LED ─────── D9 (220Ω resistor)
Amber LED ─────── D10 (220Ω resistor)
Red LED ────────── D11 (220Ω resistor)
```

Threshold logic:
- resistance > 8kΩ → green (absorbing, 0–60%)
- 4kΩ–8kΩ → amber (monitoring, 60–85%)
- < 4kΩ → red (replace now, >85%)

All components from **Jaycar, 295 Moorhouse Ave, Christchurch Central**.
