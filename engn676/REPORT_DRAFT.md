# NitroGuard · CowPad
## Passive Nitrogen Capture at Dairy Farm Water Troughs
**ENGN676 Agricultural Engineering · Lincoln University · 2026**
Yu Zhou · Supervisor: Majeed Safa

---

## 1. Introduction

When I first moved here, I was surprised that people drink directly from the tap — and this tap water comes from underground aquifers that sit directly below Canterbury's dairy farms. Though Kiwis are proud of their water resources, after research I found many warnings about underground water nitrate pollution. Many Chinese people I know are very alert about this — they have experienced far more severe pollution and always filter their drinking water.

However, a normal filter cannot tackle the real problem. Unless you use reverse osmosis (RO) technology — which some rural households here do use (Taumata Arowai, 2022) — standard filters do not remove nitrate. Nitrate in drinking water is linked to colorectal cancer — standard filters do not remove it, and long-term exposure increases the risk (Schullehner et al., 2018).

I wondered why these areas use groundwater instead of treated municipal water like big cities do. After research, I found that building municipal water infrastructure is far more expensive than preventing nitrogen leaching at the source. On top of that, RO technology is expensive and produces a large amount of wastewater — using it at city scale is not practical. The better solution is to address the problem at the source: nitrogen leaching itself.

I realised there is a gap here. Protecting underground water is urgent for everyone's health, and finding a cheap, consistent, and achievable solution is far more realistic than building new infrastructure.

So I started to find the actual source of the problem. After using machine learning to analyse 13,433 nitrate measurements from 386 Canterbury wells (LAWA, 2004–2024), I found the problem has not improved in 20 years. From reviewing research literature, I found that dairy farms already fertilise their pasture with nitrogen fertiliser, and cow urine makes the problem even worse. Cows urinate in concentrated patches — up to 600 kg N/ha — far beyond what the soil can absorb. When winter comes, there is not enough cover for the ground; after rain, the nitrogen leaching happens. Canterbury's 20-year LAWA dataset confirms this: mean nitrate was 5.39 mg/L in 2004–2009 and still 5.38 mg/L in 2020–2024, peaking every August (6.86 mg/L) as winter rainfall flushes nitrogen through the soil. Existing farm interventions have made essentially no difference.

So my solution was: cover the high-risk areas and prevent urine from pooling in the same spot. Canterbury dairy farms typically operate on rotational grazing systems with 50–80 paddocks, rotating the herd every 2–3 days. Water troughs are fixed at paddock boundaries, making them a consistent congregation point across every rotation cycle — which means the nitrogen keeps accumulating in the same spot. The high-risk areas are where cows tend to gather — especially near water troughs and milking holding yards. A pad seemed like a realistic way to solve the problem.

CowPad is a modular pad system that uses satellite data and machine learning to identify high-risk nitrogen zones and alert farmers in advance — telling them how many pads are needed and where to place them. The pads capture urinary nitrogen in replaceable biochar cartridges, which can be returned to the field as slow-release fertiliser. The result is a system that turns a compliance problem into a nutrient recovery opportunity.

---

## 2. Design and Development Process

### 2.1 Version 1: Dispersal

My first idea was a fan-shaped pad with surface channels to distribute urine across a larger area, so the soil and pasture could absorb the nitrogen naturally. A 600 mm radius pad expands the urine contact patch from 0.37 m² to 2.0 m², reducing local nitrogen concentration by 82% — enough to fall below the 200 kg N/ha leaching threshold. No materials, no power, no moving parts.

The problem: total nitrogen entering the soil is unchanged. Dispersal solves the concentration problem but not the leaching problem.

### 2.2 Version 2: Monitoring Layer

Through this semester I learned more about precision agriculture — how many small factors can affect real production environments, like slope, soil moisture, and seasonal variation. Since I was already working with satellite data, I started thinking: what if I built an alert system that could identify where the risk is highest and tell farmers where to put the pads before the problem gets worse?

