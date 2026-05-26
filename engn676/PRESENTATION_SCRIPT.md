# CowPad Presentation Script
**ENGN676 · Lincoln University · 27 May 2026**
**Designer: Yu Zhou · Supervisor: Majeed Safa**

---

> 说明：`[slide]` 是换片提示，`（）` 是我给你的备注，不用念出来。可以自由改成你自己的语气。

---

## Opening

`[slide: title]`

Good morning. My project is called **CowPad** — a modular nitrogen capture system for dairy farm water troughs.

I want to start with a question: if you know that a cow can urinate six litres in one go, and that urine contains up to 600 kilograms of nitrogen per hectare — and you know that Canterbury's groundwater is already failing — what do you do?

Most solutions try to change where the cow stands, or what the cow eats.

CowPad asks a different question: *what if we just caught it at the source?*

---

## Part 1 — The Problem

`[slide: Canterbury risk map / GIS data]`

I ran a machine learning analysis on 13,433 groundwater measurements from 386 ECan monitoring wells across Canterbury, spanning 2004 to 2024.

The result was not encouraging.

- Average nitrate: **5.38 mg/L** — essentially unchanged from 20 years ago
- **10.1%** of all measurements exceed the drinking water limit of 11.3 mg/L
- **62%** of Canterbury wells are still trending upward
- The highest-risk zone: **Selwyn district at 7.13 mg/L mean** — the heart of Canterbury's dairy belt

The KNN model I trained achieved R² = 0.750. The single strongest predictor of nitrate concentration? **Farmland coverage within 1 km** — correlation r = 0.360. This is not a natural phenomenon. This is an agriculture problem.

And within that agriculture problem, the most concentrated source is one of the simplest: **cows congregate at water troughs and urinate in one spot.**

Urine nitrogen at trough areas can reach **600 kg N/ha**. Safe pasture uptake is around 200. The rest leaches straight to groundwater.

（这里停顿一下，再接设计部分。数字讲完了，现在是解决方案。）

---

## Part 2 — Design Process

`[slide: V1 diagram]`

### Version 1 — Passive Dispersal

My first idea was simple: if the concentration is too high in one spot, spread it out.

I designed a series of **arc-shaped tiles** that fit around a round trough — like a collar. Each tile has radial V-groove channels on the surface. When a cow urinates, the liquid flows outward along the channels, spreading from roughly 0.37 square metres to about 2 square metres.

That gives an **82% reduction in nitrogen concentration** — from 600 to around 110 kg N/ha — just from dispersal alone.

The tile geometry: 45-degree wedge sectors, inner radius 75 mm, outer radius 145 mm. Eight tiles make a full ring. The snap connectors on each edge are identical — male tab on one side, female slot on the other — so they click together like Lego, and fit any trough size just by how many tiles you use.

But there was a problem. Once I spread it, I still didn't know *when* the biochar had absorbed enough nitrogen. I had no feedback loop.

`[slide: V2 diagram — monitoring layer]`

### Version 2 — Adding Monitoring

Version 2 kept the tile structure but added a **GIS intelligence layer**.

The idea was to use satellite data and the ECan groundwater records — the same data I used for the ML analysis — to map risk zones across Canterbury. Which farms have the highest groundwater nitrate? Which troughs are in the most critical positions?

This became the Canterbury Risk Map you can see on the website. It lets a farmer — or a regulator — see exactly where CowPad deployment would have the highest impact.

But looking at the tiles themselves: I still hadn't solved what happened *inside* the tile. The biochar was just sitting there, and I had no way to tell when it was full.

`[slide: V3 diagram — biochar capture]`

### Version 3 — Biochar Capture + Replaceable Cartridge

This is where the design became a system rather than just a mat.

I introduced a **biochar-filled cavity** in the tile body. Urine flows down through the V-channels, passes through drain holes in a thin lid layer, and reaches the biochar. Biochar adsorbs NH₄⁺ ions chemically — published data shows 4 to 6 mg of nitrogen per gram of biochar.

The biochar sits inside a **replaceable cartridge** — a hollow arc-shaped shell that snaps into the cavity. When it's saturated, you pull a tab that sticks up through the lid, and the whole cartridge comes out in one piece. You replace it. The spent cartridge doesn't go to waste — it's a slow-release nitrogen fertiliser. It goes back to the paddock.

（这一段是整个系统最核心的部分，可以慢一点）

`[slide: V4 diagram — abandoned]`

### Version 4 — The Spring Ejection Idea (Explored, then Abandoned)

Here's where I tried something more ambitious — and learned a useful lesson.

I wanted to eliminate the service visit entirely. The idea: when the EC sensor detects that the cartridge is full, a spring-loaded platform automatically ejects the spent cartridge toward the paddock, and a gravity-fed magazine drops a fresh one into place.

I designed the mechanism. I modelled the spring, the trigger, the magazine stack.

Then I ran the stress analysis.

A dairy cow weighs up to 650 kg. A single hoof exerts around 160 kg over 150 cm². In production conditions — mud, soil ingress, repeated loading — the spring simply cannot return against hoof compaction. The mechanism jams.

**The lesson:** moving parts fail in farm environments. The more mechanical complexity I added, the more single points of failure I created. This is a design running in mud and urine for 15 to 20 days at a time.

So I abandoned Version 4. But I kept the *idea* — the ballistic return concept is still in the roadmap, as a Version 2 product, when I can engineer it properly.

`[slide: V5 diagram — final design]`

### Version 5 — CowPad Final

Version 5 removes all moving parts from the tile itself.

