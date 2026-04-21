settings.outformat = "pdf";
import fontsize;
import patterns;

texpreamble("\usepackage{amsmath,amssymb}");

//  HATCH PATTERNS  (ground / fixed-frame hatching)
add("hatch", hatch(2mm));
add("hatchback", hatch(2mm, NW));
add("crosshatch",crosshatch(2mm));

//  MECHANISM GEOMETRY  (all lengths in diagram units; 1 du = 1 mm)

pair O = (0,  0);
pair A = (0,50);

real lenOB = 85;

pair B = O + lenOB*dir(-135);        // B on ray O→A, |OB| = 85

real lenAB = 125;
// write("lenAB =" + (string)lenAB + " mm");
path circleA = circle(A, lenAB);
// draw(circleA, black+dashed+1pt);        

path lineOB = O -- O + 200*dir(-135);
// draw(lineOB, black+dashed+1pt);   

pair B = intersectionpoint(circleA, lineOB);


// Ground rail (right side of OA)
fill(O--(10,0)--(10,50)--A--cycle, pattern("hatch"));
draw(O--A, black+1pt);                         // ground link OA

for (pair P : new pair[]{O, A, B})
  dot(P, blue+3pt);

label("$O$", O, S, fontsize(8pt));
label("$A$", A, N, fontsize(8pt));
label("$B$", B+(-4, -5), fontsize(8pt));

pair unitOB = unit(B - O);

// // ── piston cylinder ( link 3) ───────────────────────────────────────────
real uAngleOB = degrees(atan2(unitOB.y, unitOB.x));
pair uOB = unit(B - O), vOB = rotate(90)*uOB;
real rw = length(B-O)-10, rh = 10+2;
path sliderB = (B-(rw/2)*uOB-(rh/2)*vOB)
                --(B+(rw/2)*uOB-(rh/2)*vOB)
                --(B+(rw/2)*uOB+(rh/2)*vOB)
                --(B-(rw/2)*uOB+(rh/2)*vOB)--cycle;
draw(sliderB, black+1pt);

pair T3 = B+(rw/2)*uOB;
pair B3 = B-(rw/2)*uOB;
draw(B3--O, black+1pt);     

// // ── piston (on link 3) ───────────────────────────────────────────
real uAngleOB = degrees(atan2(unitOB.y, unitOB.x));
pair uOB = unit(B - O), vOB = rotate(90)*uOB;
real rw = 20, rh = 10;
path sliderB = (B-(rw/2)*uOB-(rh/2)*vOB)
              --(B+(rw/2)*uOB-(rh/2)*vOB)
              --(B+(rw/2)*uOB+(rh/2)*vOB)
              --(B-(rw/2)*uOB+(rh/2)*vOB)--cycle;
fill(sliderB, lightcyan+opacity(0.4));
draw(sliderB);

label("$2$", (A+B)/2 + (0,5), N, fontsize(8pt));
label("$1$", (O+A)/2, W, fontsize(8pt));
label("$3$", (T3+O)/2, NE, fontsize(8pt));

draw(B--A, black+1pt);                         // crank AB


write("=== MECHANISM ===");
write("O =" + (string)O);
write("A =" + (string)A);
write("B =" + (string)B);
write("|OB| =" + (string)length(B-O));
write("|AB| =" + (string)length(B-A));


// //  VELOCITY DIAGRAM
// //  mechscale : 1000 du/m  (1 du = 1 mm)
// //  velscale  : 100 du/(m/s)
// //  Pole      : o  (coincides with a, since A is a fixed pin)

write("=== VELOCITY ===");
real mechscale = 1000;                      // 1000 du = 1 m
real omegaOB   = 2*pi*300/60;                    // 12.57 rad/s  (2 rev/s = 120 RPM)
write("omegaOB =" + (string)omegaOB + " rad/s");

pair velpole = B + (0, 80);             // pole location
dot("$o,a$", velpole, E);

real velBO3_mag  = omegaOB * length(B-O) / mechscale;   // m/s (convert mm to m)
write("v_{B_{3}/O} =" + (string)velBO3_mag + " m/s");
real velscale = velBO3_mag / 200;                         // 100 du = velBO3_mag m/s

// v_{B_{3}/O} : ⊥ OB, magnitude = omegaOB * |OB|
pair dirPerpOB  = unit(rotate(-90)*(B - O));               // ⊥ OB
pair pt_b2       = velpole + velBO3_mag* dirPerpOB / velscale;

draw(velpole--pt_b2, gray+2pt, Arrow(8));
dot("$b$", pt_b2, NW);
label("$\overset{\checkmark\checkmark}{v}_{B_{3}/O}$", (velpole+pt_b2)/2, NE);

// v_{B_{2}/A} and v_{B_{2}/B_{3}} : find b4
pair dirParAB  = unit(B - A);                 // AB direction
pair dirPerpAB = unit(rotate(-90)*dirParAB);   //
pair pt_a      = velpole + velBO3_mag* dirPerpAB / velscale * 1.2;    // along AB from o, mag unknown (scaled by 2 just to be visible)
draw(velpole--pt_a, gray+dashed+1pt);


// // // v_{B_{2}/{B_{3}}} : ⊥ AB, magnitude = unknown
pair dirParOB = unit(B - O);                 // ‖ OB (slider constraint)
pair pt_c = pt_b2 + velBO3_mag * dirParOB / velscale * 0.5;    // along OB from o, mag unknown (scaled by 2 just to be visible)
draw(pt_b2--pt_c, gray+dashed+1pt);

path lineL1_vel = velpole -- velpole + velBO3_mag* dirPerpAB / velscale * 1.2;
path lineL2_vel = pt_b2 -- pt_b2 + velBO3_mag * dirParOB / velscale * 0.5;