This became the NitroGuard GIS layer. It combines ECan groundwater well data, LCDB v6.0 land use polygons, and a KNN machine learning model (R²=0.750, trained on 13,433 measurements from 386 Canterbury wells) to map high-risk zones across Canterbury and recommend how many pads are needed per trough. Selwyn district came out as the highest-risk zone at 7.13 mg/L mean nitrate — nearly three times South Canterbury. The system is web-based so farmers can monitor risk across their whole farm network over time.

One thing I realised later: the current system identifies risk based on land use patterns — it cannot see where cows are actually gathering in real time. That led to a new idea: instead of detecting urine patches on the grass, what if you detected the cow herd itself? Satellite or drone imagery showing congregation density could make the recommendations much more precise. That is a direction I want to develop next.

### 2.3 Version 3: Capture

Thinking about sustainability, I realised that farmers already pay a lot for fertiliser, and urine could be collected as fertiliser rather than polluting groundwater. So I added biochar beneath the pad surface to absorb the urine for future use as fertiliser. Biochar adsorbs 6 mg/g of NO₃⁻-N and 4 mg/g of NH₄⁺-N from solution (Cayuela et al., 2013), and urine-enriched biochar returned to field delivers 40–50% nitrogen recovery as a slow-release fertiliser (Woldeyohannes et al., 2024). I also added a sensor to detect saturation, and designed the cartridge so farmers can easily remove and replace the biochar.

This concept is similar to Bounty Gel (Verdesian Life Sciences), a hydrogel that absorbs up to 150 times its weight in water and degrades in soil over approximately three years. CowPad substitutes biochar for hydrogel — unlike spent hydrogel, spent biochar cartridges contain recoverable nitrogen of agronomic value.

Load calculation for an 80-cow herd at a standard Hynds 1100L trough sets the cartridge replacement interval at 15–20 days — compatible with a monthly farm service schedule.

### 2.4 Version 4: Soil Ejection (Explored and Abandoned)

One idea I explored was using soil itself as the absorbent medium — dig a soil-filled cavity into the pad, let the soil absorb the urine, then eject the saturated soil into the surrounding paddock where it would release nitrogen as fertiliser. No cartridges, no maintenance, nothing for the farmer to purchase or replace.

The problem was soil compaction. Over time, the soil would consolidate under repeated hoof loading and wet-dry cycles, blocking drainage and preventing absorption. I still think the core idea has merit — a future version using a structured support or microbial assistance to prevent compaction could be worth developing. The ballistic ejection concept itself carried forward into the Version 2 cartridge design.

### 2.5 Version 5: Final Design

I returned to Version 1 and Version 3 and combined them. The final design has surface channels to distribute urine, a biochar storage cavity to capture and absorb it, and a rain self-cleaning profile so that rainfall flushes the surface without saturating the biochar layer.

### 2.6 Connector System

An early version used a single tile to surround the whole trough, but I realised a modular design would be easier to clean and service. The redesign uses one universal bayonet clip on every tile edge. Arc tiles, straight tiles, and corner tiles all interlock through the same male/female profile. Different shapes, one connector language — the same principle as LEGO. Any trough geometry can be assembled from three tile types and one clip SKU.

### 2.7 Structural Constraints

After researching what would pass over the pad — cows, tractors (Canterbury dairy tractors weigh 4,000–8,000 kg), irrigation equipment — I referenced the materials used in shade area mats and designed the rib structure with the channel profile aligned directly under cow hooves. The tile rib structure carries cow hoof loads with a factor of safety greater than 8×, based on a 600 kg animal distributed across a 0.07 m² contact area. It does not carry agricultural vehicle loads. Version 1 is scoped to boundary-fence troughs and service laneways that tractors do not routinely cross.

Nitrogen congregation analysis places trough areas fourth on a Canterbury dairy farm, after laneways (cows transit twice daily), holding yards (30–60 min wait before milking), and shade areas. The modular system extends to laneways (Version 2) and holding yards (Version 3) where nitrogen loading is higher.

### 2.8 EC Sensor and Rain Mitigation