The layer stack is:
- **Base: 6 mm structural PLA** — load-bearing, rated for cow hoof pressure with factor of safety greater than 8×
- **Biochar cavity: 6 mm** — the replaceable cartridge slot
- **Fill: 8 mm** — load distribution layer
- **Rib surface: 6 mm** — five V-groove channels, 3.5 mm wide, 3.0 mm deep

The V-groove profile is specifically chosen for **self-cleaning hydraulics**. A V-groove maintains velocity as flow decreases — meaning even the tail end of a urination event still flushes biochar fines out. A rectangular channel wouldn't do this.

Rain self-cleaning happens automatically through the same channels.

The **EC sensor tile** is one tile in the ring that has two stainless steel probe holes through the fill layer. The probes read electrical conductivity — as biochar absorbs nitrogen ions, conductivity increases. The Arduino Nano measures this and drives three LEDs: green for absorbing, amber for nearing capacity, red for replace now.

The rain discrimination is three-layered: the probe tips sit at the *base* of the biochar, so surface rain doesn't reach them; a hardware raindrop sensor detects active rainfall and freezes the display; and a software derivative tracker watches the EC trend — a falling EC means rain dilution, so the reading is held.

The result: a passive, zero-power, zero-service-visit nitrogen capture system. The only maintenance is cartridge replacement every 15 to 20 days.

---

## Part 3 — Similar Products

`[slide: comparison table]`

Nothing in the current market combines all of these features.

**Rubber trough mats** — everywhere on Canterbury farms. Hoof comfort, no nitrogen management.

**DairyNZ plantain programme** — impressive, up to 60% N reduction. But it requires whole-paddock resowing. It doesn't help at holding yards, laneways, or trough areas — the most concentrated zones.

**Bulk biochar amendments** — proven chemistry. Biochar adsorbs NH₄⁺ with 4 to 6 mg per gram. But applied broadcast across a paddock, you're using expensive material where most of the nitrogen isn't.

**TrapView by Pessl Instruments** — IoT pest trap monitoring. Threshold triggered, alert sent, service visit scheduled. CowPad borrows exactly this model. The only difference is what's in the trap.

**FBN / Farmers Business Network** — satellite imagery and farm intelligence. CowPad borrows the spatial risk mapping logic and applies it to Canterbury-specific ECan data.

CowPad is not a new chemistry. It's not a new sensor. It's **a new configuration** — point-source capture, biochar chemistry, IoT feedback, and nitrogen recovery, all in one replaceable cartridge.

---

## Part 4 — Suggestions and Future Plan

`[slide: future roadmap]`

There are three honest limitations I want to address.

**First: the ballistic return model.** Version 4 showed that in-tile spring mechanisms fail. But the core idea — zero collection, automatic on-farm redistribution — is worth pursuing. The Version 2 roadmap uses an external spring magazine with a solenoid trigger, positioned outside the trough ring, calibrated to land cartridges in the paddock interior. The Canterbury GIS layer already distinguishes high-risk zones from low-risk zones, so the ejector fires toward low-risk paddock centre. No logistics chain. No fertiliser sale. Zero leaching.

**Second: silage leachate.** While researching Canterbury nitrogen sources, I found one I hadn't anticipated — silage pit leachate. The liquid that drains from silage pits has nitrogen concentrations up to 5,000 mg/L — more than 400 times higher than the drinking water limit. CowPad Version 1 doesn't address this at all. A high-concentration cartridge variant, or a dedicated pit-drain filtration module, would be a meaningful extension.

**Third: the 20-to-30-year lag.** I said earlier that Canterbury's groundwater hasn't improved in 20 years. That's not because nothing has been done — it's because groundwater responds slowly. Even if every Canterbury farm adopted CowPad tomorrow, you wouldn't see it in the ECan data for another two decades. That's actually the strongest argument for starting now.

（最后这句是你的结尾，语气要收得稳一点）

`[slide: final / title]`

CowPad is a small product solving one part of a large problem — cow urine at water troughs.

What I tried to show is that you can design something that is **passive, modular, measurable, and circular** — without requiring behaviour change from the farmer, without requiring new infrastructure, and without sending nitrogen anywhere it wasn't already going.

Thank you.

---

## Q&A Preparation

**Expected questions and suggested answers:**

**Q: Why biochar and not zeolite or another adsorbent?**
Biochar can be produced from agricultural waste — including dairy farm waste. It's cheaper than zeolite, widely available in NZ, and the spent material is already classified as a soil amendment. The circular economy story is cleaner.

**Q: How do you stop urine running off the tile before it reaches the biochar?**
The V-groove channels are angled radially outward, but the drain holes in the lid are positioned at the mid-radius — where the urine pools before it can escape. The lid creates a moment of dwell time. In the sensor tile, the probe tips are at the base precisely because that's where the liquid accumulates.

**Q: What about in winter, when grazing is restricted?**
Canterbury winters typically reduce trough congregation. The replacement interval extends naturally — the cartridge lasts longer when the herd is on a stand-off pad or supplement feeding. Seasonal adjustment is a feature, not a bug.

**Q: Is PLA actually suitable for outdoor Canterbury conditions?**
Not for production — I'm clear about that in the report. PLA is UV-sensitive and hydrolysis-prone. The demo uses PLA for cost and 3D-printability. Production material is UV-stabilised black HDPE, which lasts 20 to 30 years in Canterbury UV index 11–12 conditions.

**Q: Could this work in laneways, not just troughs?**
Yes, and that's actually a higher-priority nitrogen zone — laneways see twice-daily cow movement. Module B (straight strip tile) is designed for exactly this. The tractor conflict on laneways in winter is the current design constraint that needs resolving.

---

*Script ends. Total estimated speaking time: ~10–12 minutes.*
