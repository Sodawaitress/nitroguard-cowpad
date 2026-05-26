// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Ejector Platform  ·  V2 Print-in-Place Spring
//  ENGN676  ·  Lincoln University  ·  2026
//
//  PRINTS AS ONE PIECE — no separate spring needed.
//
//  HOW IT WORKS:
//    1. Two leaf spring arms grow from the top face near the inner edge.
//    2. Arms naturally rise 6mm above platform surface (printed at an angle).
//    3. Push platform flat into tile cavity → ceiling compresses arms 2mm
//       → spring loaded (~4 N total force).
//    4. Trigger releases latch → arms spring back → OR edge flips up
//       → cartridge launches toward paddock.
//    5. Next cartridge drops from magazine. Reset manually for demo.
//
//  HINGE: two U-channels hook over pins projecting from tile inner wall.
//  Assembly: angle platform → hook channels over pins → press flat.
//
//  ► PRINT 1 COPY
//  ► Orientation : FLAT FACE DOWN (arms print pointing upward — no supports)
//  ► Layer height : 0.2mm
//  ► Infill       : 25%
//  ► Supports     : NONE
//  ► Material     : PLA  (~15 reliable flex cycles for demo)
//                   PETG preferred if available (100+ cycles)
//  ► Est. time    : ~1 hr
// ═══════════════════════════════════════════════════════════════════════

$fn = 64;

// ── Tile cavity parameters (must match cowpad_tile_arc.scad) ─────────
IR = 75;   OR = 145;   ANG = 45;
BASE_H = 6;   FILL_H = 8;   LID_H = 1.5;
CAV_WALL = 5;   CAV_ANG = 3;
CAV_DEPTH = FILL_H - LID_H;   // 6.5mm usable cavity depth

// ── Platform footprint ───────────────────────────────────────────────
P_IR  = IR  + CAV_WALL + 0.6;   // 80.6
P_OR  = OR  - CAV_WALL - 0.6;   // 139.4
P_A1  = CAV_ANG + 0.5;          // 3.5°
P_A2  = ANG - CAV_ANG - 0.5;    // 41.5°
P_H   = 2.5;                     // base plate thickness

// ── Hinge U-channels ─────────────────────────────────────────────────
HG_D    = 6.4;   // pin Ø + 0.4mm clearance
HG_DEEP = 3.5;
HG_L    = 9;
HG_A    = [P_A1 + (P_A2-P_A1)*0.28, P_A1 + (P_A2-P_A1)*0.72];

// ── Print-in-Place Leaf Spring Arms ──────────────────────────────────
//
//  Arm geometry (side view, IR at left, OR at right):
//
//                                tip ___
//                               /      |  } LEAF_T = 1.2mm
//                         ____/________|
//    base ____           |  arm        |
//    _____|    |__________|_____________|
//    |  platform body P_H = 2.5mm      |
//    |__________________________________|
//    IR edge (hinge)             OR edge
//
//  Base (at P_IR+2) is bonded to platform.
//  Tip (at P_IR+2+LEAF_L) rises LEAF_RISE above platform top.
//  Cavity clearance above platform = CAV_DEPTH - P_H = 4.0mm.
//  LEAF_RISE = 6mm → tip 2mm above ceiling in free state
//  → arm compressed 2mm when installed → ~4 N spring force.
//
LEAF_T    = 1.2;   // arm thickness — printable with 0.4mm nozzle (3 perimeters)
LEAF_W    = 10;    // arm width (arc direction)
LEAF_L    = 25;    // arm radial length (cantilever span)
LEAF_BASE = 3;     // bonded base section length
LEAF_RISE = 6.0;   // tip height above platform top in free state (> 4mm clearance)

// Two arms at 35% and 65% of arc span
LEAF_A = [P_A1 + (P_A2-P_A1)*0.35, P_A1 + (P_A2-P_A1)*0.65];

