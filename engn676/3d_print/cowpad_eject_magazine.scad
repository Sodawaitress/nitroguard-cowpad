// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Ejector Magazine  ·  V2 Ballistic Return System
//  ENGN676  ·  Lincoln University  ·  2026
//
//  Gravity-fed cartridge stack. Holds 3 replacement cartridges.
//  Sector-shaped cross-section — cartridges self-orient, cannot jam by rotation.
//  Mounts on the OUTER TROUGH WALL beside the tile (NOT on top of tile).
//  Magazine tube hangs DOWNWARD alongside the OR face — flush with tile top.
//  Cow hooves never contact the magazine.
//  In trough installation: magazine recessed into outer wall pocket.
//
//  HOW IT WORKS:
//    Load cartridges from top (open end up).
//    Bottom cartridge rests on platform in tile cavity.
//    When platform ejects it, next cartridge drops under gravity.
//    Service interval: 3 replacements × 15 days = ~45 days between refills.
//    (5-slot version = ~75 days: extend STACK_COUNT to 5)
//
//  ► PRINT 1 COPY
//  ► Orientation : UPRIGHT (tube axis vertical, open ends up and down)
//  ► Layer height : 0.2mm  ·  Infill 15%  ·  No supports
//  ► Material     : PLA
//  ► Est. time    : ~1.5 hr
// ═══════════════════════════════════════════════════════════════════════

$fn = 64;

// ── Match tile/cavity parameters ─────────────────────────────────────
IR = 75;   OR = 145;   ANG = 45;
CAV_WALL = 5;   CAV_ANG = 3;
FILL_H = 8;   BASE_H = 6;
H = BASE_H + FILL_H;

// ── Magazine tube inner dimensions (match cartridge + clearance) ──────
MAG_IR  = IR  + CAV_WALL + 0.3;   // 80.3  (0.3mm clearance each side)
MAG_OR  = OR  - CAV_WALL - 0.3;   // 139.7
MAG_A1  = CAV_ANG + 0.3;          // 3.3°
MAG_A2  = ANG - CAV_ANG - 0.3;    // 41.7°
MAG_WALL = 2;                       // tube wall thickness

// ── Stack capacity ────────────────────────────────────────────────────
CART_H      = 6.0;    // single cartridge height (must match cowpad_cartridge.scad: FILL_H-LID_H-0.5)
STACK_COUNT = 3;      // number of cartridges in magazine
STACK_H     = STACK_COUNT * (CART_H + 0.5);  // total stack height with gaps

// ── Mounting clip (attaches to tile outer rim) ────────────────────────
CLIP_H    = 8;    // clip engagement height
CLIP_WALL = 3;    // clip extra thickness (wraps outside tile OR wall)
CLIP_A1   = MAG_A1 + 3;   // clip spans middle portion of arc (not full arc)
CLIP_A2   = MAG_A2 - 3;

// ── Cartridge guide rails (inside tube, keep cartridges centred) ──────
RAIL_W  = 1.5;
RAIL_H  = STACK_H;
N_RAILS = 3;  // at arc positions: 15°, 22.5°, 30° (avoid radial edges)

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

module ring_sector(ri, ro, a1, a2, ht) {
  linear_extrude(ht) ring_sector_2d(ri, ro, a1, a2);
}

// ═══════════════════════════════════════════════════════════════════════
// TUBE WALLS
// Hollow sector tube: outer shell minus inner clearance
// ═══════════════════════════════════════════════════════════════════════

module tube_walls() {
  difference() {
    ring_sector(MAG_IR - MAG_WALL,
                MAG_OR + MAG_WALL,
                MAG_A1 - 1,
                MAG_A2 + 1,
                STACK_H);
    // Hollow interior — cartridges pass through here
    ring_sector(MAG_IR, MAG_OR, MAG_A1, MAG_A2, STACK_H + 0.1);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// GUIDE RAILS
// Thin radial fins inside the tube to keep cartridges vertically aligned
// ═══════════════════════════════════════════════════════════════════════

module guide_rails() {
  for(i = [0:N_RAILS-1]) {
    a = MAG_A1 + (i+0.5) * (MAG_A2 - MAG_A1) / N_RAILS;
    rotate([0,0,a])
      translate([MAG_IR, -RAIL_W/2, 0])
        cube([MAG_OR - MAG_IR, RAIL_W, RAIL_H]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// MOUNTING CLIP
// A C-channel that wraps over the top of the tile's outer rim.
// Friction-fit: press down to attach, lift to remove.
// ═══════════════════════════════════════════════════════════════════════

module mount_clip() {
  // Clip body: sits at bottom of magazine, wraps outside tile OR wall
  difference() {
    // Outer clip shell
    ring_sector(MAG_OR + MAG_WALL,
                MAG_OR + MAG_WALL + CLIP_WALL,
                CLIP_A1, CLIP_A2,
                CLIP_H + FILL_H);

    // Inner relief: clip slides over tile outer wall (5mm thick)
    // Tile outer wall is at OR to OR+5mm (CAV_WALL)
    // Clip wraps from OR+CAV_WALL outward
    // Leave 0.3mm clearance on inside face (handled by MAG_OR offset)
  }

  // Inward lip at bottom to catch under tile top surface
  ring_sector(MAG_OR,
              MAG_OR + MAG_WALL + CLIP_WALL,
              CLIP_A1, CLIP_A2,
              1.5);
}

// ═══════════════════════════════════════════════════════════════════════
// ASSEMBLE
// Magazine tube sits on top of tile cavity opening.
// Bottom of tube aligns with top of tile (Z=0 in this model = tile top).
// ═══════════════════════════════════════════════════════════════════════

union() {
  tube_walls();
  // Guide rails (subtract from hollow interior — already done since rails
  // are placed inside; difference with hollow already excludes rail volume)
  // Actually rails are added separately within the open space:
  intersection() {
    // Clip rails to tube interior volume
    ring_sector(MAG_IR, MAG_OR, MAG_A1, MAG_A2, STACK_H);
    guide_rails();
  }
  mount_clip();
}