Two stainless steel probes are embedded in the biochar fill layer. As the biochar adsorbs nitrogen ions, ionic concentration rises and electrical conductivity increases proportionally. An Arduino Nano reads probe resistance via a voltage divider and maps the result to a saturation percentage. A three-state LED indicates status: green (0–60%, actively absorbing), amber (60–85%, nearing capacity), red (>85%, replace now). Component cost is approximately NZD $45 from Jaycar Electronics.

Rain dilutes surface ionic concentration, producing false low-EC readings. Three mitigations work in combination: probes are positioned at the base of the biochar cavity, measuring deep ion concentration rather than surface moisture; a hardware raindrop sensor on pin D4 suspends EC updates during active rainfall; and a software derivative tracker freezes the saturation reading when EC is falling (rain event) and resumes when EC is rising (urine absorption). The saturation state is preserved across rain events.

---

## 3. Review of Similar Projects and Existing Products

### 3.1 Direct Competitors

**Āmua** (AgriZeroNZ, 2025) is a wearable device fitted to individual cows that distributes urine across a wider contact area before it reaches the soil. Developed by a Canterbury-based startup, Āmua received NZD $1.2 million from AgriZeroNZ — a joint initiative of Fonterra, Synlait, and ANZCO Foods — and is targeting minimum viable product trials in 2026 (AgriZeroNZ, 2025). Āmua prevents nitrogen from pooling; CowPad captures nitrogen that has already pooled. Āmua requires fitting and ongoing management of individual animals across the herd; CowPad requires no animal interaction.

**Halter** (virtual fencing) uses audio, vibration, and electrical cues via a neck collar to control cow movement and restrict paddock access (Halter, 2024). Behavioural restriction could reduce congregation time near troughs but does not reduce total nitrogen output — it redistributes it. Halter is primarily designed for grazing allocation and milking shed management, not nitrogen distribution.

**AgResearch PEETER V2.0** sensors are acoustic leg-mounted devices that detect and profile individual urination events per animal (AgResearch, 2024). The system is diagnostic — it identifies high-nitrogen-loss cows for selective management — not interventive. It does not reduce leaching directly.

### 3.2 Products CowPad Borrowed From

**Bounty Gel** (Verdesian Life Sciences) is a hydrogel that absorbs up to 150 times its weight in water and degrades in soil over approximately three years. CowPad's replaceable cartridge borrows the absorbent-material-in-replaceable-format concept, substituting biochar for hydrogel. Unlike spent hydrogel, spent biochar cartridges contain recoverable nitrogen of agronomic value.

**TrapView** (Pessl Instruments) is an IoT pest monitoring system that triggers service alerts when trap counts exceed a threshold. CowPad's EC sensor architecture uses the same model: a threshold reading triggers a cartridge replacement alert. NitroGuard's farm network dashboard follows TrapView's multi-site aggregation approach.

**FBN and Trace Genomics** combine satellite imagery and soil data to generate spatially resolved farm recommendations. NitroGuard's GIS risk mapping layer follows this model, overlaying ECan well data with farm boundary data to prioritise deployment zones across Canterbury.

### 3.3 Existing Approaches

Standard rubber trough mats protect hoof health but have no nitrogen function. DairyNZ's plantain programme reduces urinary nitrogen excretion by up to 60% but requires whole-paddock resowing and does not address trough zones specifically (DairyNZ, 2023). ECan's 300+ groundwater monitoring wells measure aquifer nitrogen outcomes reflecting farm practices from 20–30 years prior — they track the result, not the cause.

No existing product combines point-source nitrogen capture (hardware), saturation feedback (IoT), and deployment intelligence (GIS) in a single system.

### 3.4 NitroGuard GIS Model Performance

The NitroGuard risk mapping layer is built on a machine learning model trained on the full LAWA Canterbury groundwater dataset (386 wells, 13,433 nitrate measurements, 2004–2024). Four modelling approaches were tested:

| Model | R² | RMSE (mg/L) |
|---|---|---|
| Linear Regression | 0.297 | 3.612 |
| Decision Tree (depth=4) | 0.658 | 2.724 |
| Random Forest (200 trees) | 0.725 | 2.442 |
| **KNN (K=3)** | **0.750** | **2.327** |

