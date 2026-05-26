// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Sensor Tile  ·  Demo Model
//  Arc Tile with EC probe holes + wire channel for Arduino demo
//
//  ► PRINT 1 COPY
//  ► Orientation : flat face DOWN (ribs on build plate)
//  ► Layer height : 0.2mm
//  ► Infill       : 20% gyroid
//  ► Supports     : NONE
//  ► Material     : PLA
//  ► Est. time    : ~2 hr
//
//  EC SENSOR ASSEMBLY:
//    1. Insert steel nail probes through holes (push from above)
//    2. Thread wires through bottom channel out to tile edge
//    3. Connect to Arduino Nano (see PRODUCT.md circuit diagram)
//    4. Insert biochar cartridge (with real biochar)
//    5. Pour water/salt solution → LED turns green → yellow → red
//
//  Probe spacing: ~20mm (circumferential)
//  Probe diameter: 4.5mm hole (fits 3–4mm nail)
// ═══════════════════════════════════════════════════════════════════════

$fn = 64;

// ── Parameters (must match cowpad_tile_arc.scad) ──────────────────────
IR = 75;
OR = 145;
ANG = 45;
FILL_H = 8;
BASE_H = 6;
H      = BASE_H + FILL_H;
RIB_H  = 4;
N_CH   = 5;
CH_W   = 3.5;
CH_D   = 3.0;   // V-groove depth (was 2.2)
LID_H  = 1.5;
LID_D  = 4.0;
CHAM   = 1.0;
N_RIB  = 5;
RIB_W  = 2.5;
CAV_WALL = 5;
CAV_ANG  = 3;
SN_W    = 10;
SN_H    = 4;
SN_L    = 2.5;
SN_CHAM = 0.8;
SN_POS  = (IR + OR) / 2;

// ── Sensor-specific ───────────────────────────────────────────────────
PROBE_D    = 4.5;   // probe hole diameter (mm)
PROBE_R    = (IR + OR) / 2 - 10;  // radial position (slightly inward)
PROBE_SEP  = 10;    // half-separation angle (degrees) → ~20mm arc apart
WIRE_W     = 4;     // wire channel width
WIRE_H     = 3;     // wire channel height
WIRE_ANG   = ANG / 2;  // wire channel runs along mid-arc

// ═══════════════════════════════════════════════════════════════════════
// HELPERS (identical to arc tile)
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

module snap_tab() {
  rotate([0, 0, ANG]) {
    translate([SN_POS - SN_W/2, 0, BASE_H/2 - SN_H/2])
      hull() {
        cube([SN_W, 0.01, SN_H]);
        translate([SN_CHAM, SN_L, SN_CHAM])
          cube([SN_W - 2*SN_CHAM, 0.01, SN_H - 2*SN_CHAM]);
      }
  }
}

module snap_slot_cut() {
  translate([SN_POS - SN_W/2 - 0.2, 0, BASE_H/2 - SN_H/2 - 0.2])
    cube([SN_W + 0.4, SN_L + 0.5, SN_H + 0.4]);
}

module cavity_cut() {
  translate([0, 0, BASE_H])
    ring_sector(IR + CAV_WALL, OR - CAV_WALL,
                CAV_ANG, ANG - CAV_ANG,
                FILL_H + 0.1);
}

module channel_cuts() {
  for (i = [0:N_CH-1]) {
    a = (i + 0.5) * ANG / N_CH;
    rotate([0, 0, a])
      translate([IR - 1, 0, H - CH_D - 0.01])
        hull() {
          cube([OR - IR + 2, 0.01, 0.01]);
          translate([0, -CH_W/2, CH_D]) cube([OR - IR + 2, 0.01, 0.01]);
          translate([0,  CH_W/2, CH_D]) cube([OR - IR + 2, 0.01, 0.01]);
        }
  }
}

module edge_chamfers() {
  for (a = [0, ANG]) {
    rotate([0, 0, a])
      translate([IR, 0, H - CHAM])
        rotate([45, 0, 0])
          cube([OR - IR, CHAM * 1.5, CHAM * 1.5]);
  }
}

module ribs() {
  for (i = [0:N_RIB-1]) {
    a = (i + 0.5) * ANG / N_RIB;
    rotate([0, 0, a])
      translate([IR, -RIB_W/2, -RIB_H])
        cube([OR - IR, RIB_W, RIB_H]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// SENSOR FEATURES
// ═══════════════════════════════════════════════════════════════════════

// Two probe holes through fill + lid only — stops at structural base (does NOT
// punch through tile bottom).  Nail tips sit at base level, deep in biochar.
// Rain wets top of biochar; probes measure from the bottom → rain-stable signal.
module probe_holes() {
  for (a = [WIRE_ANG - PROBE_SEP, WIRE_ANG + PROBE_SEP]) {
    rotate([0, 0, a])
      translate([PROBE_R, 0, BASE_H - 0.1])
        cylinder(d = PROBE_D, h = FILL_H + 0.2);
  }
}

// Pull-tab slot through lid (matches arc tile — same cavity, same cartridge)
module pull_tab_slot() {
  rotate([0, 0, ANG / 2])
    translate([(IR + OR) / 2 - 8, -2.5, H - LID_H - 0.1])
      cube([16, 5, LID_H + 0.2]);
}

// Wire channel on bottom face — runs radially from probe zone to outer edge
// Wires exit through the outer curved wall and connect to Arduino
module wire_channel_cut() {
  rotate([0, 0, WIRE_ANG])
    translate([PROBE_R - 2, -WIRE_W/2, -0.1])
      cube([OR - PROBE_R + 4, WIRE_W, WIRE_H + 0.1]);
  // Exit hole through outer wall
  rotate([0, 0, WIRE_ANG])
    translate([OR - 2, -WIRE_W/2, 0])
      cube([10, WIRE_W, WIRE_H]);
}

// ═══════════════════════════════════════════════════════════════════════
// ASSEMBLE
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
    pull_tab_slot();
    snap_slot_cut();
    probe_holes();
    wire_channel_cut();
    edge_chamfers();
  }
}
