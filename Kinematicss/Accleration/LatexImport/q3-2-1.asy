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
pair sliderDir   = unit(pointA - pointO4);
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
write("omega4 =", omega4);

// ════════════════════════════════════════════════════════════════════════════
//  ACCELERATION DIAGRAM
// ════════════════════════════════════════════════════════════════════════════
pair accpole = (500, 600);
dot("$o$", accpole, W);

// Shared unit vectors (used throughout acceleration section)
pair unitO4A     = unit(pointA - pointO4);           // O4 → A  (slider / relative acc direction)
pair unitPerpO4A = unit(rotate(-90)*(pointA - pointO4));  // ⊥ to O4A

// ── a^n_{A2/O2}: centripetal A→O2, drawn UP from pole ────────────────────────
//    direction = unit(O2 - A)  ← points from A toward O2
pair  unitCentripO2 = unit(pointO2 - pointA);
real  accA2O2n_mag  = (omega2^2) * length(pointA - pointO2);
real  accscale      = accA2O2n_mag / 200;
pair  pt_accA2O2n   = accpole + (accA2O2n_mag/accscale) * unitCentripO2;

draw(accpole--pt_accA2O2n, blue+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{a}^n_{A_2/O_2}$",
      get_midpoint(accpole, pt_accA2O2n), W);
dot("$a$", pt_accA2O2n, NW);
write("a^n_{A2/O2} =", accA2O2n_mag);

// ── a^n_{A4/O4}: centripetal A→O4, drawn DOWN from pole ──────────────────────
//    direction = unit(O4 - A)  ← points from A toward O4
pair  unitCentripO4 = unit(pointO4 - pointA);
real  accA4O4n_mag  = (omega4^2) * length(pointA - pointO4);
pair  pt_accA4O4n   = accpole + (accA4O4n_mag/accscale) * unitCentripO4;

draw(accpole--pt_accA4O4n, orange+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{a}^n_{A_4/O_4}$",
      get_midpoint(accpole, pt_accA4O4n), E);
dot("$b$", pt_accA4O4n, SE);
write("a^n_{A4/O4} =", accA4O4n_mag);

// ── a^c_{A2/A4} (Coriolis): ⊥ to O4A, chained from point a ──────────────────
//    magnitude = 2·omega4·|v_{A2/A4}|
real accCor_mag = 2 * omega4 * velA2A4_mag;
pair pt_accCor  = pt_accA2O2n + (accCor_mag/accscale) * unitPerpO4A;

draw(pt_accA2O2n--pt_accCor, red+2pt, Arrow(8));
label("$\overset{\checkmark\checkmark}{a}^c_{A_2 A_4}$",
      get_midpoint(pt_accA2O2n, pt_accCor), NE);
dot("$c$", pt_accCor, SE);
write("a^c_{A2 A4} =", accCor_mag);

// ── construction lines from b and c ──────────────────────────────────────────
// From b: ⊥ to O4A  →  a^t_{A4/O4} (direction known, magnitude unknown)
path lineAt_A4O4 = pt_accA4O4n + 2000*unitPerpO4A -- pt_accA4O4n - 2000*unitPerpO4A;

// From c: ∥ to O4A  →  a^r_{A2/A4} (direction known, magnitude unknown)
path lineAr_A2A4 = pt_accCor + 2000*unitO4A -- pt_accCor - 2000*unitO4A;

// Dashed construction arrows
draw(pt_accA4O4n -- pt_accA4O4n + 400*unitPerpO4A, orange+dashed+1pt, Arrow(8));
label("$\overset{?\checkmark}{a}^t_{A_4/O_4}$",
      pt_accA4O4n + 400*unitPerpO4A, SW);

draw(pt_accCor + 125*unitO4A -- pt_accCor - 125*unitO4A, blue+dashed+1pt);
label("$\overset{?\checkmark}{a}^r_{A_2/A_4}$",
      pt_accCor - 125*unitO4A, SW);

// ── intersection → point d ───────────────────────────────────────────────────
pair[] accInters = intersectionpoints(lineAt_A4O4, lineAr_A2A4);
if (accInters.length > 0) {
  pair pt_accD = accInters[0];
  dot("$d$", pt_accD, NE);

  // a^t_{A4/O4}: from b to d
  draw(pt_accA4O4n--pt_accD, orange+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}^t_{A_4/O_4}$",
        get_midpoint(pt_accA4O4n, pt_accD), NE);

  // a^r_{A2/A4}: from c to d
  draw(pt_accCor--pt_accD, blue+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}^r_{A_2/A_4}$",
        get_midpoint(pt_accCor, pt_accD), SE);

  real accA4O4t_mag = length(pt_accD - pt_accA4O4n) * accscale;
  real alpha4       = accA4O4t_mag / length(pointA - pointO4);
  write("a^t_{A4/O4} =", accA4O4t_mag);
  write("alpha4 =", alpha4);

  // Total a_{A4/O4}: from pole o to d
  draw(accpole--pt_accD, orange+2pt, Arrow(8));
  label("$\overset{\checkmark\checkmark}{a}_{A_4/O_4}$",
        get_midpoint(accpole, pt_accD)+(0,-5), SW);
  real totalA4O4 = length(accpole - pt_accD) * accscale;
  write("a_{A4/O4} =", totalA4O4);
  
  // ═══════════════════════════════════════════════════════════════════════════
  //  EXPORT VALUES TO TEX FILE
  // ═══════════════════════════════════════════════════════════════════════════
  file out = output("q3-2-1-values.tex");
  write(out, "\newcommand{\BX}{" + format("%.10f", pointB.x) + "}");
  write(out, "\newcommand{\BY}{" + format("%.10f", pointB.y) + "}");
  write(out, "\newcommand{\omegaTwo}{" + format("%.14f", omega2) + "}");
  write(out, "\newcommand{\velAtwOtwo}{" + format("%.14f", velA2O2_mag) + "}");
  write(out, "\newcommand{\velAfourOfour}{" + format("%.14f", velA4O4_mag) + "}");
  write(out, "\newcommand{\velAtwoAfour}{" + format("%.14f", velA2A4_mag) + "}");
  write(out, "\newcommand{\omegaFour}{" + format("%.14f", omega4) + "}");
  write(out, "\newcommand{\accnAtwOtwo}{" + format("%.14f", accA2O2n_mag) + "}");
  write(out, "\newcommand{\accnAfourOfour}{" + format("%.14f", accA4O4n_mag) + "}");
  write(out, "\newcommand{\acccAtwoAfour}{" + format("%.14f", accCor_mag) + "}");
  write(out, "\newcommand{\acctAfourOfour}{" + format("%.14f", accA4O4t_mag) + "}");
  write(out, "\newcommand{\alphaFour}{" + format("%.14f", alpha4) + "}");
  write(out, "\newcommand{\accAfourOfour}{" + format("%.14f", totalA4O4) + "}");
  close(out);
}

