// ============================================================
//  Involute Spur-Gear Construction  (Shigley's  Ch. 13)
//  N2 = 20,  N3 = 40,  Pd = 10 teeth/in,  phi = 20 deg
// ============================================================
import graph;
unitsize(2.8cm);

// ── Parameters ───────────────────────────────────────────────
real phi = 20 * pi / 180;            // pressure angle  (rad)
int  N2  = 20,  N3  = 50;            // tooth counts
real Pd  = 10.0;                      // diametral pitch (teeth/in)

// ── Derived geometry ─────────────────────────────────────────
real R2   = N2  / (2.0*Pd);           // pitch radii
real R3   = N3  / (2.0*Pd);
real rb2  = R2  * cos(phi);           // base-circle radii
real rb3  = R3  * cos(phi);
real a    = 1.0  / Pd;                // addendum
real ded  = 1.25 / Pd;                // dedendum
real Ra2  = R2 + a;    real Ra3 = R3 + a;
real Rd2  = R2 - ded;  real Rd3 = R3 - ded;
real inv_phi = tan(phi) - phi;        // involute function at phi

// ── Gear centres (pitch circles tangent at origin) ───────────
pair O2 = (-R2, 0);                   // pinion
pair O3 = ( R3, 0);                   // gear

// =============================================================
//  Involute helpers
//
//  invR  –  as t increases from 0 the point spirals outward
//           with INCREASING angle  (CCW).
//  invL  –  as t increases from 0 the point spirals outward
//           with DECREASING angle  (CW).
//
//  For a tooth centred at angle th:
//      CW  flank (smaller angle side) → use invR
//      CCW flank (larger  angle side) → use invL
//  This makes the tooth THIN at the tip, THICK at the root.
// =============================================================
pair invR(pair O, real rb, real a0, real t) {
    return O + rb * ( cos(a0+t) + t*sin(a0+t),
                      sin(a0+t) - t*cos(a0+t) );
}
pair invL(pair O, real rb, real a0, real t) {
    return O + rb * ( cos(a0-t) - t*sin(a0-t),
                      sin(a0-t) + t*cos(a0-t) );
}

path pathR(pair O, real rb, real a0, real t0, real t1, int n=80) {
    guide g;
    for (int i = 0; i <= n; ++i) {
        real t = t0 + (t1 - t0) * i / n;
        g = g -- invR(O, rb, a0, t);
    }
    return (path)g;
}
path pathL(pair O, real rb, real a0, real t0, real t1, int n=80) {
    guide g;
    for (int i = 0; i <= n; ++i) {
        real t = t0 + (t1 - t0) * i / n;
        g = g -- invL(O, rb, a0, t);
    }
    return (path)g;
}

// =============================================================
//  drawGear  –  traces every tooth CCW around the gear
//
//  For each tooth k centred at  th = rot + k·2π/N :
//
//   base angles :  aCW  = th − ha − inv(φ)    (for invR)
//                  aCCW = th + ha + inv(φ)    (for invL)
//
//   CCW tracing order per tooth:
//      1. CW  flank  root → tip   pathR(aCW,  0→ta)
//      2. top land   (short CCW arc on addendum circle)
//      3. CCW flank  tip  → root  pathL(aCCW, ta→0)
//      4. bottom land (CCW arc on dedendum to next tooth)
// =============================================================
void drawGear(pair O, real rb, real Ra, real Rd,
              real ta, int N, real rot, pen p)
{
    real ha = pi / (2.0 * N);          // half angular pitch

    for (int k = 0; k < N; ++k) {

        real th     = rot + k     * 2pi / N;
        real thNext = rot + (k+1) * 2pi / N;

        // ── involute base angles ──
        real aCW     = th     - ha - inv_phi;   // CW  flank this tooth
        real aCCW    = th     + ha + inv_phi;   // CCW flank this tooth
        real aCWnext = thNext - ha - inv_phi;   // CW  flank next tooth

        // ── tip points ──
        pair tipCW  = invR(O, rb, aCW,  ta);
        pair tipCCW = invL(O, rb, aCCW, ta);
        real angTipCW  = degrees(atan2(tipCW.y  - O.y, tipCW.x  - O.x));
        real angTipCCW = degrees(atan2(tipCCW.y - O.y, tipCCW.x - O.x));

        // top land  – short CCW arc  (angTipCCW > angTipCW)
        if (angTipCCW < angTipCW) angTipCCW += 360;

        if (Rd >= rb) {
            // dedendum outside base circle
            real td = sqrt((Rd/rb)^2 - 1.0);

            pair rootCCW = invL(O, rb, aCCW,    td);
            pair rootCWn = invR(O, rb, aCWnext, td);
            real angRCCW = degrees(atan2(rootCCW.y - O.y, rootCCW.x - O.x));
            real angRCWn = degrees(atan2(rootCWn.y - O.y, rootCWn.x - O.x));
            if (angRCWn < angRCCW) angRCWn += 360;

            draw(pathR(O,rb,aCW,  td,ta),          p);  // 1 CW flank
            draw(arc(O, Ra, angTipCW, angTipCCW),   p);  // 2 top land
            draw(pathL(O,rb,aCCW, ta,td),           p);  // 3 CCW flank
            draw(arc(O, Rd, angRCCW,  angRCWn),     p);  // 4 bottom land

        } else {
            // dedendum inside base circle  → radial stubs
            pair baseCW   = invR(O, rb, aCW,     0);
            pair baseCCW  = invL(O, rb, aCCW,    0);
            pair baseCWn  = invR(O, rb, aCWnext, 0);

            pair rootCW   = O + Rd * unit(baseCW   - O);
            pair rootCCW  = O + Rd * unit(baseCCW  - O);
            pair rootCWn  = O + Rd * unit(baseCWn  - O);

            real angRCCW = degrees(atan2(rootCCW.y - O.y, rootCCW.x - O.x));
            real angRCWn = degrees(atan2(rootCWn.y - O.y, rootCWn.x - O.x));
            if (angRCWn < angRCCW) angRCWn += 360;

            draw(rootCW  -- baseCW,                  p);  // 1a stub
            draw(pathR(O,rb,aCW,  0, ta),            p);  // 1b CW involute
            draw(arc(O, Ra, angTipCW, angTipCCW),    p);  // 2  top land
            draw(pathL(O,rb,aCCW, ta, 0),            p);  // 3a CCW involute
            draw(baseCCW -- rootCCW,                 p);  // 3b stub
            draw(arc(O, Rd, angRCCW, angRCWn),       p);  // 4  bottom land
        }
    }
}

