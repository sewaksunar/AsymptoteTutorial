settings.outformat = "pdf";
import fontsize;
import patterns;

texpreamble("\usepackage{amsmath,amssymb}");

// ════════════════════════════════════════════════════════════════════════════
//  HATCH PATTERNS  (ground / fixed-frame hatching)
// ════════════════════════════════════════════════════════════════════════════
add("hatch",     hatch(3mm));
add("hatchback", hatch(3mm, NW));
add("crosshatch",crosshatch(2mm));

// ════════════════════════════════════════════════════════════════════════════
//  MECHANISM GEOMETRY  (all lengths in diagram units; 1 du = 1 mm)
//
//  Fixed frame : O (lower pivot), A (upper pin, vertical guide rail on right)
//  Link AB     : crank rotating about A, |AB| = 150, initial angle 135°
//  Link OC     : rocker rotating about O; B slides along it; |OC| = 700
//  Link CD     : coupler from C to horizontal slider D; |CD| = 200
//  Slider D    : travels on horizontal guide at y = H.y = 700
// ════════════════════════════════════════════════════════════════════════════
pair O = (0,  0);
pair A = (0,400);

real lenAB = 150;
real lenOC = 700;
real lenCD = 200;

pair B = A + lenAB*dir(135);        // crank pin — also slides on link OC

// Ground rail (right side of OA)
fill(O--(20,0)--(20,400)--A--cycle, pattern("hatch"));
draw(O--A);
draw(B--A);                         // crank AB

for (pair P : new pair[]{O, A, B})
  dot(P, blue+3pt);

label("$O$", O, SW);
label("$A$", A, NE);
label("$B$", B, SW);

// Horizontal dash-dot reference line at y = 700
pair H = A + (0,300);               // H = (0,700)
draw(H+(-80,0)--H+(80,0), dashdotted);

// C on ray O→B, |OC| = 700
pair unitOB = unit(B - O);
pair C = O + lenOC * unitOB;
draw(O--C, red);
dot(C, blue+3pt);
label("$C$", C, NE);

// D : intersection of circle(C,200) with horizontal line y = 700
pair[] Dpts = intersectionpoints(circle(C, lenCD),
                                  H+(-100,0)--H+(20,0));
pair D = (Dpts.length > 0) ? Dpts[0] : H;
draw(C--D, green);
dot(D, blue+3pt);
label("$D$", D, S);

// ── slider block at B (on link OC) ───────────────────────────────────────────
real uAngleOC = degrees(atan2(unitOB.y, unitOB.x));
pair uOC = unit(C - O), vOC = rotate(90)*uOC;
real rw = 60, rh = 40;
path sliderB = (B-(rw/2)*uOC-(rh/2)*vOC)
              --(B+(rw/2)*uOC-(rh/2)*vOC)
              --(B+(rw/2)*uOC+(rh/2)*vOC)
              --(B-(rw/2)*uOC+(rh/2)*vOC)--cycle;
fill(sliderB, lightcyan+opacity(0.4));
draw(sliderB);
dot(B, red+2pt);

// ── horizontal slider block at D ─────────────────────────────────────────────
pair uH = (1,0), vH = (0,1);
real rw2 = 60, rh2 = 40;
pair Q1 = D-(rw2/2)*uH-(rh2/2)*vH,  Q2 = D+(rw2/2)*uH-(rh2/2)*vH,
     Q3 = D+(rw2/2)*uH+(rh2/2)*vH,  Q4 = D-(rw2/2)*uH+(rh2/2)*vH;
path sliderD = Q1--Q2--Q3--Q4--cycle;
fill(sliderD, lightred+opacity(0.4));
draw(sliderD);

// ground hatching below and above slider D (horizontal guide)
path groundD_bot = Q1+(-20,0)--Q2+(20,0)--Q2+(20,-10)--Q1+(-20,-10)--cycle;
path groundD_top = Q3+(20,0)--Q4+(-20,0)--Q4+(-20,10)--Q3+(20,10)--cycle;
fill(groundD_bot, pattern("hatchback"));
fill(groundD_top, pattern("hatchback"));
dot(D, red+2pt);
label("$D$", D, S);

