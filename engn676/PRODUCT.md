# CowPad — Product Document
**ENGN676 Agricultural Engineering Design Project**
Lincoln University · Semester 1, 2026
Designer: Yu Zhou · Supervisor: Majeed Safa

---

## 1. Problem

Dairy cows congregate near water troughs and urinate in concentrated patches.
- Urine nitrogen concentration at trough areas: up to **600 kg N/ha**
- Safe pasture uptake limit: ~200 kg N/ha
- 42% of Canterbury farmers report nitrogen leaching issues (Safa et al., 2018)
- Christchurch drinking water drawn from Canterbury groundwater

Current approaches (restrict grazing, stand-off pads, nitrification inhibitors) are costly,
require behaviour change, or have limited efficacy at point-source.

---

## 2. Core Concept

**CowPad** is a modular, passive urine-dispersal and nitrogen-capture platform
installed around dairy farm water troughs.

> Instead of fighting the problem, capture it at the source and turn it into a resource.

Two mechanisms working together:
1. **Disperse** — radial channels spread urine from ~0.37 m² to ~2 m²,
   dropping N concentration below pasture uptake threshold
2. **Absorb** — biochar + hydrogel composite fill captures remaining N
   before it reaches soil

Captured nitrogen recovered as slow-release fertiliser when cartridges are replaced.

---

## 3. System Architecture (3 Layers)

### Layer 1 — Hardware: Modular Pad Platform

**Lego-style component system. Same connector on every piece.**

#### Part 1 — Arc Tile
- Shape: 45° wedge sector
- Inner radius: adapts to trough diameter (clip adjustment)
- Pad width: 600 mm (configurable 300–900 mm)
- Thickness: 50 mm (30 mm fill layer + 20 mm structural base)
- Use: 8 tiles = full ring around round trough (Hynds 1100L/750L/515L)
- Structure: 5 longitudinal ribs, factor of safety >8× for cow hoof load (~180 kg/hoof)

#### Part 2 — Straight Tile
- Size: 600 × 600 mm per unit
- Use: long sides of rectangular troughs, chain end-to-end
- Structure: honeycomb infill base (40% density)

#### Part 3 — Corner Tile
- Shape: L-piece, 600 × 600 mm arms
- Use: corners of rectangular troughs
- Structure: diagonal ribs (corner stress concentration)

#### Part 4 — Biochar Cartridge (replaceable inner fill)
- Material: biochar + hydrogel composite
  - Biochar: 6 mg/g NO₃⁻-N, 4 mg/g NH₄⁺-N absorption (published data)
  - Hydrogel (ref: Bounty Gel): absorbs 150× weight in water, 3-year biodegradation
  - Composite target: 4 wt% biochar in biopolymer binder (+20% structural strength)
- Snaps into any tile type (standardised slot)
- End of life: pull → return → process into slow-release N fertiliser
- Target: fully biodegradable biopolymer shell + biochar fill

#### Part 5 — Universal Clip
- Quarter-turn bayonet connector
- Same male/female profile on every tile edge
- Angular tolerance: ±10° (allows arc-to-straight joins)
- Material: stainless steel or UV-stable ABS

**Load bearing:**
Dairy cow 450–650 kg · 4 hooves · ~160 kg/hoof · ~150 cm² contact
= ~1.1 kg/cm² pressure
PLA compressive strength ~50 MPa → ribbed structure FoS >8×

**NOTE: Tractor load NOT covered by current rib design — see Section 6 (Farm Operations)**

**Kit by trough type:**

| Trough | Arc | Straight | Corner | Cartridge | Clips |
|--------|-----|----------|--------|-----------|-------|
| Round 1100L (⌀1750mm) | 8 | 0 | 0 | 8 | 16 |
| Round 515L (⌀1600mm) | 8 | 0 | 0 | 8 | 16 |
| Rect Large (2400×600mm) | 0 | 2 | 4 | 6 | 12 |
| Portable (⌀900mm) | 4 | 0 | 0 | 4 | 8 |