KNN outperforms all other approaches, explaining 75% of nitrate variance across Canterbury wells. The strongest single predictor is farmland coverage within 1km of a well (r=0.360 with nitrate concentration), outperforming electrical conductivity (r=0.25) alone. This confirms the GIS layer's core logic: farmland density, not just water chemistry, is the deployable signal for identifying high-priority trough deployment zones.

Spatial analysis by zone confirms that Selwyn district carries the highest risk (mean 7.13 mg/L), nearly three times South Canterbury (2.77 mg/L) and 50% above the Canterbury-wide mean of 5.30 mg/L:

| Zone | Wells (n) | Mean Nitrate (mg/L) |
|---|---|---|
| Selwyn | 89 | 7.13 |
| Christchurch | 90 | 4.80 |
| North Canterbury | 116 | 2.94 |
| South Canterbury | 90 | 2.77 |

Selwyn's intensive irrigated dairy belt — the same area where ECan compliance pressure is highest — is the primary deployment target for Version 1 CowPad installations.

---

## 4. Business Model and Potential Market

### Customer Segments
**Primary:** Canterbury dairy farmers under ECan Freshwater Farm Plan obligations — especially irrigated operations with 300–1,500+ cows where nitrogen compliance risk is highest.

**Secondary:** Trough suppliers (e.g. Hynds) as bundle partners — farmers buying a new trough are the exact moment to sell CowPad as an add-on. This reduces customer acquisition cost and makes installation feel natural.

**Tertiary:** Environment Canterbury and DairyNZ — the NitroGuard data layer protects regional water quality and saves infrastructure cost compared to building new treatment systems.

### Value Propositions
For farmers: ECan compliance with zero operational friction — no power, no behaviour change, no changes to milking schedules.

For ECan and DairyNZ: farm-level nitrogen monitoring data at scale, something no current system provides.

For the supply chain: spent biochar cartridges re-enter as slow-release fertiliser. The nitrogen that was a liability becomes an asset.

### Channels
- Bundle sales through trough suppliers at point of purchase
- DairyNZ farm extension network
- Direct sales at National Fieldays and Canterbury A&P Show
- NitroGuard GIS platform as web dashboard and mobile app
- Compliance reports auto-generated from sensor data

### Customer Relationships
Cartridge exchange follows a swap model — the service company handles collection, reprocessing, and redelivery every 15–20 days. The farmer only swaps the cartridge. NitroGuard handles the rest: monitoring, scheduling, and compliance reporting across the whole farm network.

### Revenue Streams
- **Hardware (one-time):** NZD $180–250 per trough kit (8 tiles and clips). Tile shell rated 20–30 years in UV-stabilised HDPE.
- **Cartridge subscription (recurring):** NZD $15–25 per trough per month.
- **Nitrogen recovery:** ~NZD $2–4 per kg N recovered as slow-release fertiliser pellets, offsetting collection costs.
- **NitroGuard GIS (SaaS):** NZD $2,000–5,000 per farm per year; institutional licences to ECan and DairyNZ.

### Key Resources
Physical design IP (tile geometry, universal connector, cartridge format); EC sensor firmware with rain-mitigation algorithm; biochar supply and reprocessing infrastructure; NitroGuard ML model (KNN K=3, R²=0.750) trained on 13,433 measurements from 386 Canterbury wells; geospatial dataset combining LAWA well data, LCDB v6.0 land use polygons, and farm boundary mapping.

### Key Activities
Tile and cartridge manufacturing; cartridge collection and biochar reprocessing every 15–20 days; sensor calibration and firmware updates; GIS data integration and model updating; ECan compliance report generation.

### Key Partners
- Environment Canterbury (300+ well dataset)
- DairyNZ (agronomic research, farmer network)
- Trough suppliers — Hynds and others (bundle distribution)
- Halter NZ (livestock location data for GIS layer)
- NIWA (weather and rainfall API)
- Biochar processors and biopolymer suppliers

### Cost Structure
**Fixed:** tile tooling, firmware and GIS platform development, data partnership agreements.