// ── Latch notch ──────────────────────────────────────────────────────
LT_W   = 8;   LT_H = 4;   LT_D = 3.5;
LT_ANG = (P_A1 + P_A2) / 2;

// ── Launch ramp ───────────────────────────────────────────────────────
RAMP_ANG = 35;
RAMP_H   = 4;
RAMP_W   = P_OR - P_IR - 20;

// ═══════════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════════

module pie_2d(r, a1, a2) {
  steps = max(4, ceil(a2 - a1));
  pts = concat([[0,0]],
    [for(i=[0:steps])
      [r*cos(a1 + i*(a2-a1)/steps),
       r*sin(a1 + i*(a2-a1)/steps)]]);
  polygon(pts);
}

module ring_sector_2d(ri, ro, a1, a2) {
  intersection() {
    difference() { circle(ro); circle(ri); }
    pie_2d(ro+1, a1, a2);
  }
}

module ring_sector(ri, ro, a1, a2, h) {
  linear_extrude(h) ring_sector_2d(ri, ro, a1, a2);
}

// ═══════════════════════════════════════════════════════════════════════
// HINGE U-CHANNELS
// Cut into inner radius edge of platform — hook over tile hinge pins.
// ═══════════════════════════════════════════════════════════════════════

module hinge_channels() {
  for(a = HG_A) {
    rotate([0,0,a])
      translate([P_IR, -HG_L/2, P_H/2 - HG_D/2])
        rotate([0,90,0])
          cylinder(d=HG_D, h=HG_DEEP+0.1);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// PRINT-IN-PLACE LEAF SPRING ARMS
//
// hull() between two flat blocks creates a tapered angled beam:
//   block 1 (base): at platform top face, near P_IR — stays flat
//   block 2 (tip):  translated radially outward AND up by LEAF_RISE
// Result: arm rises from flat at IR end to LEAF_RISE at tip end.
//
// Orientation note: with flat-face-DOWN printing, the arms print
// pointing UP — no overhangs, no supports needed.
// ═══════════════════════════════════════════════════════════════════════

module leaf_spring_arms() {
  for(a = LEAF_A) {
    rotate([0, 0, a])
      translate([P_IR + 2, -LEAF_W/2, P_H - 0.1])
        hull() {
          cube([LEAF_BASE, LEAF_W, LEAF_T]);                 // base block (flat)
          translate([LEAF_L, 0, LEAF_RISE])                  // tip block (raised)
            cube([LEAF_BASE, LEAF_W, LEAF_T]);
        }
  }
}

// ═══════════════════════════════════════════════════════════════════════
// LATCH NOTCH
// Rectangular pocket on underside near OR edge — trigger hook catches here.
// ═══════════════════════════════════════════════════════════════════════

module latch_notch_cut() {
  rotate([0,0,LT_ANG])
    translate([P_OR - LT_D - 1, -LT_W/2, -0.1])
      cube([LT_D + 1.1, LT_W, LT_H + 0.1]);
}

// ═══════════════════════════════════════════════════════════════════════
// LAUNCH RAMP
// Wedge on top face guides cartridge at 35° elevation on ejection.
// ═══════════════════════════════════════════════════════════════════════

module launch_ramp() {
  a_mid = (P_A1 + P_A2) / 2;
  rotate([0,0,a_mid])
    translate([P_IR + 10, RAMP_W/2, P_H])
      rotate([90,0,0])
        linear_extrude(RAMP_W)
          polygon([
            [0, 0],
            [RAMP_H / tan(RAMP_ANG), 0],
            [0, RAMP_H]
          ]);
}

// ═══════════════════════════════════════════════════════════════════════
// ASSEMBLE
// ═══════════════════════════════════════════════════════════════════════

difference() {
  union() {
    ring_sector(P_IR, P_OR, P_A1, P_A2, P_H);   // base plate
    leaf_spring_arms();                            // integrated PIP spring
    launch_ramp();
  }
  hinge_channels();
  latch_notch_cut();
}
