// ═══════════════════════════════════════════════════════════════════════
//  CowPad — Full Assembly  ·  V2 Ballistic Return System
//  ENGN676  ·  Lincoln University  ·  2026
//
//  This file renders ALL components in correct assembled positions.
//  Use it to:
//    • Verify fit between components
//    • Generate presentation screenshot (F5 preview)
//    • Export full assembly STL if needed
//
//  COORDINATE SYSTEM (Z axis):
//    Z = 0           rib tips (contact ground)
//    Z = RIB_H       tile base bottom face
//    Z = RIB_H+BASE_H  fill cavity floor = platform resting position
//    Z = RIB_H+H     tile top face = magazine base
//
//  TOGGLE VISIBILITY: set 1=show, 0=hide
SHOW_TILE      = 1;
SHOW_HINGE_PINS= 1;
SHOW_PLATFORM  = 1;
SHOW_CARTRIDGE = 0;   // V2 auto: ejector handles cartridge, no pull tab
SHOW_SPRING    = 0;   // spring now integrated in platform (PIP leaf arms)
SHOW_MAGAZINE  = 1;
SHOW_MAG_CARTS = 1;   // cartridges inside magazine (2 stacked)
SHOW_TRIGGER   = 1;
//
//  EXPLODE: set > 0 to separate components vertically for clarity
EXPLODE = 0;   // mm extra Z spacing between layers (try 15 for exploded view)
// ═══════════════════════════════════════════════════════════════════════

$fn = 64;

// ═══════════════════════════════════════════════════════════════════════
// SHARED PARAMETERS
// ═══════════════════════════════════════════════════════════════════════

IR = 75;   OR = 145;   ANG = 45;
FILL_H  = 8;    BASE_H  = 6;    H = BASE_H + FILL_H;  // H=14
RIB_H   = 6;    RIB_W   = 3.0;  N_RIB = 7;
CHAM    = 1.0;  // edge chamfer size
CAV_WALL= 5;    CAV_ANG = 3;
N_CH    = 5;    CH_W    = 3.5;  CH_D = 3.0;
SN_W    = 10;   SN_H    = 4;    SN_L = 2.5;  SN_CHAM = 0.8;
SN_POS  = (IR+OR)/2;

// Platform
P_IR = IR  + CAV_WALL + 0.6;   // 80.6
P_OR = OR  - CAV_WALL - 0.6;   // 139.4
P_A1 = CAV_ANG + 0.5;
P_A2 = ANG - CAV_ANG - 0.5;
P_H  = 2.5;
HG_A = [P_A1 + (P_A2-P_A1)*0.28, P_A1 + (P_A2-P_A1)*0.72];
HG_D = 6.4;  HG_DEEP = 3.5;  HG_L = 9;
// PIP spring arms (replaces separate coil spring)
LEAF_T = 1.2;  LEAF_W = 10;  LEAF_L = 25;  LEAF_BASE = 3;  LEAF_RISE = 6.0;
LEAF_A = [P_A1+(P_A2-P_A1)*0.35, P_A1+(P_A2-P_A1)*0.65];
LT_ANG = (P_A1+P_A2)/2;
LT_W = 8;   LT_H = 4;   LT_D = 3.5;
RAMP_ANG = 35;  RAMP_H = 4;

// Hinge pins (in tile inner wall)
PIN_D = 6;   PIN_TALL = 6;   // protrudes outward from IR face into cavity
// Pin must align with platform U-channel centre: RIB_H + BASE_H + P_H/2 = 13.25mm
PIN_Z = RIB_H + BASE_H + P_H/2;   // Z centre of pin = U-channel centre

// Cartridge
CART_IR = IR + CAV_WALL + 0.5;
CART_OR = OR - CAV_WALL - 0.5;
CART_A1 = CAV_ANG + 0.5;
CART_A2 = ANG - CAV_ANG - 0.5;
CART_H  = 6.0;  // FILL_H(8) - LID_H(1.5) - clearance(0.5) = 6.0
CART_WALL = 1.5;
TAB_W = 14;  TAB_T = 4;  TAB_H = 14;
N_SLOTS = 4;  SLOT_W = 2.8;  SLOT_D = 1.5;

// Magazine — CORRECTED DIMENSIONS
// Inner hollow must fit cartridge (CART_IR=80.5 to CART_OR=139.5) with clearance
MAG_INNER_IR = CART_IR - 0.3;   // 80.2  (hollow inner bound)
MAG_INNER_OR = CART_OR + 0.3;   // 139.8 (hollow outer bound)
MAG_A1   = CART_A1 - 0.3;
MAG_A2   = CART_A2 + 0.3;
MAG_WALL = 2;
STACK_COUNT = 3;
CART_GAP = 0.5;
STACK_H  = STACK_COUNT * (CART_H + CART_GAP);
CLIP_W   = 3;  CLIP_DEPTH = 8;

