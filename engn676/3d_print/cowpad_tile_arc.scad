// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Arc Tile  ·  Demo Model  ·  1:8 Scale
//  ENGN676 Agricultural Engineering  ·  Lincoln University  ·  2026
//  Designer: Yu Zhou  ·  Supervisor: Majeed Safa
//
//  Real: 600mm pad width · 45° sector · 50mm thick (Hynds 1100L trough)
//  This: 70mm pad width  · 45° sector · 13mm thick + 4mm ribs = 17mm total
//
//  ► PRINT 2 COPIES of this file
//  ► Orientation : flat face DOWN (ribs stand on build plate)
//  ► Layer height : 0.2mm
//  ► Infill       : 20% gyroid
//  ► Supports     : NONE
//  ► Material     : PLA
//  ► Est. time    : ~2 hr per tile
//
//  SNAP CONNECTORS:
//    Each tile has a MALE TAB on its +45° radial edge
//    and a FEMALE SLOT on its 0° radial edge.
//    Press tiles together edge-to-edge → tab clicks into slot.
//    Pull apart to separate.
// ═══════════════════════════════════════════════════════════════════════

$fn = 64;

// ── Radii ────────────────────────────────────────────────────────────────
IR = 75;   // inner radius (trough side)
OR = 145;  // outer radius (field side)
ANG = 45;  // arc degrees per tile (8 tiles = full ring)

// ── Heights ──────────────────────────────────────────────────────────────
BASE_H = 6;   // solid structural base
FILL_H = 8;   // biochar fill cavity depth (increased to fit cartridge + spring)
H      = BASE_H + FILL_H;  // = 13mm above rib plane
RIB_H  = 4;   // ribs project down from base bottom

// ── Drainage channels (top surface, radial) ──────────────────────────────
// V-groove channels — 60° included angle, self-cleaning at low flow
// Research: V-profile maintains velocity as flow drops → flushes biochar fines
N_CH  = 5;    // number of radial V-grooves
CH_W  = 3.5;  // top opening width (mm) — 60° V: width = 2 × depth × tan(30°) ≈ 3.5mm
CH_D  = 3.0;  // groove depth (increased from 2.2 → better self-cleaning hydraulics)

// ── Top lid ──────────────────────────────────────────────────────────────
// Solid cover over cavity — cow hoof load bears on this (4–6mm for production)
// Drain holes pierced at channel centrelines
LID_H   = 1.5;  // demo: 1.5mm PLA | production: 4mm UV-HDPE
LID_D   = 4.0;  // drain hole diameter

// ── Edge chamfer (prevents hoof-catching at tile joints) ─────────────────
// Research: joint gap >3mm catches hooves; chamfer all top edges
CHAM  = 1.0;  // 1mm at 1:8 scale = 8mm real — standard for agricultural flooring

// ── Structural ribs (bottom) ─────────────────────────────────────────────
// Research: rib height 2.5–3× wall thickness reduces deflection ~90%
N_RIB = 7;    // was 5 — hoof point load distribution across 7 ribs
RIB_H = 6;    // was 4mm — taller ribs, better stiffness-to-weight
RIB_W = 3.0;  // was 2.5mm

// ── Biochar cavity ───────────────────────────────────────────────────────
CAV_WALL = 5;  // wall thickness around cavity
CAV_ANG  = 3;  // clearance from radial edges (degrees)

// ── Snap connector ───────────────────────────────────────────────────────
SN_W    = 10;  // tab width
SN_H    = 4;   // tab height in Z
SN_L    = 2.5; // protrusion length
SN_CHAM = 0.8; // chamfer on tab tip (guides engagement)
SN_POS  = (IR + OR) / 2;  // radial center of snap = 110mm

// ═══════════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════════

module pie_2d(r, a1, a2) {
  steps = max(4, ceil(a2 - a1));
  pts = concat([[0, 0]],
    [for (i = [0:steps])
      [r * cos(a1 + i*(a2-a1)/steps),
       r * sin(a1 + i*(a2-a1)/steps)]]);
  polygon(pts);
}

module ring_sector_2d(ri, ro, a1, a2) {
  intersection() {
    difference() { circle(ro); circle(ri); }
    pie_2d(ro + 1, a1, a2);
  }
}

module ring_sector(ri, ro, a1, a2, h) {
  linear_extrude(h) ring_sector_2d(ri, ro, a1, a2);
}

// ═══════════════════════════════════════════════════════════════════════
// CONNECTORS
// ═══════════════════════════════════════════════════════════════════════

