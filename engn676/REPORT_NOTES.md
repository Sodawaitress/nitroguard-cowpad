# CowPad — Report Writing Notes
*Design journey, key insights, human moments*
*For ENGN676 report (due 26 May) + presentation (27 May)*

---

## The Design Journey — Iterations Worth Telling

### Iteration 1: The Original Idea
"Cows don't care where they urinate — but Canterbury's groundwater does."
Simple observation. Trough = congregation point = concentrated nitrogen patch.
Solution: spread it out. Physics, no power, no app.

**What's interesting here:** The insight came from noticing *behaviour*, not chemistry.
Cows are creatures of habit. They drink, they linger, they urinate in roughly the same spot
every day. The problem is predictable — which means the solution can be too.

---

### Iteration 2: From Dispersal to Capture
Early version: just spread the urine across a bigger area (0.37m² → 2m²).
That reduces concentration by 82%. That's good.

But then the question came: *what happens to the nitrogen after you spread it?*
It still goes into the soil. It still leaches.

**The shift:** Don't just disperse the problem. *Capture it.*
Biochar absorbs nitrogen. Saturated biochar returned to field = slow-release fertiliser.
The nitrogen that was a pollutant becomes an asset.

This is the moment the project changed from "mitigation" to "nutrient recovery."
That reframing matters — it changes the value proposition entirely.

**Worth writing in report:** The design process wasn't linear.
The first version solved the wrong problem more efficiently.

---

### Iteration 3: Biochar — Is It Real?
Question: can biochar actually absorb nitrogen from urine?
Answer from literature: yes. Specifically —
- 6 mg/g NO₃⁻-N, 4 mg/g NH₄⁺-N (published)
- Urine-Enriched Biochar (UEBC) already researched as slow-release fertiliser
- 40–50% nitrogen recovery from urine (Frontiers, 2024)

**The human moment:** The idea felt speculative. The literature confirmed it wasn't.
This is what research does — it either kills your idea or gives it ground to stand on.
Biochar got ground.

---

### Iteration 4: The Material Question
Can biochar be 3D printed?
- Biochar-PLA composite at 4 wt% = +20% tensile strength. Real research.
- No commercial filament yet. DIY only via twin-screw extruder.

**The interesting tension:** The "right" material doesn't exist commercially yet.
The project is pointing at a gap in the materials market, not just a gap in farm practice.
V1 uses plain PLA (printable today). V3 uses biochar-PLA composite (research stage).
The roadmap from prototype to product crosses a materials science frontier.

Also: Bounty Gel (video) — hydrogel that absorbs 150× its weight in water,
biodegrades in 3 years. Combine with biochar? Composite that absorbs both N and water?
That's a new material worth naming.

---

### Iteration 5: The LEGO Insight
Original design: 4 separate module types for different troughs.
Problem: too many SKUs, manufacturing complexity, farmers won't stock 4 types.

**The reframe:** What if it's not 4 modules — it's one connector system?
Same clip on every edge. Same biochar cartridge in every tile.
Different tile *shapes*, but one *language*.

Like LEGO: the stud is always the same. The bricks are different. You get infinite configurations.

**Why this matters for the report:** This isn't just an engineering decision.
It's a design philosophy decision — choosing compatibility over optimisation.
A slightly-less-perfect fit for every trough, but a system that scales.

---

### Iteration 6: The Farm Operations Reality Check
*"This pad will be on the ground. What else is on the ground?"*

Canterbury dairy farms aren't fields — they're dynamic systems:
- Tractors (4,000–8,000 kg) enter every paddock multiple times a year
- Centre pivot towers (2,000–4,000 kg/tower) walk circular paths
- Portable troughs move every 2–3 days with rotational grazing
- Silage harvesters in summer. Feed wagons in winter.

**The uncomfortable discovery:** The current rib structure handles cow hooves (FoS >8×).
It does NOT handle a tractor tyre. The pad would get crushed in silage season.