// Trigger
LEVER_T = 4;  LEVER_W = 7;
HOOK_L  = 12; BTN_L   = 22;
PIVOT_D = 4.2;
HOOK_TIP_W=6; HOOK_TIP_H=3.5; HOOK_TIP_D=3;
BTN_W=14;  BTN_H=8;
BRKT_W=LEVER_W+8;  BRKT_H=BASE_H;  BRKT_DEPTH=6;
PIN_BRKT_D=3.1;

// ═══════════════════════════════════════════════════════════════════════
// GEOMETRY HELPERS
// ═══════════════════════════════════════════════════════════════════════

module pie_2d(r, a1, a2) {
  steps = max(4, ceil(a2-a1));
  pts = concat([[0,0]], [for(i=[0:steps])
    [r*cos(a1+i*(a2-a1)/steps), r*sin(a1+i*(a2-a1)/steps)]]);
  polygon(pts);
}

module ring_sector_2d(ri, ro, a1, a2) {
  intersection() {
    difference() { circle(ro); circle(ri); }
    pie_2d(ro+1, a1, a2);
  }
}

module rs(ri, ro, a1, a2, ht) {
  linear_extrude(ht) ring_sector_2d(ri, ro, a1, a2);
}

// ═══════════════════════════════════════════════════════════════════════
// COMPONENT MODULES
// ═══════════════════════════════════════════════════════════════════════

// ── TILE (sensor version + hinge pins added) ──────────────────────────
module tile() {
  translate([0,0,RIB_H]) {
    difference() {
      union() {
        rs(IR, OR, 0, ANG, H);
        // Structural ribs
        for(i=[0:N_RIB-1]) {
          a=(i+0.5)*ANG/N_RIB;
          rotate([0,0,a]) translate([IR,-RIB_W/2,-RIB_H]) cube([OR-IR,RIB_W,RIB_H]);
        }
        // Snap tab
        rotate([0,0,ANG]) translate([SN_POS-SN_W/2,0,BASE_H/2-SN_H/2])
          hull() {
            cube([SN_W,0.01,SN_H]);
            translate([SN_CHAM,SN_L,SN_CHAM]) cube([SN_W-2*SN_CHAM,0.01,SN_H-2*SN_CHAM]);
          }
        // ── HINGE PINS (new — not in individual tile files) ───────────
        // Two cylindrical pins protrude inward from IR inner face
        // Platform U-channels hook over these
        for(a=HG_A) {
          rotate([0,0,a])
            translate([IR, -HG_L/2, BASE_H+P_H/2-PIN_D/2])
              rotate([0,90,0]) cylinder(d=PIN_D, h=PIN_TALL);
        }
      }
      // Fill cavity
      translate([0,0,BASE_H]) rs(IR+CAV_WALL, OR-CAV_WALL, CAV_ANG, ANG-CAV_ANG, FILL_H+0.1);
      // V-groove radial channels (self-cleaning, 60° included angle)
      for(i=[0:N_CH-1]) {
        a=(i+0.5)*ANG/N_CH;
        rotate([0,0,a]) translate([IR-1,0,H-CH_D-0.01])
          hull() {
            cube([OR-IR+2,0.01,0.01]);
            translate([0,-CH_W/2,CH_D]) cube([OR-IR+2,0.01,0.01]);
            translate([0, CH_W/2,CH_D]) cube([OR-IR+2,0.01,0.01]);
          }
      }
      // Snap slot
      translate([SN_POS-SN_W/2-0.2,0,BASE_H/2-SN_H/2-0.2]) cube([SN_W+0.4,SN_L+0.5,SN_H+0.4]);
      // Edge chamfers
      for(a=[0,ANG]) rotate([0,0,a]) translate([IR,0,H-CHAM]) rotate([45,0,0]) cube([OR-IR,CHAM*1.5,CHAM*1.5]);
      // Sensor probe holes — match cowpad_tile_sensor.scad exactly
      // Angles: ANG/2 ± 10° = 12.5° and 32.5°; start at BASE_H (leave base intact)
      for(a=[ANG/2-10, ANG/2+10]) {
        rotate([0,0,a]) translate([(IR+OR)/2-10, 0, BASE_H-0.1]) cylinder(d=4.5, h=FILL_H+0.2);
      }
      // Wire channel
      rotate([0,0,ANG/2]) translate([(IR+OR)/2-12,-2,-0.1]) cube([OR-(IR+OR)/2+14,4,3.1]);
    }
  }
}