// Male tab — on +ANG edge, protrudes outward from tile
module snap_tab() {
  rotate([0, 0, ANG]) {
    // In this frame: ANG edge is along +X, tile interior is in -Y half.
    // Outward (+Y) = toward adjacent tile.
    translate([SN_POS - SN_W/2, 0, BASE_H/2 - SN_H/2])
      hull() {
        cube([SN_W, 0.01, SN_H]);
        translate([SN_CHAM, SN_L, SN_CHAM])
          cube([SN_W - 2*SN_CHAM, 0.01, SN_H - 2*SN_CHAM]);
      }
  }
}

// Female slot — cut into 0° edge, receives tab from adjacent tile
module snap_slot_cut() {
  // At 0° edge (along +X), tile interior is +Y. Slot opens at Y=0.
  translate([SN_POS - SN_W/2 - 0.2, 0, BASE_H/2 - SN_H/2 - 0.2])
    cube([SN_W + 0.4, SN_L + 0.5, SN_H + 0.4]);
}

// ═══════════════════════════════════════════════════════════════════════
// FEATURES
// ═══════════════════════════════════════════════════════════════════════

// V-groove radial channels — self-cleaning triangular cross-section
// hull() of 3 parallel lines creates a triangular prism (V-shape)
// Tip at depth CH_D below surface, opening CH_W wide at surface
module channel_cuts() {
  for (i = [0:N_CH-1]) {
    a = (i + 0.5) * ANG / N_CH;
    rotate([0, 0, a])
      translate([IR - 1, 0, H - CH_D - 0.01])
        hull() {
          cube([OR - IR + 2, 0.01, 0.01]);                         // V tip
          translate([0, -CH_W/2, CH_D]) cube([OR - IR + 2, 0.01, 0.01]); // left top
          translate([0,  CH_W/2, CH_D]) cube([OR - IR + 2, 0.01, 0.01]); // right top
        }
  }
}

// Edge chamfers — top corners of both radial faces
// Prevents hoof-catching at tile joints (research: >3mm gap = lameness risk)
module edge_chamfers() {
  for (a = [0, ANG]) {
    rotate([0, 0, a])
      translate([IR, 0, H - CHAM])
        rotate([45, 0, 0])
          cube([OR - IR, CHAM * 1.5, CHAM * 1.5]);
  }
}

// drain_slots() removed — replaced by lid_drain_holes() (circular, through lid only)

// Fill cavity — stops LID_H below top face (lid covers it)
module cavity_cut() {
  translate([0, 0, BASE_H])
    ring_sector(IR + CAV_WALL, OR - CAV_WALL,
                CAV_ANG, ANG - CAV_ANG,
                FILL_H - LID_H + 0.1);
}

// Pull-tab slot through lid — rectangular opening for cartridge pull tab (14×4mm)
// Without this the 14mm-wide tab would be blocked by the solid lid.
module pull_tab_slot() {
  rotate([0, 0, ANG / 2])
    translate([(IR + OR) / 2 - 8, -2.5, H - LID_H - 0.1])
      cube([16, 5, LID_H + 0.2]);   // 16mm radial × 5mm arc × through lid
}

// Drain holes through lid — one per channel, at mid-radius
// Urine sits in surface channel → flows into hole → drops to biochar
module lid_drain_holes() {
  R_MID = (IR + OR) / 2;
  for (i = [0:N_CH-1]) {
    a = (i + 0.5) * ANG / N_CH;
    rotate([0, 0, a])
      translate([R_MID, 0, H - LID_H - 0.1])
        cylinder(d = LID_D, h = LID_H + 0.2);
  }
}

// Structural ribs — project below base, stand on build plate when printing
module ribs() {
  for (i = [0:N_RIB-1]) {
    a = (i + 0.5) * ANG / N_RIB;
    rotate([0, 0, a])
      translate([IR, -RIB_W/2, -RIB_H])
        cube([OR - IR, RIB_W, RIB_H]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// ASSEMBLE
// Translate up by RIB_H so rib tips sit at Z=0 (on build plate)
// ═══════════════════════════════════════════════════════════════════════

translate([0, 0, RIB_H]) {
  difference() {
    union() {
      ring_sector(IR, OR, 0, ANG, H);
      ribs();
      snap_tab();
    }
    cavity_cut();
    channel_cuts();
    lid_drain_holes();
    pull_tab_slot();
    snap_slot_cut();
    edge_chamfers();
  }
}
