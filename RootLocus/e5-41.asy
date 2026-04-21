// Root Locus: G(s)H(s) = k(s^2 - 2s + 5) / (s^2 + 1.5s - 1)
// Poles:  s = 0.5,  s = -2      (denominator roots)
// Zeros:  s = 1+2j, s = 1-2j   (numerator roots)
// n = m = 2  →  no asymptotes; all branches terminate at finite zeros
// Real-axis locus: segment between the two poles [-2, 0.5]
// Breakaway point: solve d/ds[(s^2+1.5s-1)/(s^2-2s+5)] = 0
//   → 7s^2 - 24s - 11 = 0  →  s ≈ -0.41  (the root between -2 and 0.5)

import graph;
size(600, 600);

real xmin = -3.5, xmax = 2.8;
real ymin = -3.2, ymax = 3.2;

// ── Grid ──────────────────────────────────────────────────────────────
for (int i = (int)xmin; i <= (int)xmax; ++i)
    draw((i, ymin)--(i, ymax), gray(0.87)+linewidth(0.25));
for (int j = (int)ymin; j <= (int)ymax; ++j)
    draw((xmin, j)--(xmax, j), gray(0.87)+linewidth(0.25));

// ── Axes ──────────────────────────────────────────────────────────────
draw((xmin,0)--(xmax,0), black, Arrow(TeXHead));
draw((0,ymin)--(0,ymax), black, Arrow(TeXHead));
label("$\sigma$",   (xmax-0.05, -0.28),  fontsize(11pt));
label("$j\omega$",  (0.28,  ymax-0.12),  fontsize(11pt));

// Tick marks and numeric labels
for (int i = (int)xmin; i <= (int)xmax; ++i) {
    if (i == 0) continue;
    draw((i,-0.09)--(i,0.09));
    label("$"+string(i)+"$", (i,-0.32), fontsize(7.5pt));
}
for (int j = (int)ymin; j <= (int)ymax; ++j) {
    if (j == 0) continue;
    draw((-0.09,j)--(0.09,j));
    label("$"+string(j)+"j$", (-0.42,j), fontsize(7.5pt));
}
label("$0$", (-0.25,-0.28), fontsize(7.5pt));

// ── Root locus branches ───────────────────────────────────────────────
// Branch A: pole 0.5 → real-axis → breakaway(-0.41) → zero 1+2j
// Branch B: pole -2  → real-axis → breakaway(-0.41) → zero 1-2j
pen locusPen = royalblue + linewidth(2.2);
pair bk = (-0.41, 0);   // breakaway point

path branchA = (0.5,0)--bk
               ..controls (-0.18, 0.75) and (0.55, 1.72)..(1.0, 2.0);
path branchB = (-2.0,0)--bk
               ..controls (-0.18,-0.75) and (0.55,-1.72)..(1.0,-2.0);

draw(branchA, locusPen, MidArrow(TeXHead));
draw(branchB, locusPen, MidArrow(TeXHead));

// ── Breakaway point marker ────────────────────────────────────────────
dot(bk, royalblue+linewidth(5));
label("$s\!\approx\!-0.41$", bk+(0.0,-0.32), royalblue+fontsize(7.5pt));

// ── Poles  (×  symbol) ────────────────────────────────────────────────
pen polePen = red+linewidth(2.5);
real d = 0.13;   // half-size of × arms

void drawPole(real x, real y) {
    draw((x-d,y-d)--(x+d,y+d), polePen);
    draw((x-d,y+d)--(x+d,y-d), polePen);
}
drawPole(0.5,  0);
drawPole(-2.0, 0);

label("Pole: $s=0.5$",  (0.5,  0.38), red+fontsize(8.5pt));
label("Pole: $s=-2$",   (-2.0, 0.38), red+fontsize(8.5pt));

// ── Zeros  (○  symbol) ────────────────────────────────────────────────
pen zeroPen = deepgreen+linewidth(2.5);

draw(circle((1.0, 2.0), 0.13), zeroPen);
draw(circle((1.0,-2.0), 0.13), zeroPen);

label("Zero: $s=1+2j$", (1.0, 2.38),  deepgreen+fontsize(8.5pt));
label("Zero: $s=1-2j$", (1.0,-2.38),  deepgreen+fontsize(8.5pt));

// ── Legend ────────────────────────────────────────────────────────────
pair lo = (-3.3, -2.6);
draw(lo--(lo+(0.55,0)), locusPen);
label("Root locus ($k\ge 0$)", lo+(0.65,0), W+fontsize(8pt), align=E);

draw(lo+(0.0,-0.38)--(lo+(0.14,-0.52)), polePen);
draw(lo+(0.0,-0.52)--(lo+(0.14,-0.38)), polePen);
label("Pole",  lo+(0.65,-0.45), W+fontsize(8pt), align=E);

draw(circle(lo+(0.07,-0.78), 0.09), zeroPen);
label("Zero",  lo+(0.65,-0.78), W+fontsize(8pt), align=E);

// ── Title ─────────────────────────────────────────────────────────────
label("Root Locus $\displaystyle G(s)H(s)=\frac{k(s^2-2s+5)}{s^2+1.5s-1}$",
      (0.0, -3.0), fontsize(10pt));