**Variable:** cartridge manufacturing, collection logistics (largest ongoing cost at scale), biochar reprocessing, customer onboarding.

The Version 2 ballistic return model — cartridges degrade in-field after ejection — eliminates collection logistics entirely, which is the biggest cost reduction opportunity in the whole system.

---

## 5. Limitations and Future Work

Version 1 addresses trough areas, the fourth-worst nitrogen source on a Canterbury dairy farm. The structural specification supports cow hoof loads (FoS >8×) but not agricultural vehicle loads, limiting deployment to boundary troughs and vehicle-free laneways.

The current prototype uses PLA, which has a UV outdoor life of weeks to months at Canterbury's summer UV index of 11–12. The production version requires UV-stabilised HDPE for the tile shell and a PHA/PLA biopolymer blend for the cartridge body, which should degrade in soil without leaving microplastic residue.

The spring-ejection mechanism for automatic cartridge return has been validated as a prototype but requires field testing under farm conditions — temperature variation, mud and slurry ingress, and direct cow contact loads.

CowPad also does not address silage leachate — the liquid that drains from silage pits during fermentation. Silage leachate is highly concentrated in nitrogen and organic matter, and represents a separate point-source pollution risk on Canterbury dairy farms that requires a different intervention approach.

The Version 2 ballistic return model auto-ejects saturated cartridges toward the paddock interior at saturation detection. The biopolymer shell degrades in soil and the nitrogen releases to the pasture root zone with no collection, no processing, and no logistics. The GIS layer that maps where pads should be deployed also maps where spent cartridges can safely land — away from waterways and within productive pasture zones. The hardware and software layers are more directly connected than the original design intended.

---

## References

LAWA (Land, Air, Water Aotearoa). (2025). *Groundwater quality monitoring results 2004–2024*. Retrieved from https://www.lawa.org.nz/

AgriZeroNZ. (2025). *AgriZeroNZ backs farmer-led startup to tackle nitrate leaching and nitrous oxide emissions*. Retrieved from https://www.scoop.co.nz/stories/SC2511/S00004/

AgResearch. (2024). *Urine sensors for cattle to reduce nitrogen loss*. Retrieved from https://www.agresearch.co.nz/news/urine-sensors-for-cattle-to-reduce-nitrogen-loss/

Cayuela, M. L., Sánchez-Monedero, M. A., Roig, A., Hanley, K., Enders, A., & Lehmann, J. (2013). Biochar and denitrification in soils: When, how much and why does biochar reduce N₂O emissions? *Scientific Reports*, 3, 1732.

DairyNZ. (2023). *Plantain in dairy systems: reducing urinary nitrogen excretion*. Hamilton: DairyNZ Technical Series.

Environment Canterbury. (2024). *Canterbury groundwater quality monitoring report*. Christchurch: Environment Canterbury Regional Council.

Halter. (2024). *Virtual fencing and pasture management*. Retrieved from https://www.halterhq.com/

Taumata Arowai. (2022). *Addressing risks associated with nitrates in drinking water*. Retrieved from https://www.taumataarowai.govt.nz/home/articles/maximum-amount-of-nitrate-that-is-acceptable-in-drinking-water

Pessl Instruments. (2024). *TrapView automated pest monitoring system*. Retrieved from https://metos.at/trapview

Schullehner, J., Hansen, B., Thygesen, M., Pedersen, C. B., & Sigsgaard, T. (2018). Nitrate in drinking water and colorectal cancer risk: A nationwide population-based cohort study. *International Journal of Cancer*, 143(1), 73–79. https://doi.org/10.1002/ijc.31306

Safa, M., Samarasinghe, S., & Mohssen, M. (2018). Nitrogen leaching on Canterbury dairy farms: survey results and modelling. *New Zealand Journal of Agricultural Research*, 61(4), 412–428.

Woldeyohannes, A. B., Cotter, M., Kelm, M., & Wurbs, A. (2024). Urine-enriched biochar as a slow-release nitrogen fertiliser: recovery efficiency and agronomic performance. *Frontiers in Sustainable Food Systems*, 8, 1349021.
