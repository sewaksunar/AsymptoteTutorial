settings.outformat = "pdf";
import fontsize;
import geometry;

texpreamble("\usepackage{amsmath,amssymb}");

pair origin = (0,0);

real ro4o2 = 300; // in relative units

pair pointO4 = origin;
pair pointO2 = origin + ro4o2*dir(90);

draw(pointO4--pointO2, black+1.5pt+dashed);
dot("$O_2$", pointO2, W);
dot("$O_4$", pointO4, W);

pair pointA = pointO2 + 175*dir(-75);

draw(pointO2--pointA, black+1.5pt);
dot("$A$", pointA, NE);

pair vecO4A   = pointA - pointO4;
pair normalO4A = unit(vecO4A);
real velO4A_len = 700;
pair pointB   = origin + velO4A_len * normalO4A;
draw(pointO4--pointB, black+1.5pt);
dot("$B$", pointB, NE);

// ── helpers ──────────────────────────────────────────────────────────────────
pair get_midpoint(pair p1, pair p2) { return (p1+p2)/2; }

real get_angle(pair v) { return degrees(atan2(v.y, v.x)); }

path rectangle(pair center, real len, real wid, real angle) {
  pair d = dir(angle), p = rotate(90)*d;
  pair c0 = center - (len/2)*d - (wid/2)*p;
  pair c1 = center + (len/2)*d - (wid/2)*p;
  pair c2 = center + (len/2)*d + (wid/2)*p;
  pair c3 = center - (len/2)*d + (wid/2)*p;
  return c0--c1--c2--c3--cycle;
}

pair get_corner(pair center, real len, real wid, real angle, int idx) {
  pair d = dir(angle), p = rotate(90)*d;
  pair[] c = new pair[4];
  c[0] = center - (len/2)*d - (wid/2)*p;
  c[1] = center + (len/2)*d - (wid/2)*p;
  c[2] = center + (len/2)*d + (wid/2)*p;
  c[3] = center - (len/2)*d + (wid/2)*p;
  return c[idx];
}

// ── link body (slider block at A) ────────────────────────────────────────────
path rectA = rectangle(pointA, 50, 30, get_angle(pointA - pointO4));
fill(rectA, lightcyan+opacity(0.4));
draw(rectA);

label("$4$", get_midpoint(pointO4, pointB),  NE);
label("$2$", get_midpoint(pointO2, pointA),  NE);
label("$1$", get_midpoint(pointO4, pointO2), NE);
label("$3$", get_corner(pointA, 50, 30, get_angle(pointA-pointO4), 1), NE);

write("B =", pointB);

// ════════════════════════════════════════════════════════════════════════════
//  VELOCITY DIAGRAM
// ════════════════════════════════════════════════════════════════════════════
real omega2 = (60 * 2*pi)/60;            // 2π rad/s  (60 RPM)
write("omega2 =", omega2);

pair velpole = (238.478498150755, -182.726789419917);

// v_{A2/O2} : ⊥ to link 2 (O2A), magnitude = omega2 × |O2A|
real  velA2O2_mag = omega2 * length(pointA - pointO2);
pair  unitA2O2 = unit(rotate(90)*(pointA - pointO2));
real  velscale = velA2O2_mag / 400;  // diagram units → m/s
pair  pt_vA2O2 = velpole + (velA2O2_mag/velscale) * unitA2O2;

draw(velpole--pt_vA2O2, red, Arrow(8));
dot("$o$",velpole,   W);
dot("$\overset{\checkmark\checkmark}{v}_{A_2/O_2}$", pt_vA2O2, NW);
write("v_{A2/O2} =", velA2O2_mag);

// ── construction lines ───────────────────────────────────────────────────────
// Line L1 : from pt_vA2O2 along link-4 axis (O4→A) — slider relative motion
//   v_{A2/A4} is PARALLEL to O4A  (slider constraint)
pair sliderDir   = unit(pointA - pointO4);              // ← FIX: was unit(pointA-pointO2)
path lineL1 = pt_vA2O2 + 1000*sliderDir -- pt_vA2O2 - 1000*sliderDir;

// Line L2 : from velpole ⊥ to O4A — v_{A4/O4} direction (rotation of link 4)
pair perpO4A_dir = unit(rotate(-90)*(pointA - pointO4));
path lineL2 = velpole + 1000*perpO4A_dir -- velpole - 1000*perpO4A_dir;

// Draw dashed construction arrows (unknown magnitudes)
draw(velpole -- (velpole + 1200/velscale*perpO4A_dir), red+dashed+1pt, Arrow(8));
label("$\overset{?\checkmark}{v}_{A_4/O_4}$", velpole + 1200/velscale*perpO4A_dir, SE);

draw(pt_vA2O2 -- (pt_vA2O2 + 200/velscale*sliderDir), red+dashed+1pt, Arrow(8));
label("$\overset{?\checkmark}{v}_{A_2/A_4}$", pt_vA2O2 + 200/velscale*sliderDir, NE);

// ── intersection → point b ───────────────────────────────────────────────────
pair[] inters = intersectionpoints(lineL1, lineL2);
pair p_vA4O4 = inters[0];
dot("$b$", p_vA4O4, NW+(0,2));

