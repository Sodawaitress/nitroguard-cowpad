# CowPad — Presentation Bullets
ENGN676 · 27 May 2026 · 5–7 min

---

## OPENING

- Canterbury groundwater: 386 wells, 20 years of data
- Nitrate average: 5.38 mg/L — flat for 20 years, not improving
- 62% of wells still trending upward
- 10.1% exceed NZ drinking water limit (11.3 mg/L)
- Selwyn district: 7.13 mg/L mean — worst in Canterbury
- Strongest predictor in ML model: farmland coverage within 1 km (r = 0.360)
- This is not a natural problem. It is an agriculture problem.

---

## THE SOURCE

- Cows congregate at water troughs and urinate in one spot
- Urine N concentration at trough areas: up to **600 kg N/ha**
- Safe pasture uptake: ~200 kg N/ha
- Everything above that leaches to groundwater
- Current solutions: restrict grazing, plantain pasture, nitrification inhibitors
- None of them address the trough area directly

---

## THE SOLUTION — CowPad

- Modular arc tiles that fit around any round water trough
- Each tile: 45° wedge, 5 radial V-groove channels on surface
- Urine disperses from 0.37 m² → ~2 m² → **82% N concentration reduction**
- Inside each tile: a replaceable **biochar cartridge**
- Biochar adsorbs NH₄⁺ chemically — 4–6 mg N per gram
- One-finger pull tab to replace. Spent cartridge = slow-release fertiliser
- **EC sensor tile**: Arduino Nano + two steel probes in biochar
  - Green LED = absorbing (0–60%)
  - Amber LED = nearing capacity (60–85%)
  - Red LED = replace now (>85%)
  - Rain discrimination: 3-layer (probe depth + hardware sensor + software derivative)
- Replacement interval: **every 15–20 days**
- No power. No pump. No service visits between replacements.

---

## DESIGN JOURNEY (brief — shows engineering thinking)

- V1: dispersal only — channels work, but no feedback
- V2: added GIS + ML risk mapping — know *where* to deploy
- V3: added biochar cavity + replaceable cartridge — capture the N
- V4: spring-ejection mechanism — explored, abandoned (fails under hoof compaction)
- V5: final — passive, all moving parts removed, EC sensor added

---

## BUSINESS MODEL

**Market gap (justifies the model):**
- Rubber mats: everywhere on Canterbury farms, zero N function → farmers already buying something for troughs
- Plantain programme: up to 60% N reduction, but whole-paddock only — no trough coverage
- Bulk biochar: right chemistry, wrong placement — broadcast, not point-source
- Nothing currently captures at source + IoT feedback + returns N to soil
- CowPad is not a new technology — it is a new configuration of proven components

**Who buys it:**
- Canterbury dairy farmers facing ECan nitrogen limits
- Trough suppliers (Hynds, Gallagher) — bundle with new trough purchase

**Revenue streams:**
- Hardware kit: tiles + EC sensor (~$150–300 NZD per trough)
- Cartridge subscription: replacement every 15–20 days (recurring revenue)
- N recovery: spent cartridge processed → certified slow-release fertiliser
- GIS platform: farm risk mapping dashboard (SaaS, secondary)

**Why it's sustainable:**
- Circular: N captured at trough → returned to paddock as fertiliser
- No logistics needed for V2 ballistic return model
- Trough supplier channel = no cold-start sales problem
- ECan compliance pressure = pull demand already exists

---

## SUGGESTIONS & FUTURE PLAN

**Next step — ballistic return (V2 product):**
- EC sensor triggers solenoid → spring ejects spent cartridge toward paddock
- Fresh cartridge drops from gravity magazine
- N never leaves the farm — disperses as slow-release fertiliser on-site
- Reduces service visits from every 15–20 days to every ~100 days

**Extension — silage leachate:**
- Silage pit drainage: up to 5,000 mg/L nitrate (400× drinking water limit)
- Not addressed by CowPad V1
- High-concentration cartridge variant or pit-drain module as next product

**Scaling:**
- GIS model already identifies highest-risk Canterbury farms
- Start with Selwyn district (7.13 mg/L mean) — highest urgency, clearest ROI
- ECan's 20–30 year groundwater lag means every year of delay = decade of damage

---

## Q&A — READY FOR

- Why biochar, not zeolite? → local supply, cheaper, spent material already = soil amendment, circular story
- Does it work in rain? → 3-layer rain discrimination (probe depth + hardware + software derivative)
- What about tractors? → boundary trough placement + quick-release clips; cow hoof is governing load case
- PLA for production? → No. Demo only. Production = UV-stabilised black HDPE, 20–30yr Canterbury UV rated
- Laneways? → Module B (straight strip) designed for this; tractor conflict is open design question
