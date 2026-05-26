// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Biochar Cartridge  ·  Demo Model
//  Replaceable insert for Arc Tile and Sensor Tile
//
//  ► PRINT 1 COPY
//  ► Orientation : PULL TAB UP (cartridge body on build plate)
//  ► Layer height : 0.2mm
//  ► Infill       : 15% (lighter is fine — it's a container)
//  ► Supports     : NONE
//  ► Material     : PLA
//  ► Est. time    : ~45 min
//
//  HOW IT WORKS:
//    Fits into the fill cavity of the Arc Tile (0.5mm clearance all round).
//    Fill with real biochar granules before demo.
//    Pull tab grips above tile surface — one-finger pull to replace.
//    Mesh slots on top let urine in; biochar stays inside.
// ═══════════════════════════════════════════════════════════════════════

$fn = 64;

// ── Must match tile parameters ────────────────────────────────────────
IR = 75;
OR = 145;
ANG = 45;
BASE_H = 6;
FILL_H = 8;
CAV_WALL = 5;
CAV_ANG  = 3;

// ── Cartridge dimensions (cavity minus clearance) ─────────────────────
CART_IR   = IR + CAV_WALL + 0.5;    // = 80.5
CART_OR   = OR - CAV_WALL - 0.5;    // = 139.5
CART_A1   = CAV_ANG + 0.5;          // = 3.5°
CART_A2   = ANG - CAV_ANG - 0.5;    // = 41.5°
LID_H     = 1.5;                     // must match cowpad_tile_arc.scad LID_H
CART_H    = FILL_H - LID_H - 0.5;  // = 6.0mm (0.5mm clearance below lid)
CART_WALL = 1.5;                     // cartridge shell wall thickness

// ── Pull tab ──────────────────────────────────────────────────────────
TAB_W = 14;   // width
TAB_T = 4;    // thickness
TAB_H = 14;   // total height (protrudes above tile surface when seated)
              // 14 - 0.5 = 13.5mm above tile top — easy to grip

// ── Mesh slots (top surface) ─────────────────────────────────────────
N_SLOTS  = 4;
SLOT_W   = 2.8;
SLOT_D   = 1.5;  // depth into cartridge wall

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
// MESH SLOTS — radial slots on top face, let urine in, keep biochar in
// ═══════════════════════════════════════════════════════════════════════

module mesh_slots() {
  for (i = [0:N_SLOTS-1]) {
    a = CART_A1 + (i + 0.5) * (CART_A2 - CART_A1) / N_SLOTS;
    rotate([0, 0, a])
      translate([CART_IR, -SLOT_W/2, CART_H - SLOT_D])
        cube([CART_OR - CART_IR, SLOT_W, SLOT_D + 0.1]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// HOLLOW SHELL — thin walls to hold biochar, open top
// Build as solid sector then hollow the inside
// ═══════════════════════════════════════════════════════════════════════

module cartridge_shell() {
  difference() {
    // Outer shell
    ring_sector(CART_IR, CART_OR, CART_A1, CART_A2, CART_H);
    // Hollow interior (open top)
    translate([0, 0, CART_WALL])
      ring_sector(CART_IR + CART_WALL, CART_OR - CART_WALL,
                  CART_A1 + 0.5, CART_A2 - 0.5,
                  CART_H);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// PULL TAB — centred on the midpoint of the cartridge arc
// ═══════════════════════════════════════════════════════════════════════

module pull_tab() {
  // Position at arc midpoint, outer edge, projecting upward
  a_mid = (CART_A1 + CART_A2) / 2;
  r_tab = (CART_IR + CART_OR) / 2;
  rotate([0, 0, a_mid]) {
    translate([r_tab - TAB_W/2, -TAB_T/2, CART_H - 0.1])
      hull() {
        cube([TAB_W, TAB_T, 1]);
        translate([1, 0.5, TAB_H - 1])
          cube([TAB_W - 2, TAB_T - 1, 0.01]);
      }
  }
}

// ═══════════════════════════════════════════════════════════════════════
// ASSEMBLE
// ═══════════════════════════════════════════════════════════════════════

difference() {
  union() {
    cartridge_shell();
    pull_tab();
  }
  mesh_slots();
}