**Options this opens:**
1. Position only at boundary troughs (tractors don't cross fences)
2. Quick-release design — farmer pulls pads before tractor work, replaces after
3. Flush/recessed design — pad sits below ground surface, wheels roll over
4. Separate product for laneway use (where tractors sometimes go)

**The human moment worth keeping:** The tractor question didn't invalidate the design.
It *located* it. The pad works *here* (boundary troughs, laneways) and *not here*
(interior paddock, pivot zones). Good design knows its domain.

---

### Iteration 7: The Uncomfortable Discovery
*"Where is nitrogen concentration actually highest on a Canterbury dairy farm?"*

Expected answer: trough areas.
Actual answer: **laneways first, holding yards second, shade areas third, troughs fourth.**

Cows walk laneways twice a day. They wait in holding yards for 30–60 minutes.
Both zones have higher congregation + higher urine density than trough areas.

**What this means for CowPad:**
- Current design solves the fourth-worst N problem
- Module B (straight strip) could line laneways — much higher impact
- But laneways have tractor traffic too (winter feed delivery)

**Why this belongs in the report:**
Not as a failure — as intellectual honesty.
The best designs acknowledge their own limitations and point toward what comes next.
"CowPad V1 addresses point-source N at troughs. The module system is designed to extend
to laneways (V2) and holding yards (V3) where N loading is even higher."
That's not a weakness. That's a roadmap.

---

### Iteration 8: Three Layers Emerge
The project grew from a pad into a system:
- Layer 1: Hardware (the pad)
- Layer 2: IoT sensor (knowing when to replace)
- Layer 3: Software (knowing where to deploy)

**The connection:**
Each layer answers a different question:
- Layer 1: *How* do you reduce N at the source?
- Layer 2: *When* do you replace the cartridge?
- Layer 3: *Where* on Canterbury's farms does this matter most?

**Industry validation:** Every layer maps to a real commercial product:
- Layer 1 ← Bounty Gel (absorbent material design)
- Layer 2 ← TrapView (IoT sensor → threshold → alert)
- Layer 3 ← FBN satellite imagery + Trace Genomics + Drone data

The project isn't speculative. It's assembling proven concepts into a configuration
that doesn't exist yet.

---

### Iteration 9: The Ballistic Fertiliser Insight

*"If the biochar is already fertiliser when saturated — why collect it at all?"*

V1 business model assumes a collection loop: service company comes, takes
saturated cartridges, processes them offsite, sells fertiliser back to farmers.
This is the Rockgas model. It works, but it has logistics cost, service frequency
(every 15–20 days), and complexity.

**The reframe:** Canterbury's GIS layer already shows which zones are high-risk
(trough areas, near waterways) and which are low-risk (paddock interior, away
from drainage). Those low-risk zones are exactly where slow-release nitrogen
fertiliser is beneficial — and exactly where a spring-launched cartridge can land.

Auto-eject the saturated cartridge toward the paddock centre:
- Biopolymer shell degrades in soil over weeks
- Nitrogen releases slowly to pasture root zone
- No truck. No processing. No logistics.

**Why this changes the value proposition entirely:**
V1 reduces leaching. V2 eliminates leaching *and* auto-fertilises.
The nitrogen doesn't leave the farm. It moves from the wrong place
(concentrated near trough → groundwater) to the right place
(distributed across paddock → pasture roots).

**Worth writing in report:**
This wasn't the original design. It emerged from questioning whether
collection was actually necessary — and realising the GIS system that
maps *where pads should go* also implicitly maps *where spent cartridges
can safely land*.

The two layers (hardware + software) turned out to be more connected
than initially designed.

---

## Punchy Lines Worth Using

> "Cows don't care where they urinate — but Canterbury's groundwater does."
*(original project description — keep this, it's the best opening line)*

> "The nitrogen that was a pollutant becomes an asset."
*(the moment dispersal became recovery)*

> "Good design knows its domain."
*(on the tractor/paddock constraint)*

> "Not four modules — one language."
*(on the LEGO connector insight)*

> "The literature either kills your idea or gives it ground to stand on. Biochar got ground."
*(on research validation)*

> "CowPad V1 addresses point-source N at troughs. The system is designed to extend
to laneways and holding yards where N loading is even higher."
*(turning the limitation into a roadmap)*

> "The nitrogen doesn't leave the farm. It moves from the wrong place to the right place."
*(on the ballistic return model — zero collection, zero waste)*

> "The GIS layer that maps where pads should go also maps where spent cartridges can safely land.
The two layers turned out to be more connected than initially designed."
*(on the emergent connection between Layer 3 and V2 ejection logic)*

> "Every layer of this system maps to a real commercial product. We're not inventing
the components — we're assembling them in a configuration that doesn't exist yet."
*(on the three-layer architecture)*

---

## Report Structure Suggestion

**1. Introduction (0.5 page)**
- Canterbury N problem, Christchurch drinking water
- Gap: no passive point-source N capture at trough level
- Open with the cow line

**2. Design Process (1.5 pages)**
- Tell the iteration story (dispersal → capture → modular → system)
- Include the design decisions that were *rejected* and why
- The tractor discovery, the laneway discovery
- This is the most interesting part — don't flatten it into a bulleted list

**3. Final Design (1 page)**
- Three layers, component system, materials roadmap
- Key numbers: 82% N reduction, 15-20 day replacement interval
- Load analysis

**4. Business Model + Sustainability (0.5 page)**
- Circular economy: pad shell permanent, cartridge replaceable
- Gas cylinder swap analogy
- N fertiliser recovery value

**5. Limitations + Future Work (0.5 page)**
- Tractor load, centre pivot, laneway opportunity
- Honest about what V1 doesn't solve
- Points toward V2/V3

---

## Things to Show in Presentation (not just say)

1. **3D configurator** — live demo, change trough type, show explode view
2. **Working sensor** — pour liquid onto pad, watch LED change colour
3. **The five parts** — physical cardboard pieces, snap them together live
4. **Canterbury map** — show where N-risk troughs are (Mapbox mockup)
5. **The Bounty Gel / TrapView / FBN slide** — "we didn't invent the components"