// ── Roll angle at addendum ───────────────────────────────────
real ta2 = sqrt((Ra2/rb2)^2 - 1.0);
real ta3 = sqrt((Ra3/rb3)^2 - 1.0);

// ── Meshing offsets ──────────────────────────────────────────
//  rot2 = 0        →  pinion tooth centred at 0° (toward P)
//  rot3 = π/N3     →  puts a gear SPACE centred at 180° (toward P)
real rot2 = 0;
real rot3 = pi / N3;

// ── Draw teeth ───────────────────────────────────────────────
drawGear(O2, rb2, Ra2, Rd2, ta2, N2, rot2, black+0.7bp);
drawGear(O3, rb3, Ra3, Rd3, ta3, N3, rot3, black+0.7bp);

// ── Reference circles ────────────────────────────────────────
pen pitchPen = blue      + 1.0bp  + linetype("6 3");
pen basePen  = darkgreen + 0.85bp + linetype("3 3");
pen addPen   = red       + 0.75bp + linetype("1.5 3");
pen dedPen   = purple    + 0.75bp + linetype("2 3");

draw(circle(O2, R2),  pitchPen);   draw(circle(O3, R3),  pitchPen);
draw(circle(O2, rb2), basePen);    draw(circle(O3, rb3), basePen);
draw(circle(O2, Ra2), addPen);     draw(circle(O3, Ra3), addPen);
draw(circle(O2, Rd2), dedPen);     draw(circle(O3, Rd3), dedPen);

// ── Construction lines ───────────────────────────────────────
// Centre line
draw(O2+(-0.30,0) -- O3+(0.30,0), gray(0.55)+0.8bp+dashdotted);
// Common tangent (vertical through P)
draw((0,-1.20) -- (0,1.20), black+0.8bp+dashed);

// Line of action  (tangent to both base circles)
pair loa = (sin(phi), cos(phi));          // unit direction
real tA  = -R2*sin(phi);
real tB  =  R3*sin(phi);
real tC  =  R3*sin(phi) - sqrt(Ra3^2 - rb3^2);
real tD  =  sqrt(Ra2^2 - rb2^2) - R2*sin(phi);
pair A = tA*loa;   pair B = tB*loa;
pair C = tC*loa;   pair D = tD*loa;
pair P = (0,0);

draw((tC-0.45)*loa -- (tB+0.40)*loa,  orange+1.5bp);
draw(O2 -- A,  gray(0.5)+dashed+0.65bp);
draw(O3 -- B,  gray(0.5)+dashed+0.65bp);
draw(C  -- D,  heavyred+1bp);

// Pressure-angle arc
draw(arc(P, 1, -(degrees(phi)-90), 90.0), black+0.9bp, Arrows(3));
label("$\phi$", 1*(sin(phi/2)-0.25, 1*cos(phi/2)),
      fontsize(9)+black);


// radius dimension arrows
pair p2 = O2 + R2 * dir(100);
draw(O2--p2, black+0.7bp, Arrow(4));
label("$R_2$", (O2+p2)/2, NE, fontsize(8));

pair p3 = O3 + R3 * dir(120);
draw(O3--p3, black+0.7bp, Arrow(4));
label("$R_3$", (O3+p3)/2, NE, fontsize(8));

// Annotation labels
label("{\footnotesize Line of action}",
      (tB+0.30)*loa + (0.05,0), E, fontsize(8)+orange);
label(rotate(90)*"{\footnotesize Common tangent}",
      (-0.1, 1.7), E, fontsize(7)+gray(0.4));



// ══════════════════════════════════════════════════════════════
//  Key-point dots  &  arrow labels  (drawn last = on top)
// ══════════════════════════════════════════════════════════════
dot(P,  black+4bp);
dot(O2, black+4bp);
dot(O3, black+4bp);
dot(A,  black+3bp);
dot(B,  black+3bp);
dot(C,  black+3bp);
dot(D,  black+3bp);

void arrowlabel(string s, pair txt, pair pt, pen col) {
    label(s, txt, col+fontsize(9));
    draw(txt -- pt, col+0.7bp, Arrow(5));
}

arrowlabel("$P$", P+(-0.50, 0.32), P, red);
label("$O_2$", O2,SW, black);
label("$O_3$", O3,SE, black);
arrowlabel("$A$", A  +( 0.5,-0.36),  A +(0,0),    darkgreen);
arrowlabel("$B$", B  +(0.5, -0.36),  B +(0,0),   darkgreen);
arrowlabel("$C$", C  +(-0.88,-0.20),  C +(0,0),   orange);
arrowlabel("$D$", D + (0.5, -0.36), D + (0,0), orange);


