// ═══════════════════════════════════════════════════════════════════════
//  PRINT PLATE — 2 tiles in one job
//  tile_arc × 1  +  tile_sensor × 1
//  (1× tile_arc already printed)
//
//  Layout (top view):
//    Left  (x=0–92mm):   tile_arc   (y=0–103)
//    Right (x=98–190mm): tile_sensor (y=0–103)
//
//  Total footprint: 190mm × 103mm  → fits 220×220mm bed ✓
//  Settings: 0.2mm / 20% gyroid / PLA / no supports
//  Orientation: ribs on build plate — already correct
// ═══════════════════════════════════════════════════════════════════════

// tile_arc (1 copy — second already printed)
translate([-53, 0, 0])
  import("tile_arc__x2__0.2mm_20pct_PLA__ribs-on-plate.stl");

// tile_sensor (right of arc tile)
translate([45, 0, 0])
  import("tile_sensor__x1__0.2mm_20pct_PLA__ribs-on-plate.stl");