pair pt_b3 = intersectionpoint(lineL1_vel, lineL2_vel);
dot("$b_{3}$", pt_b3, W);

write("v_{B_{2}/B_{3}} =" + (string)(length(pt_b3 - pt_b2) * velscale) + " m/s");
write("v_{B_{2}/A} =" + (string)(length(pt_a - velpole) * velscale) + " m/s");

draw(velpole--pt_b3, gray+2pt, Arrow(8));
label("$\overset{?\checkmark}{v}_{B_{2}/A}$", (velpole+pt_b3)/2 + (0, 5), SW);
draw(pt_b2--pt_b3, gray+2pt, Arrow(8));
label("$\overset{?\checkmark}{v}_{B_{2}/B_{3}}$", (pt_b2+pt_b3)/2, NW);    



// //  ACCELERATION DIAGRAM
pair accpole = velpole + (-300, -300);
dot("$o, a$", accpole, W);

real accB3O_n_mag = (omegaOB^2) * (length(B-O) / mechscale);   // a^n_{B3/O}
real accscale = accB3O_n_mag / 200;

write("=== ACCELERATION ===");
write("a^n_{B_{3}/O} =" + (string)accB3O_n_mag + " m/s^2");

// Step 1: o → p: a^n_{B3/O} (centripetal, toward O)
pair pt_p = accpole - accB3O_n_mag / accscale * dirParOB;
draw(accpole--pt_p, blue+2pt, Arrow(8));
label("$\overset{\checkmark \checkmark}{a^n}_{B_{3}/O}$", (accpole+pt_p)/2, SE);
dot("$p$", pt_p, blue+3pt);

// Step 2: p → q: Coriolis acceleration (perpendicular to OB)
real velB2B3_mag = length(pt_b3 - pt_b2) * velscale;
real accCor_mag = 2 * omegaOB * velB2B3_mag;
pair dirCor = unit(rotate(-90)*(pt_b3 - pt_b2));
pair pt_q = pt_p + accCor_mag / accscale * dirCor;
draw(pt_p--pt_q, red+2pt, Arrow(8));
label("$\overset{\checkmark \checkmark}{a^c}$",  (pt_p+pt_q)/2, NE);
dot("$q$", pt_q, NW, red+3pt);
write("a^c=" + (string)accCor_mag + " m/s^2");

// Step 3: o → r: a^n_{B2/A} (centripetal, toward A)
real velB2A_mag = length(pt_b3 - velpole) * velscale;
real accB2A_n_mag = (velB2A_mag^2) / (length(B-A) / mechscale);
pair pt_r = accpole - accB2A_n_mag / accscale * dirParAB;
draw(accpole--pt_r, green+2pt, Arrow(8));
label("$a^n_{B_{2}/A}$", (accpole+pt_r)/2, NW);
dot("$r$", pt_r, green+3pt);
write("a^n_{B_{2}/A} =" + (string)accB2A_n_mag + " m/s^2");

// Step 4: From q: a_{B2/B3} must be PARALLEL to OB (slider constraint)
pair dirParOB_acc = dirParOB;
path line_from_q = pt_q + 200*dirParOB_acc -- pt_q - 50*dirParOB_acc;
draw(line_from_q, blue+dashed+1pt);
label("$a_{B_{2}/B_{3}}$ $\parallel$ OB", pt_q + 200*dirParOB_acc, W);

// Step 5: From r: a^t_{B2/A} must be PERPENDICULAR to AB
pair dirPerpAB_acc = unit(rotate(-90)*dirParAB);
path line_from_r = pt_r + 200*dirPerpAB_acc -- pt_r - 100*dirPerpAB_acc;
draw(line_from_r, green+dashed+1pt);
label("$a^t_{B_{2}/A}$ $\perp$ AB", pt_r + 200*dirPerpAB_acc, N);

// Step 6: Find intersection q1 → total acceleration of B2
pair[] acc_intersection = intersectionpoints(line_from_q, line_from_r);
if (acc_intersection.length > 0) {
  pair pt_q1 = acc_intersection[0];
  dot("$q_1$", pt_q1, W+N, black+3pt);
  
  // Calculate components
  real accB2B3_mag = length(pt_q1 - pt_q) * accscale;
  real accB2A_t_mag = length(pt_q1 - pt_r) * accscale;
  
  // Complete the polygon: q → q1 and r → q1
  draw(pt_q--pt_q1, red+2pt, Arrow(8));
  label("$a^t_{B_{2}/B_{3}}$", (pt_q+pt_q1)/2, NW);
  
  draw(pt_r--pt_q1, green+2pt, Arrow(8));
  label("$a^t_{B_{2}/A}$", (pt_r+pt_q1)/2, S);
  
  // Additional: p → q1 representing a_{B2/B3} composition
  draw(pt_p--pt_q1, orange+1.5pt+dashed, Arrow(6));
  label("$a_{B_{2}/B_{3}}$", (pt_p+pt_q1)/2, N);
  
  // Total acceleration from pole to q1
  draw(accpole--pt_q1, black+3pt, Arrow(8));
  label("$a_{B_{2}/A}$", (accpole+pt_q1)/2, W);
  
  real accB2A_mag = length(pt_q1 - accpole) * accscale;
  write("a_{B_{2}/B_{3}} =" + (string)accB2B3_mag + " m/s^2");
  write("a^t_{B_{2}/A} =" + (string)accB2A_t_mag + " m/s^2");
  write("a_{B_{2}/A} =" + (string)accB2A_mag + " m/s^2");
  
  // Draw closed polygon loops
  draw(accpole--pt_p--pt_q--pt_q1--accpole, gray+0.5pt+dashed);
  draw(accpole--pt_r--pt_q1, gray+0.5pt+dashed);
}