// ── EJECTOR PLATFORM ─────────────────────────────────────────────────
module platform() {
  difference() {
    union() {
      rs(P_IR, P_OR, P_A1, P_A2, P_H);
      // PIP leaf spring arms (integrated — no separate spring needed)
      for(a=LEAF_A) {
        rotate([0,0,a])
          translate([P_IR+2, -LEAF_W/2, P_H-0.1])
            hull() {
              cube([LEAF_BASE, LEAF_W, LEAF_T]);
              translate([LEAF_L, 0, LEAF_RISE]) cube([LEAF_BASE, LEAF_W, LEAF_T]);
            }
      }
      // Launch ramp
      a_mid=(P_A1+P_A2)/2;
      rotate([0,0,a_mid])
        translate([P_IR+10,(P_OR-P_IR-20)/2,P_H])
          rotate([90,0,0])
            linear_extrude(P_OR-P_IR-20)
              polygon([[0,0],[RAMP_H/tan(RAMP_ANG),0],[0,RAMP_H]]);
    }
    // Hinge U-channels
    for(a=HG_A) {
      rotate([0,0,a]) translate([P_IR,-HG_L/2,P_H/2-HG_D/2]) rotate([0,90,0]) cylinder(d=HG_D,h=HG_DEEP+0.1);
    }
    // Latch notch
    rotate([0,0,LT_ANG]) translate([P_OR-LT_D-1,-LT_W/2,-0.1]) cube([LT_D+1.1,LT_W,LT_H+0.1]);
  }
}

// ── BIOCHAR CARTRIDGE ────────────────────────────────────────────────
module cartridge() {
  difference() {
    union() {
      // Shell
      difference() {
        rs(CART_IR, CART_OR, CART_A1, CART_A2, CART_H);
        translate([0,0,CART_WALL]) rs(CART_IR+CART_WALL,CART_OR-CART_WALL,CART_A1+0.5,CART_A2-0.5,CART_H);
      }
      // Pull tab
      a_mid=(CART_A1+CART_A2)/2;
      rotate([0,0,a_mid]) translate([(CART_IR+CART_OR)/2-TAB_W/2,-TAB_T/2,CART_H-0.1])
        hull() {
          cube([TAB_W,TAB_T,1]);
          translate([1,0.5,TAB_H-1]) cube([TAB_W-2,TAB_T-1,0.01]);
        }
    }
    // Mesh slots
    for(i=[0:N_SLOTS-1]) {
      a=CART_A1+(i+0.5)*(CART_A2-CART_A1)/N_SLOTS;
      rotate([0,0,a]) translate([CART_IR+CART_WALL,-SLOT_W/2,CART_H-SLOT_D]) cube([CART_OR-CART_IR-2*CART_WALL,SLOT_W,SLOT_D+0.1]);
    }
  }
}

// ── MAGAZINE TUBE ────────────────────────────────────────────────────
module magazine() {
  N_RAILS=3;
  difference() {
    union() {
      // Tube walls
      difference() {
        rs(MAG_INNER_IR-MAG_WALL, MAG_INNER_OR+MAG_WALL, MAG_A1-1, MAG_A2+1, STACK_H);
        rs(MAG_INNER_IR, MAG_INNER_OR, MAG_A1, MAG_A2, STACK_H+0.1);
      }
      // Guide rails
      intersection() {
        rs(MAG_INNER_IR, MAG_INNER_OR, MAG_A1, MAG_A2, STACK_H);
        for(i=[0:N_RAILS-1]) {
          a=MAG_A1+(i+0.5)*(MAG_A2-MAG_A1)/N_RAILS;
          rotate([0,0,a]) translate([MAG_INNER_IR,-1,0]) cube([MAG_INNER_OR-MAG_INNER_IR,2,STACK_H]);
        }
      }
      // Mounting clip — solid band that grips tile outer wall
      // Shifted down by FILL_H so it overlaps the tile's fill cavity outer wall
      translate([0,0,-FILL_H])
        rs(OR, OR+MAG_WALL+CLIP_W, MAG_A1+3, MAG_A2-3, FILL_H+CLIP_DEPTH);
    }
  }
}

// ── TRIGGER LEVER ────────────────────────────────────────────────────
module trigger_lever() {
  difference() {
    union() {
      translate([-HOOK_L,-LEVER_W/2,0]) cube([HOOK_L,LEVER_W,LEVER_T]);
      translate([0,-LEVER_W/2,0]) cube([BTN_L,LEVER_W,LEVER_T]);
      translate([-HOOK_L,-HOOK_TIP_W/2,LEVER_T-0.1]) cube([HOOK_TIP_D,HOOK_TIP_W,HOOK_TIP_H]);
      translate([BTN_L-0.1,-BTN_W/2,0]) cube([LEVER_T,BTN_W,BTN_H]);
    }
    translate([0,0,-0.1]) cylinder(d=PIVOT_D,h=LEVER_T+0.2);
  }
}

