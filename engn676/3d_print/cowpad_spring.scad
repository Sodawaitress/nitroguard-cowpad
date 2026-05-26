// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Printable Coil Spring  ·  V2 Ejector Component
//  ENGN676  ·  Lincoln University  ·  2026
//
//  Sits on tile cavity FLOOR, passes through hole in ejector platform,
//  and presses against tile cavity CEILING when compressed.
//
//  Space available:  FILL_H = 8mm  →  usable cavity = FILL_H - LID_H = 6.5mm
//  Compressed height: 6.5mm  (platform flat, latch engaged — must NOT exceed 6.5mm)
//  Free height:      15mm  (after trigger releases, spring extends)
//
//  ► PRINT 2 COPIES  (one installed, one spare)
//  ► Orientation : VERTICAL — spring axis along Z = print direction
//     This is CRITICAL: inter-layer adhesion is along the wire axis
//  ► Layer height : 0.15mm  (finer layers = stronger spring)
//  ► Infill       : 100%  (solid — the wire IS the spring)
//  ► Speed        : 20 mm/s  (slow print = better layer bonding)
//  ► Material     : PLA  (~10–20 reliable activations for demo)
//                   PETG preferred if library has it
//  ► Est. time    : ~15 min each
//
//  BACKUP: rubber band looped around anchor pegs on platform + tile floor
// ═══════════════════════════════════════════════════════════════════════

$fn = 20;

// ── Spring parameters ────────────────────────────────────────────────
OD      = 8.0;   // outer coil diameter — fits in 10mm seat (1mm clearance/side)
WIRE_D  = 1.0;   // wire cross-section diameter
N_ACT   = 6;     // active coils
FREE_H  = 15.0;  // free (unloaded) height
N_DEAD  = 0.75;  // dead (flat) coils at each end — improves seating

// ── Derived ──────────────────────────────────────────────────────────
R           = (OD - WIRE_D) / 2;   // radius to wire centre
TOTAL_COILS = N_ACT + 2 * N_DEAD;
SEG         = 20;                   // segments per coil
TOTAL_SEGS  = round(TOTAL_COILS * SEG);

// ═══════════════════════════════════════════════════════════════════════
// COIL SPRING
// Helix built from hull() between adjacent sphere pairs.
// Dead coils at each end sit flat to seat flush on cavity floor / ceiling.
// ═══════════════════════════════════════════════════════════════════════

module coil_spring() {
  for (i = [0 : TOTAL_SEGS - 2]) {
    f1 = i       / TOTAL_SEGS;
    f2 = (i + 1) / TOTAL_SEGS;

    c1 = f1 * TOTAL_COILS;
    c2 = f2 * TOTAL_COILS;

    // Z only rises in the ACTIVE zone (between the two dead-coil zones)
    z1 = FREE_H * max(0, min(c1 - N_DEAD, N_ACT)) / N_ACT;
    z2 = FREE_H * max(0, min(c2 - N_DEAD, N_ACT)) / N_ACT;

    a1 = c1 * 360;
    a2 = c2 * 360;

    hull() {
      translate([R * cos(a1), R * sin(a1), z1]) sphere(d = WIRE_D);
      translate([R * cos(a2), R * sin(a2), z2]) sphere(d = WIRE_D);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════
// RENDER
// ═══════════════════════════════════════════════════════════════════════

coil_spring();