---

### Layer 2 — IoT: Saturation Sensor (Working Prototype)

**Inspired by TrapView (real-time IoT pest trap data)**

#### Sensor: Electrical Conductivity (EC) Probes
- Two stainless steel probes embedded in biochar fill layer
- As biochar absorbs N → ionic concentration ↑ → conductivity ↑ → resistance ↓
- Arduino Nano measures resistance between probes via voltage divider
- Threshold triggers LED colour change + optional buzzer

#### Prototype Circuit (Jaycar, ~$45 NZD)
- Arduino Nano (ZK-4100) ~$25
- 5mm LED × 3 red/yellow/green (ZD-0150) ~$3
- 220Ω resistors × 3 (RR-0556) ~$2
- Stainless steel nail probes × 2 ~$2
- Breadboard (PB-8820) ~$8
- Jumper wires (WC-6024) ~$5

Jaycar: 295 Moorhouse Ave, Christchurch Central

#### Indicator States
| Conductivity | LED | Meaning |
|---|---|---|
| Low | Green | Absorbing actively (0–60%) |
| Medium | Amber | Nearing capacity (60–85%) |
| High | Red | Replace cartridge now (>85%) |

#### Full System (V2 — for report/presentation, not prototype)
```
EC sensor threshold exceeded
        ↓
ESP32 + LoRa/NB-IoT transmit
        ↓
Cloud platform aggregates farm sensors
        ↓
Push notification → farmer app + service company
        ↓
Collection route auto-scheduled
```

---

### Layer 3 — Software: Satellite GIS + Farm Intelligence

**Inspired by FBN satellite imagery + Trace Genomics + Drone data**

#### Features
1. Canterbury Farm Mapper — satellite/drone imagery, AI trough detection,
   soil permeability overlay, N-leaching risk score per trough
2. Smart Deployment Planner — input farm → output correct kit + replacement interval
3. Collection Route Optimizer — aggregate saturation alerts, schedule service vehicle
4. Dashboard — real-time Canterbury N reduction map, fertiliser value recovered

#### Tech Stack
- Frontend: Mapbox GL JS + React
- Backend: Node.js / Express
- IoT: MQTT broker
- DB: PostgreSQL + PostGIS
- Satellite: Sentinel-2 (ESA, free) or Planet Labs

**3D Configurator already built:** `cowpad_configurator.html`

---

## 4. Materials Roadmap

| Version | Structure | Fill | Notes |
|---------|-----------|------|-------|
| Prototype (now) | Cardboard | Biochar granules + burlap | Demo only |
| V1 | PLA 3D print | Biochar granules in tray | University makerspace |
| V2 | Biochar-PLA composite (4 wt%) | Same | DIY extruder |
| V3 (target) | Biodegradable biopolymer (PHA/PLA blend) | Biochar + hydrogel | Fully circular |

---

## 5. N Reduction Calculations

Scenario: Hynds 1100L round trough, 80 cows, pad width 600mm

- Urine patch without pad: 0.37 m²
- Urine patch with CowPad: ~2.0 m²
- Area factor: 5.4×
- N concentration reduction: **~82%** (600 → ~110 kg N/ha)
- Remaining N captured by biochar before reaching soil

**Replacement interval:**
- N per event: ~2 L × 8 g/L = 16 g N
- Events/day: 80 cows × 3 = 240
- Daily N load: ~3,840 g
- Cartridge capacity (8 modules): ~2,400 g N
- **~15–20 days between replacements**

---

## 6. Farm Operations Compatibility ⚠️

*This section captures open questions and design constraints
from Canterbury pastoral farming reality.*

### Canterbury Dairy Farm Structure
- **Scale**: Canterbury Plains farms average 200–600 ha, 400–800 cows
- **System**: Rotational grazing — herd moves through 50–80 paddocks,
  each grazed 2–3 days, rested 20–30 days
- **Irrigation**: Centre pivot (common in Canterbury) or K-line/hard hose