write("=== MECHANISM ===");
write("O =" + (string)O);
write("A =" + (string)A);
write("B =" + (string)B);
write("C =" + (string)C);
write("D =" + (string)D);
write("|OB| =" + (string)length(B-O));
write("|OC| =" + (string)length(C-O));
write("|AB| =" + (string)length(B-A));
write("|CD| =" + (string)length(D-C));

// lableing links
label("$1$", (O+A)/2, NW);
label("$2$", (A+B)/2, NE);
label("$3$", B, NE);
label("$4$", (O+C)/2, NE);
label("$5$", (C+D)/2, NE);

// ════════════════════════════════════════════════════════════════════════════
//  VELOCITY DIAGRAM
//  mechscale : 1000 du/m  (1 du = 1 mm)
//  velscale  : 100 du/(m/s)
//  Pole      : o  (coincides with a, since A is a fixed pin)
//
//  Step 1:  v_{B/A}  ⊥ AB,  mag = omegaAB · |AB|                    → pt_b
//  Step 2:  v_{B'/O} ⊥ OB,  direction known, mag unknown             from o
//           v_{B/B'} ‖ OB,  direction known, mag unknown             from pt_b
//           intersection → pt_bprime
//  Step 3:  v_{C/O}  ‖ OB,  mag = (|OC|/|OB|) · |v_{B'/O}|          → pt_c
//  Step 4:  v_{D/C}  ⊥ CD,  direction known, mag unknown             from pt_c
//           v_{D/O}  horizontal, direction known, mag unknown         from o
//           intersection → pt_d
// ════════════════════════════════════════════════════════════════════════════
write("=== VELOCITY ===");

real mechscale = 1000;                      // 1000 du = 1 m
real omegaAB   = 2*pi*2;                    // 12.57 rad/s  (2 rev/s = 120 RPM)
real velscale  = 200;                       // 100 du = 1 m/s
write("omegaAB =" + (string)omegaAB + " rad/s");

pair velpole = O + (-300, 750);             // o = a  (A is fixed → v_A = 0)
dot("$o,a$", velpole, E);

// Step 1 — v_{B/A} : ⊥ to AB, magnitude = omegaAB · |AB|
real velBA_mag  = omegaAB * (length(B-A) / mechscale);   // m/s
pair dirPerpAB  = unit(rotate(90)*(B - A));               // ⊥ AB
pair pt_b       = velpole + velBA_mag * velscale * dirPerpAB;

draw(velpole--pt_b, gray+2pt, Arrow(8));
dot("$b$", pt_b, SW);
label("$\overset{\checkmark\checkmark}{v}_{B_{2}/A}$", (velpole+pt_b)/2, SE);
write("v_{B/A} =" + (string)velBA_mag + " m/s");

// Step 2 — v_{B'/O} and v_{B/B'} : find b'
//   L1 : from o, ⊥ OB   (v_{B'/O} direction)
//   L2 : from b, ‖ OB   (v_{B/B'} direction, slider along OC)
pair dirPerpOB = unit(rotate(90)*(B - O));    // ⊥ OB (rotation of OC)
pair dirParOB  = unit(B - O);                 // ‖ OB (slider constraint)

path lineL1_vel = velpole + 1000*dirPerpOB -- velpole - 1000*dirPerpOB;
path lineL2_vel = pt_b    + 1000*dirParOB  -- pt_b    - 1000*dirParOB;

// Dashed construction arrows
draw(velpole -- velpole + 500*dirPerpOB, gray+dashed+1pt);
label("$\overset{? \checkmark}{v}_{B_{2}/O}$", velpole + 500*dirPerpOB, NW);

draw(pt_b + 250*dirParOB -- pt_b, gray+dashed+1pt, Arrow(8));
label("$\overset{? \checkmark}{v}_{B_{2}/B_{4}}$", pt_b + 250*dirParOB -(0, 5), NW);