module trigger_bracket() {
  difference() {
    union() {
      cube([BRKT_W,BRKT_DEPTH,BRKT_H],center=true);
      for(s=[-1,1]) translate([s*(BRKT_W/2-1.5),-CAV_WALL/2,0]) cube([3,BRKT_DEPTH+CAV_WALL,BRKT_H],center=true);
    }
    rotate([0,90,0]) translate([0,0,-BRKT_W/2-0.1]) cylinder(d=PIN_BRKT_D,h=BRKT_W+0.2);
    cube([LEVER_W+0.6,BRKT_DEPTH+0.2,LEVER_T+1.5],center=true);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// ASSEMBLED SCENE
// Each component lifted by EXPLODE × layer_index for exploded view
// ═══════════════════════════════════════════════════════════════════════

// ── Tile ─────────────────────────────────────────────────────────────
if(SHOW_TILE)
  color("WhiteSmoke")
    tile();

// ── Hinge pins (shown as separate silver cylinders for clarity) ───────
if(SHOW_HINGE_PINS)
  color("Silver")
    translate([0,0,EXPLODE*0])
      for(a=HG_A) {
        rotate([0,0,a])
          translate([IR, -HG_L/2, RIB_H+BASE_H+P_H/2-PIN_D/2])
            rotate([0,90,0]) cylinder(d=PIN_D,h=PIN_TALL);
      }

// ── Spring (cavity floor → passes through platform → presses against lid underside)
// Compressed to FILL_H-LID_H=6.5mm when platform is flat. Free height=15mm.
// Shown as stacked rings for fast preview (real spring = cowpad_spring.scad)
if(SHOW_SPRING) {
  color("Gold")
    rotate([0,0,SP_ANG])
      translate([SPRING_R, 0, RIB_H + BASE_H])
        for(i=[0:5]) {
          z = i * ((FILL_H - 1.5) / 6.0);  // max = 6.5mm = cavity depth
          translate([0,0,z])
            difference() {
              cylinder(d=8.0, h=0.9);
              cylinder(d=6.2, h=1.1);
            }
        }
}

// ── Platform (in cavity, flat/loaded position) ────────────────────────
// Sits on cavity floor. Shown in cyan so it's visible under cartridge.
_PLAT_Z = RIB_H + BASE_H + EXPLODE*1;
if(SHOW_PLATFORM)
  color("DeepSkyBlue", 1.0)
    translate([0,0,_PLAT_Z])
      platform();

// ── Active cartridge (sitting on platform) ───────────────────────────
_CART_Z = _PLAT_Z + P_H + EXPLODE*1;
if(SHOW_CARTRIDGE)
  color("LimeGreen", 0.7)   // slightly transparent so platform visible below
    translate([0,0,_CART_Z])
      cartridge();

// ── Magazine tube ─────────────────────────────────────────────────────
// V2 PRODUCTION: magazine mounts on OUTER TROUGH WALL beside tile.
// Tube hangs downward from clip at tile-top level — does NOT protrude above tile.
// Cow hooves only contact tile top surface (flush).
// Here shown clipped to OR face, top of tube = tile top, tube extends downward.
_MAG_Z = RIB_H + H - STACK_H + EXPLODE*2;  // bottom of tube near cavity level
if(SHOW_MAGAZINE)
  color("DimGray", 0.65)
    translate([0,0,_MAG_Z])
      magazine();

// ── Cartridges inside magazine (stacked, waiting) ────────────────────
if(SHOW_MAG_CARTS)
  for(i=[0:1]) {
    color("MediumSeaGreen", 0.6)
      translate([0,0,_MAG_Z + i*(CART_H+CART_GAP) + 0.5])
        cartridge();
  }

// ── Trigger lever + bracket ───────────────────────────────────────────
// Bracket clips onto tile outer wall at mid-arc.
// Lever pivots vertically: hook arm points INWARD (toward latch notch),
// button arm points OUTWARD for easy press.
if(SHOW_TRIGGER) {
  _TRIG_ANG = ANG/2;                        // 22.5° — arc midpoint
  _TRIG_Z   = RIB_H + BASE_H/2;            // mid-height of tile base = 7mm

  // Bracket — clips onto outer wall, centred at OR, width spans arc direction
  // rotate([0,0,-90]): BRKT_W(15mm) → Y (arc), BRKT_DEPTH(6mm) → X (radial outward)
  color("DarkOrange")
    rotate([0,0,_TRIG_ANG])
      translate([OR, 0, _TRIG_Z])
        rotate([0,0,-90])
          trigger_bracket();

  // Lever — pivot at OR, standing in vertical radial plane
  // rotate([90,0,0]): lever lifts from XY to XZ plane
  //   hook arm stays in -X = points inward toward tile/latch
  //   button arm stays in +X = points outward, easy to press
  color("Orange")
    rotate([0,0,_TRIG_ANG])
      translate([OR, 0, _TRIG_Z])
        rotate([90,0,0])
          trigger_lever();
}