### Annual Activity Cycle (people, animals, machinery)

| Season | Month | Activity | Who/What moves |
|--------|-------|----------|----------------|
| Calving | Jul–Sep | Cows calving in paddocks, close monitoring | Farmer daily rounds, vet, motorbike |
| Spring flush | Sep–Oct | Rapid grass growth, N fertiliser applied | Spreader truck, tractor |
| Main milking | Oct–Mar | Twice-daily milking, rotational grazing | Cows walk laneways 2×/day, irrigation running |
| Silage making | Nov–Jan | Cut, wilt, wrap grass for winter feed | Large tractor + harvester, heavy machinery |
| Autumn dry-off | Mar–May | Cows stop milking, paddocks rested | Less movement, effluent spreading |
| Winter feeding | May–Jul | Supplement feeding, restricted grazing | Tractor with feed wagon, stand-off pad use |

### Key Movement Corridors
1. **Laneways** — cows walk twice daily between paddocks and dairy shed
   - Highest N concentration on farm (not just trough areas)
   - High foot traffic, some tractor access
2. **Dairy shed holding yard** — cows wait pre-milking, concentrated N
3. **Trough areas** — CowPad target zone
4. **Paddock interior** — tractor access needed for silage, fertiliser

### Design Constraints Identified

**Problem 1: Tractor load**
- Farm tractors: 4,000–8,000 kg
- Tyre contact pressure: ~2–4 kg/cm² (wider than cow hoof)
- Current rib structure NOT designed for tractor load
- **Options:**
  a. Position pads only at permanent boundary troughs (tractors don't cross)
  b. Design quick-release system: pull pads before tractor work, replace after
  c. Engineer pad for tractor load (steel-reinforced base → adds cost/weight)
  d. Use pad only in laneways/holding yards where tractors excluded

**Problem 2: Centre pivot irrigation**
- Pivot tower wheels travel across entire paddock
- Tower wheel load: ~2,000–4,000 kg per tower
- If trough is inside pivot area, pad will be run over repeatedly
- **Options:**
  a. Locate troughs outside pivot radius (paddock boundary)
  b. Design collapsible/foldable pad that flattens under wheel load and springs back
  c. Recessed pad design — sits flush with ground, pivot wheels roll over without impact

**Problem 3: Portable trough movement**
- Portable troughs moved every 1–3 days with rotational grazing
- Pad must either:
  a. Move with trough (needs quick-disconnect + carry handles)
  b. Be left in place and trough brought to pad each rotation
  c. Use universal ground tiles (Module D) deployable anywhere

**Problem 4: Laneway opportunity**
- Laneways may have HIGHER N concentration than trough areas
- Linear strip design (Module B) could line laneways
- But tractors also use laneways for feed delivery in winter
- Pad would need to be flush/removable in laneways

### Design Response (to be resolved)

| Constraint | Proposed solution | Priority |
|---|---|---|
| Tractor load | Boundary trough placement + quick-release clips | High |
| Centre pivot | Recessed flush design OR boundary placement | High |
| Portable trough | Carry handles + sub-10 min deploy/pack | Medium |
| Laneway use | Flush ground tile variant (Module D, 30mm) | Medium |

---

## 7. Industry Analogues

| CowPad Component | Analogue | Borrowed |
|---|---|---|
| Biochar+hydrogel fill | Bounty Gel (150× water absorption, 3yr biodegradable) | Absorbent + biodegradable material concept |
| Saturation sensor | TrapView (IoT pest trap, real-time data push) | Sensor → threshold → automatic alert |
| Satellite GIS | FBN (free satellite imagery, NDVI, 3-5m) | Farm-level N risk mapping |
| Soil N data | Trace Genomics (soil DNA + ML) | Data-driven deployment decisions |
| Farm integration | Bovcontrol ("internet for cows") | Connect to existing farm management |
| Cartridge market | Full Harvest (B2B surplus marketplace) | N-biochar as tradeable commodity |
| Risk zone mapping | Drone data (2–4 km²/day, sensors) | Drone survey → trough + N hotspot ID |

---

## 8. Business Model

### V1 — Manual Collection (current prototype logic)

```
Farmer buys starter kit (shells, permanent)
        ↓
Subscription: cartridge replacement service (~every 15–20 days)
        ↓
Saturated cartridges collected → N content tested
        ↓
Processed into slow-release N fertiliser
        ↓
Sold to farmers / fertiliser market
        ↓
Revenue offsets collection cost
```

Model analogue: Gas cylinder swap (Rockgas/Elgas NZ)

---

### V2 — Ballistic Return (zero-collection model)

**The key insight:** UEBC (Urine-Enriched Biochar) is already a slow-release
fertiliser the moment it is saturated. It does not need to leave the farm.

```
EC sensor threshold exceeded
        ↓
Solenoid releases spring-loaded ejector
        ↓
Saturated cartridge launches toward paddock interior
        ↓
Biopolymer shell contacts soil → begins degrading (3-year cycle)
        ↓
Nitrogen releases slowly to pasture root zone over weeks
        ↓
New cartridge drops from gravity magazine → sensor resets
```

**Why this works:**

The Canterbury GIS layer (Layer 3) already distinguishes high-risk zones
(trough congregation areas, near waterways) from low-risk zones (paddock
interior, away from drainage channels). The ejector fires *toward* the
low-risk zone — typically the paddock centre on Canterbury's flat plains.

Nitrogen never leaves the farm. It moves from the wrong place (concentrated
at trough, leaching to groundwater) to the right place (dispersed across
paddock, slow-released to pasture). Zero waste. Zero collection logistics.

**Value proposition upgrade:**

| | V1 (collection) | V2 (ballistic) |
|---|---|---|
| N fate | Off-farm processing | On-farm slow-release |
| Service visits | Every 15–20 days | Every ~100 days (refill magazine) |
| Logistics chain | Collection → transport → processing → sale | None |
| Business model | Subscription + fertiliser revenue | Subscription only |
| Environmental claim | Reduces leaching | Zero leaching + auto-fertilises |

**Magazine design:**
- 5-cartridge gravity stack above fill cavity
- Spring-loaded ejector pin held by solenoid
- Ejection angle: fixed toward paddock centre (pre-set at installation)
- Ejection range: 5–15m (spring tension adjustable)
- Collection tray: not required

**Remaining design question:**
Consistent trajectory. Spring force must be calibrated to land cartridge
in low-risk zone regardless of wind. V2 prototype uses fixed-angle launch
tube; V3 could use GPS-confirmed landing zone validation via drone survey.

---

## 9. Deliverables

| Date | Item | % | Status |
|------|------|---|--------|
| 22 May | Prototype — cardboard + working EC sensor + biochar | 10% | ⬜ |
| 26 May | Report — 4-5 pages, design process + business model | 20% | ⬜ |
| 27 May | Presentation — full 3-layer system | 20% | ⬜ |

### Prototype build list (22 May)
- [ ] Round trough model (cardboard cylinder, ~20cm, 1:10)
- [ ] Arc Tile × 1 (cardboard + radial channels + biochar in burlap)
- [ ] Straight Tile × 1 (cardboard)
- [ ] Universal Clip × 1 enlarged demo
- [ ] Biochar Cartridge × 1 (removable tray concept)
- [ ] **Working EC sensor: Arduino Nano + probes + LEDs** ← real hardware
- [ ] pH colour strip on cartridge surface

### Software (for presentation)
- [x] 3D Configurator (`cowpad_configurator.html`)
- [ ] Canterbury farm map mockup (Mapbox)
- [ ] Collection route mockup

---

## 10. References

- Safa et al. (2016). CIGR AgEng — wind protection for centre pivots
- Safa et al. (2018). Irrigation and Drainage — Canterbury farmer wind damage survey
- Alvaro et al. — Urine patch framework
- Chikazhe et al. (2023) — N leaching mitigations, Canterbury dairy
- Bounty Gel / hydrogel soil additives — UC Davis broccoli trial
- Biochar-PLA composite (4 wt%): +20% tensile strength — ResearchGate 2024
- Urine-Enriched Biochar (UEBC) slow-release fertiliser — ScienceDirect 2021
- Modified biochar: 40–50% N recovery from urine — Frontiers Env. Science 2024

---

## 11. Structural & Material Engineering Basis

### Load Cases

| Load case | Value | Source |
|---|---|---|
| Static hoof load | ~160 kg per hoof | 650 kg cow ÷ 4 |
| Dynamic multiplier (walking) | ×2.0–2.5 | JDS biomechanics study |
| **Design point load** | **400 kg** | Conservative design |
| Peak hoof contact pressure (rubber) | 72–87 N/cm² | PMC6119319 ex-vivo study |
| Tractor ground pressure (field) | ~0.8–1.2 kg/cm² | Fendt/JD 180hp specs |
| Centre pivot tower load | ~1,000 kg quasi-static | Valley/Reinke Canterbury |

Tractor pressure < cow hoof peak pressure → cow hoof is the governing load case.

### Acceptable Deflection
Commercial rubber mats with **5–15 mm elastic deflection** under hoof load are associated with reduced lameness. Floor surfaces with zero deflection (concrete) cause 83% more abrasive wear. Target: ≥3–5 mm local compliance at hoof contact.

### Rib Design (structural ribs, bottom of tile)
From injection-moulded plastics engineering standards:
- **Rib height = 2.5–3× wall thickness** → reduces plate deflection by ~90%
- **Rib thickness = 50–70% of wall thickness** (prevents sink marks)
- **Rib spacing = 3–5× rib height**

Demo (1:8 PLA): RIB_H=6mm, RIB_W=3mm, N_RIB=7  
Production (HDPE 5mm wall): RIB_H=12–15mm, RIB_W=3mm, spacing 40–50mm

### Drainage Channel Cross-Section
From Journal of Hydraulic Research (self-cleaning open channels):

| Profile | Self-cleaning | Notes |
|---|---|---|
| **V-groove (60°)** | **Best** | Velocity increases as flow drops → flushes fines |
| Rectangular | Moderate | Corners accumulate biochar particles |
| U-groove | Good | Hard to injection-mould |

Adopted: **V-groove, 60° included angle, depth 3mm, top width 3.5mm**  
Self-cleaning velocity threshold: 0.6–0.75 m/s (biochar fines ~1mm particle size)

### Urine Flow
- Mean volume per urination event: **2.0–2.5 L** (up to 6.4 L)
- Frequency: 10–12 events/day
- Peak flow: ~2–6 L/min
- Channel capacity far exceeds hydraulic requirement — design constraint is self-cleaning, not flow capacity

### Joint Design
- Research: joint gap >3mm catches cow hooves → lameness risk
- Adopted: **1mm chamfer on all tile top edges** at radial joints
- Snap-fit clearance: 0.4mm per side (within 0.5–1.5mm optimal range)
- Ring geometry is self-locking: inner trough wall provides radial confinement; no bolts needed

### Material Selection (Production)

| Property | HDPE (UV-stabilised) | SBR Rubber | PLA (demo only) |
|---|---|---|---|
| Canterbury UV (index 11–12) | 20–30 yr (black, 2–3% carbon black) | 10–20 yr | Weeks–months |
| Urine pH 7.3–8.7 | Excellent | Good | Poor (hydrolysis) |
| Freeze-thaw (Canterbury: 0–50mm frost) | Excellent | Excellent | Degrades |
| Shore A hardness | N/A (rigid) | 55–70 (walkway grade) | N/A |
| Recommendation | **Primary choice** | Alternative | Demo only |

Canterbury UV note: UV index 11–12 = "Extreme" (WHO scale). Higher than equivalent Northern Hemisphere latitudes due to Southern Ocean ozone thinning. UV-stabilised black HDPE required for Canterbury outdoor installation.