pair pt_b4 = intersectionpoint(lineL1_vel, lineL2_vel);
dot("$b_{4}$", pt_b4, NW);

// Final solved vectors for step 2
draw(velpole--pt_b4, gray+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{v}_{B_{4}/O}$", pt_b4+(0,5), NE);

draw(pt_b--pt_b4, gray+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{v}_{B_{2}/B_{4}}$", (pt_b+pt_b4)/2, SE);

real velBprimeO_mag = length(pt_b4 - velpole) / velscale;
real velBBprime_mag = length(pt_b4 - pt_b)    / velscale;
real omegaOC        = velBprimeO_mag / (length(B-O) / mechscale);
write("v_{B'/O} =" + (string)velBprimeO_mag + " m/s");
write("v_{B/B'} =" + (string)velBBprime_mag + " m/s");
write("omegaOC =" + (string)omegaOC + " rad/s");

// Step 3 — v_{C/O} : same direction as v_{B'/O}, scaled by |OC|/|OB|
real velCO_mag = velBprimeO_mag * (length(C-O) / length(B-O));
pair pt_c = velpole + velCO_mag * velscale * unit(pt_b4 - velpole);

draw(velpole--pt_c, gray+2pt, Arrow(8));
dot("$c$", pt_c, SW);
label("$\overset{\checkmark\checkmark}{v}_{C/O}$",pt_c+(0,5), NE);
write("v_{C/O} =" + (string)velCO_mag + " m/s");

// Step 4 — v_{D/C} and v_{D/O} : find d
//   L3 : from c, ⊥ CD   (v_{D/C} direction, link CD rotates)
//   L4 : from o, horizontal  (v_{D/O} direction, D slides horizontally)
pair dirPerpCD = unit(rotate(90)*(D - C));
pair dirHoriz  = (1,0);                      // D slides horizontally

path lineL3_vel = pt_c    + 1000*dirPerpCD -- pt_c    - 1000*dirPerpCD;
path lineL4_vel = velpole + 1000*dirHoriz  -- velpole - 1000*dirHoriz;

// Dashed construction arrows
draw(pt_c --pt_c + 150*dirPerpCD, gray+dashed+1pt);
label("$\overset{?\checkmark}{v}_{D/C}$", pt_c + 150*dirPerpCD, NW);

draw(velpole - (500,0) -- velpole, gray+dashed+1pt);
label("$\overset{?\checkmark}{v}_{D/O}$", velpole-(500,0), S);

pair pt_d = intersectionpoint(lineL3_vel, lineL4_vel);
dot("$d$", pt_d, NW);

draw(pt_c--pt_d, gray+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{v}_{D/C}$", (pt_c+pt_d)/2, NW);

draw(velpole--pt_d, gray+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{v}_{D/O}$",(velpole+pt_d)/2, N);

real velDC_mag = length(pt_d - pt_c)    / velscale;
real velD_mag  = length(pt_d - velpole) / velscale;
write("v_{D/C} =" + (string)velDC_mag + " m/s");
write("v_{D}   =" + (string)velD_mag + " m/s");

// ════════════════════════════════════════════════════════════════════════════
//  ACCELERATION DIAGRAM
//  accscale : 10 du/(m/s²)
//  Pole     : o  (= a, since A is fixed → a_A = 0)
//
//  Step 1:  a^n_{B/A}  ‖ A→B,  mag = omegaAB² · |AB|               → pt_b_acc
//  Step 2:  a^c_{B/B'} ⊥ OB,   mag = 2·omegaOC·v_{B/B'}   from pt_b_acc → pt_x
//           a^t_{B/B'} ‖ OB,   unknown                              from pt_x
//  Step 3:  a^n_{B'/O} ‖ O→B,  mag = omegaOC² · |OB|               → pt_y
//           a^t_{B'/O} ⊥ OB,   unknown                              from pt_y
//           intersection of (a^t_{B/B'} locus) and (a^t_{B'/O} locus) → pt_b2
//  Step 4:  a_{C/O} = (|OC|/|OB|) · a_{B'/O}                       → pt_c_acc
//  Step 5:  a^n_{D/C} ‖ C→D,   mag = omegaCD² · |CD|               → pt_z
//           a^t_{D/C} ⊥ CD,    unknown                              from pt_z
//           a_{D/O}   horizontal, unknown                            from o
//           intersection → pt_d_acc
// ════════════════════════════════════════════════════════════════════════════
write("=== ACCELERATION ===");

real accscale = 50;                         // 10 du = 1 m/s²

pair accpole = (-800, 400);
dot("$o,a$", accpole, W);

// Step 1 — a^n_{B/A} : ‖ A→B (centripetal), mag = omegaAB² · |AB|
real accBA_n_mag  = (omegaAB^2) * (length(B-A) / mechscale);
pair dirAtoB = unit(B - A);
pair pt_b_acc = accpole - accBA_n_mag * accscale * dirAtoB;  // points A→B from o

draw(accpole--pt_b_acc, red+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{a}^n_{B/A}$", (accpole+pt_b_acc)/2, W);
dot("$p$", pt_b_acc, SE);
write("a^n_{B/A} =" + (string)accBA_n_mag + " m/s^2");

// Step 2 — a^c_{B/B'} (Coriolis) : ⊥ OB from pt_b_acc
//   direction of b→b' in velocity diagram gives rotation sense of B/B'
real accCor_BB_mag = 2 * omegaOC * velBBprime_mag;
pair dirCorBB      = unit(rotate(90)*(pt_b4 - pt_b));   // sense from vel diagram
pair pt_x          = pt_b_acc + accCor_BB_mag * accscale * dirCorBB;

draw(pt_b_acc--pt_x, 2pt+red, Arrow(8));
label("$\overset{\checkmark\checkmark}a^c_{B_{2}/B_{4}}$", (pt_b_acc+pt_x)/2 + (0, -5), SW);
dot("$q$", pt_x, SW);
write("a^c_{B_{2}/B_{4}} =" + (string)accCor_BB_mag + " m/s^2");

// Step 3 — a^n_{B'/O} : ‖ O→B (centripetal), mag = omegaOC² · |OB|
real accBprO_n_mag = (omegaOC^2) * (length(B-O) / mechscale);
pair pt_y  = accpole - accBprO_n_mag * accscale * unit(B - O);

draw(pt_y--accpole, orange+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{a}^n_{B_{4}/O}$", (accpole+pt_y)/2, SE);
dot("$r$", pt_y, SE);
write("a^n_{B_{4}/O} =" + (string)accBprO_n_mag + " m/s^2");

// Intersection: a^t_{B/B'} (‖ OB from x) ∩ a^t_{B'/O} (⊥ OB from y) → pt_b2
pair dirParOB_acc  = unit(B - O);
pair dirPerpOB_acc = unit(rotate(90)*(B - O));

path lineAt_BB  = pt_x + 1500*dirParOB_acc  -- pt_x - 1500*dirParOB_acc;
path lineAt_BpO = pt_y + 1500*dirPerpOB_acc -- pt_y - 1500*dirPerpOB_acc;

// Dashed construction lines
draw(pt_x - 50*dirParOB_acc  -- pt_x + 800*dirParOB_acc,  gray+dashed+1pt);
label("$\overset{?\checkmark}{a}^t_{B_{2}/B_{4}}$", pt_x + 800*dirParOB_acc, NW);

draw(pt_y + 20*dirPerpOB_acc -- pt_y - 400*dirPerpOB_acc, gray+dashed+1pt);
label("$\overset{?\checkmark}{a}^t_{B_{4}/O}$", pt_y - 400*dirPerpOB_acc, NE);

pair[] accInters1 = intersectionpoints(lineAt_BB, lineAt_BpO);
if (accInters1.length > 0) {
  pair pt_b2 = accInters1[0];
  dot("$s$", pt_b2, NE);

  draw(pt_y--pt_b2, 2pt+orange, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}^t_{B_{4}/O}$",(pt_y+pt_b2)/2 + (50, 10), NW);

  draw(pt_x--pt_b2,     gray+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}^t_{B_{2}/B_{4}}$", (pt_x+pt_b2)/2, SE);

  draw(pt_b_acc--pt_b2, red+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}_{B/A}$", (pt_b_acc+pt_b2)/2 + (0, 10), SE);

  draw(accpole--pt_b2, gray);                // o→b2 (total a_{B'/O})

  real accBpO_t_mag  = length(pt_b2 - pt_y) / accscale;
  real alpha_OC      = accBpO_t_mag / (length(B-O) / mechscale);
  write("a^t_{B'/O} =" + (string)accBpO_t_mag + " m/s^2");
  write("alpha_OC =" + (string)alpha_OC + " rad/s^2");

  // Step 4 — a_{C/O} : same direction as a_{B'/O}, scaled by |OC|/|OB|
  pair pt_c_acc = accpole + (length(C-O)/length(B-O)) * (pt_b2 - accpole);
  dot("$c$", pt_c_acc, NW);
  draw(accpole--pt_c_acc, gray+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}_{C/O}$",
        (accpole+pt_c_acc)/2, NE);
  write("a_{C/O} =" + (string)(length(pt_c_acc - accpole)/accscale) + " m/s^2");

  // Step 5 — a^n_{D/C} : ‖ C→D, mag = omegaCD² · |CD|
  pair dirCtoD       = unit(D - C);
  real omegaCD       = velDC_mag / (length(D-C) / mechscale);
  real accDC_n_mag   = (omegaCD^2) * (length(D-C) / mechscale);
  pair pt_z          = pt_c_acc + accDC_n_mag * accscale * dirCtoD;

  draw(pt_c_acc--pt_z, gray+dashed+1pt, Arrow(8));
  dot("$z$", pt_z, NE);
  label("$\overset{\checkmark\checkmark}{a}^n_{D/C}$",(pt_c_acc+pt_z)/2, N);
  write("a^n_{D/C} =" + (string)accDC_n_mag + " m/s^2");

  // a^t_{D/C} : ⊥ CD from pt_z  (direction known, magnitude unknown)
  pair dirPerpCD_acc = unit(rotate(90)*(D - C));
  path lineAt_DC = pt_z + 500*dirPerpCD_acc -- pt_z - 500*dirPerpCD_acc;

  // a_{D/O} : horizontal from o  (D slides horizontally)
  pair dirHoriz_acc = (1,0);
  path lineD_horiz  = accpole + 500*dirHoriz_acc -- accpole - 500*dirHoriz_acc;

  // Dashed construction lines
  draw(pt_z + 250*dirPerpCD_acc -- pt_z - 50*dirPerpCD_acc, gray+dashed+1pt);
  label("$\overset{?\checkmark}{a}^t_{D/C}$", pt_z + 250*dirPerpCD_acc, NE);

  draw(accpole - (50,0) -- accpole + (600,0), gray+dashed+1pt);
  label("$\overset{?\checkmark}{a}_{D/O}$", accpole + (600,0), E);

  pair[] accInters2 = intersectionpoints(lineAt_DC, lineD_horiz);
  if (accInters2.length > 0) {
    pair pt_d_acc = accInters2[0];
    dot("$d$", pt_d_acc, NW);

    draw(pt_z--pt_d_acc, gray+2pt, Arrow(8));
    label("$\overset{\checkmark\checkmark}{a}^t_{D/C}$",
          (pt_z+pt_d_acc)/2, NW);

    draw(accpole--pt_d_acc, gray+2pt, Arrow(8));
    label("$\overset{\checkmark\checkmark}{a}_{D}$",
          (accpole+pt_d_acc)/2, S);

    real accD_mag = length(pt_d_acc - accpole) / accscale;
    write("a_{D} =" + (string)accD_mag + " m/s^2");
  }
}