// ── final solved velocity vectors ────────────────────────────────────────────
draw(velpole--p_vA4O4, red, Arrow(8));
label("$\overset{\checkmark \checkmark}{v}_{A_4/O_4}$", p_vA4O4, SW);

draw(p_vA4O4--pt_vA2O2, red, Arrow(8));
label("$\overset{\checkmark\checkmark}{v}_{A_2/A_4}$", pt_vA2O2+(0,-5), SE);

real velA4O4_mag = length(velpole - p_vA4O4) * velscale;
real velA2A4_mag = length(p_vA4O4 - pt_vA2O2) * velscale;
write("v_{A4/O4} =", velA4O4_mag);
write("v_{A2/A4} =", velA2A4_mag);

// ── angular velocity of link 4 ───────────────────────────────────────────────
real omega4 = velA4O4_mag / length(pointA - pointO4);
write("omega4 =", omega4);   // should be ≈ 6.57 rad/s

// ════════════════════════════════════════════════════════════════════════════
//  ACCELERATION DIAGRAM
// ════════════════════════════════════════════════════════════════════════════
pair accpole = (500, 600);
dot("$o$", accpole, W);

// a^n_{A2/O2} : parallel to O2→A, magnitude = omega2² × |O2A|
pair  unitO2A = unit(pointA - pointO2);
real  accA2O2n_mag  = (omega2^2) * length(pointA - pointO2);
real  accscale = accA2O2n_mag / 200;
pair  pt_accA2O2n   = accpole + (accA2O2n_mag/accscale) * unitO2A;

draw(pt_accA2O2n--accpole, blue+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{a}^n_{A_2/O_2}$", get_midpoint(pt_accA2O2n, accpole),      SW);
dot("$a$", pt_accA2O2n, SW);
write("a^n_{A2/O2} =", accA2O2n_mag);

// a^n_{A4/O4} : parallel to O4→A, magnitude = omega4² × |O4A|
real  accA4O4n_mag = (omega4^2) * length(pointA - pointO4);
pair  unitO4A      = unit(pointA - pointO4);
pair  pt_accA4O4n  = accpole + (accA4O4n_mag/accscale) * unitO4A;
draw(pt_accA4O4n--accpole, orange+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{a}^n_{A_4/O_4}$", get_midpoint(pt_accA4O4n, accpole), SE);
write("a^n_{A4/O4} =", accA4O4n_mag);

dot("$b$", pt_accA4O4n, NE);


// a^c_{A2/A4} (Coriolis) : ⊥ to O4A, magnitude = 2·omega4·|v_{A2/A4}|
real accCor_mag  = 2 * omega4 * velA2A4_mag;
pair unitPerpO4A = unit(rotate(-90)*(pointA - pointO4));
pair pt_accCor   = pt_accA2O2n + (accCor_mag/accscale) * unitPerpO4A;
draw(pt_accA2O2n--pt_accCor, red+2pt, Arrow(8));
label("$\overset{\checkmark \checkmark}{a}^c_{A_2 A_4}$", get_midpoint(pt_accCor, pt_accA2O2n), NE);
write("a^c_{A2 A4} =", accCor_mag);

dot("$c$", pt_accCor, SE);

// a^t_{A4/O4} : ⊥ to O4A from pt_accA4O4n — direction known, magnitude unknown
path lineAt_A4O4 = pt_accA4O4n + 2000*unitPerpO4A -- pt_accA4O4n - 2000*unitPerpO4A;

// a^t_{A2/A4} (relative sliding) : parallel to O4A from pt_accCor — magnitude unknown
path lineAr_A2A4 = pt_accCor + 2000*unitO4A -- pt_accCor - 2000*unitO4A;

// Draw dashed construction lines
draw(pt_accA4O4n + 0*unitPerpO4A -- pt_accA4O4n + 400*unitPerpO4A, blue+dashed+1pt);
label("$\overset{?\checkmark}{a}^t_{A_4/O_4}$", pt_accA4O4n + 400*unitPerpO4A, SW);

draw(pt_accCor + 125*unitO4A -- pt_accCor - 125*unitO4A, blue+dashed+1pt);
label("$\overset{?\checkmark}{a}^t_{A_2/A_4}$", (pt_accCor - 125*unitO4A), SW);

// Intersection → acceleration of A4/O4 (total)
pair[] accInters = intersectionpoints(lineAt_A4O4, lineAr_A2A4);
if (accInters.length > 0) {
  pair pt_accA4O4 = accInters[0];
  dot("$d$", pt_accA4O4, NE);
  draw(pt_accA4O4n--pt_accA4O4, orange+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}^t_{A_4/O_4}$", get_midpoint(pt_accA4O4, pt_accA4O4n), NE);
  draw(pt_accA4O4--pt_accCor, blue+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}^t_{A_2/A_4}$", get_midpoint(pt_accA4O4, pt_accCor), SE);
  real accA4O4t_mag = length(pt_accA4O4n - pt_accA4O4) * accscale;
  real alpha4       = accA4O4t_mag / length(pointA - pointO4);
  write("a^t_{A4/O4} =", accA4O4t_mag);
  write("alpha4 =", alpha4);

  draw(accpole--pt_accA4O4, orange+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}_{A_4/O_4}$", get_midpoint(accpole, pt_accA4O4)+(0, -5), SW);
  write("a_{A4/O4} =", length(accpole - pt_accA4O4) * accscale);

}

