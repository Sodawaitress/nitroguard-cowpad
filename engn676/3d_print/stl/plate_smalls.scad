// ═══════════════════════════════════════════════════════════════════════
//  PRINT PLATE — small parts in one job
//  cartridge × 2  +  eject_platform × 1  +  trigger set × 1
//
//  Layout (top view):
//    [x=0–79,  y=0–94]:   cartridge 1  (tab pointing up in Z)
//    [x=84–163, y=0–94]:  cartridge 2
//    [x=0–79,  y=99–187]: eject platform (leaf springs pointing up in Z)
//    [x=84–158, y=99–154]: trigger lever + bracket + pin
//
//  Total footprint: ~163mm × 187mm  → fits 220×220mm bed ✓
//
//  Settings per part:
//    cartridge:  0.2mm / 15% / PLA / tab-up (already oriented)
//    platform:   0.2mm / 25% / PLA / flat-down
//    trigger:    0.2mm / 30% / PLA / flat-down
//  → Use 0.2mm / 20% as a compromise for the whole plate, or
//    set per-object infill in Cura (right-click part → "Per Model Settings")
// ═══════════════════════════════════════════════════════════════════════

// Sector parts: natural x_min ≈ 60, y_min ≈ 5 → shift to 0,0

// cartridge 1
translate([-60, -5, 0])
  import("cartridge__x2__0.2mm_15pct_PLA__tab-up.stl");

// cartridge 2  (84mm to the right)
translate([-60 + 84, -5, 0])
  import("cartridge__x2__0.2mm_15pct_PLA__tab-up.stl");

// eject platform  (99mm below carts)
translate([-60, -5 + 99, 0])
  import("eject_platform__x1__0.2mm_25pct_PLA__flat-down.stl");

// trigger lever + bracket + pin
// (natural bounds: x≈-12 to 62, y≈-8 to 47 → shift to x=84, y=99)
translate([96, 107, 0])
  import("trigger__x1__0.2mm_30pct_PLA__flat-down.stl");
