import graph;

// ── Page ─────────────────────────────────────────────────────────────────────
size(21cm, 29.7cm, IgnoreAspect);

// ── Grid extent ───────────────────────────────────────────────────────────────
real xL = 0, xR = 16;
real yB = 0, yT = 24;

// ── Logarithmic x-axis ───────────────────────────────────────────────────────
int  DECADES = 4;

// ── Margins ───────────────────────────────────────────────────────────────────
real TOTAL_MARGIN = 0.40;

// ── Pens ──────────────────────────────────────────────────────────────────────
pen pSub    = gray(0.1) + linewidth(0.1);
pen pMinor  = gray(0.05) + linewidth(0.5);
pen pVMid   = black + linewidth(0.5);
pen pVMajor = black + linewidth(1);
pen pHMid   = black + linewidth(0.5);
pen pHMajor = black + linewidth(1);
pen pBorder = black + linewidth(1);

// ── Coordinate map ───────────────────────────────────────────────────────────
real Xmap(real w) { return xL + log10(w) / DECADES * (xR - xL); }

// ── White background ──────────────────────────────────────────────────────────
fill(box((xL-TOTAL_MARGIN, yB-TOTAL_MARGIN),
         (xR+TOTAL_MARGIN, yT+TOTAL_MARGIN)), white);

// ═══════════════════════════════════════════════════════════════════════════════
//  VERTICAL GRID  (unchanged, logarithmic x)
// ═══════════════════════════════════════════════════════════════════════════════
for (int d = 0; d < DECADES; ++d) {
    for (int k = 1; k <= 9; ++k) {
        real w1  = k      * 10^d;
        real w2  = (k < 9 ? k+1 : 10) * 10^d;
        real lw1 = log(w1), lw2 = log(w2);
        draw((Xmap(exp((2*lw1+lw2)/3)), yB)--(Xmap(exp((2*lw1+lw2)/3)), yT), pSub);
        draw((Xmap(exp((lw1+2*lw2)/3)), yB)--(Xmap(exp((lw1+2*lw2)/3)), yT), pSub);
    }
}
for (int d = 0; d < DECADES; ++d)
    for (int k = 2; k <= 9; ++k)
        if (k != 5)
            draw((Xmap(k*10^d), yB)--(Xmap(k*10^d), yT), pMinor);
for (int d = 0; d < DECADES; ++d)
    draw((Xmap(5*10^d), yB)--(Xmap(5*10^d), yT), pVMid);
for (int d = 0; d <= DECADES; ++d)
    draw((Xmap(10^d), yB)--(Xmap(10^d), yT), pVMajor);

// ═══════════════════════════════════════════════════════════════════════════════
//  HORIZONTAL GRID  — fully data-driven, new logic
// ═══════════════════════════════════════════════════════════════════════════════

// ── 1. Define the level table (finest → coarsest) ────────────────────────────
//       Each entry: { step size,  pen }
//       Order matters: coarsest-step entry wins classification.

struct HGridLevel {
    real step;
    pen  p;
}

HGridLevel[] levels = new HGridLevel[];

HGridLevel L0; L0.step = 0.5;  L0.p = pSub;    levels.push(L0);  // sub
HGridLevel L1; L1.step = 1.0;  L1.p = pMinor;  levels.push(L1);  // minor
HGridLevel L2; L2.step = 5.0;  L2.p = pHMid;   levels.push(L2);  // mid
HGridLevel L3; L3.step = 10.0; L3.p = pHMajor; levels.push(L3);  // major

// ── 2. Enumerate every unique y position at the finest step ──────────────────
real FINEST = levels[0].step;
real EPS    = FINEST * 1e-6;

real[] allY;
for (real y = yB; y <= yT + EPS; y += FINEST)
    allY.push(round(y / FINEST) * FINEST);   // snap to avoid float drift

// ── 3. Classify each y: find the coarsest level whose step divides y ─────────
//       Result: parallel array levelIdx[i] = index into levels[] for allY[i]

int[] levelIdx = new int[allY.length];

for (int i = 0; i < allY.length; ++i) {
    levelIdx[i] = 0;                          // default: finest level
    for (int lv = 1; lv < levels.length; ++lv) {
        real rem = allY[i] - round(allY[i] / levels[lv].step) * levels[lv].step;
        if (abs(rem) < EPS)
            levelIdx[i] = lv;                 // upgrade to coarser level
    }
}

// ── 4. Draw grouped by level, finest first so coarser lines overdraw ─────────
for (int lv = 0; lv < levels.length; ++lv) {
    pen p = levels[lv].p;
    for (int i = 0; i < allY.length; ++i)
        if (levelIdx[i] == lv)
            draw((xL, allY[i])--(xR, allY[i]), p);
}

// ── 5. Boundary guarantee: yB and yT always drawn as major ───────────────────
draw((xL, yB)--(xR, yB), pHMajor);
draw((xL, yT)--(xR, yT), pHMajor);

// ═══════════════════════════════════════════════════════════════════════════════
//  BORDERS
// ═══════════════════════════════════════════════════════════════════════════════
draw(box((xL-TOTAL_MARGIN, yB-TOTAL_MARGIN),
         (xR+TOTAL_MARGIN, yT+TOTAL_MARGIN)), white+linewidth(1.2));
draw(box((xL, yB), (xR, yT)), pBorder);

// // ═══════════════════════════════════════════════════════════════════════════════
// //  LABELS
// // ═══════════════════════════════════════════════════════════════════════════════
// for (int n = 0; n <= DECADES; ++n) {
//     string lbl = (n == 0) ? "$1$" : "$10^{"+string(n)+"}$";
//     label(lbl, (Xmap(10^n), yB-0.05), S, fontsize(9));
// }