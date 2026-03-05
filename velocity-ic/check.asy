// ================================================================
//  Mechanism Drawing – 7-Link Chain with Slider
//  Compile with:  asy -f pdf mechanism.asy
// ================================================================
settings.outformat = "pdf";
unitsize(2.5cm);
defaultpen(fontsize(10pt) + linewidth(0));

import geometry;

// ----------------------------------------------------------------
// Helper: draw hatched ground along horizontal segment a→b
// ----------------------------------------------------------------
void groundHatch(pair a, pair b, real tick=0.18, real gap=0.21) {
    draw(a--b, linewidth(1.3));
    int n = round(abs(b.x - a.x) / gap);
    for (int i = 0; i <= n; ++i) {
        pair base = (a.x + i*(b.x-a.x)/n, a.y);
        draw(base -- (base + (-tick, -tick)), linewidth(0.65) + gray(0.45));
    }
}

// Helper: draw vertical hatched wall (fixed bracket)
void wallHatch(pair a, pair b) {
    draw(a--b, linewidth(1.3));
    real H = abs(b.y - a.y);
    int n = round(H / 0.21);
    for (int i = 0; i <= n; ++i) {
        pair base = (a.x, a.y + i*H/n);
        draw(base -- (base + (0.18, 0.18)), linewidth(0.65) + gray(0.45));
    }
}

// ----------------------------------------------------------------
// Helper: draw zig-zag spring from a to b
// ----------------------------------------------------------------
void spring(pair a, pair b, int coils=8, real amp=0.11) {
    pair d   = unit(b - a);
    pair perp = (-d.y, d.x);
    real L    = length(b - a);
    real ends = 0.10;
    // lead lines
    draw(a -- a + ends*L*d, linewidth(0.9));
    draw(b - ends*L*d -- b,  linewidth(0.9));
    real body = L*(1 - 2*ends);
    real step = body / coils;
    for (int i = 0; i < coils; ++i) {
        pair p0 = a + (ends*L + i      *step)*d;
        pair p1 = a + (ends*L + (i+0.5)*step)*d + amp*(i%2==0 ? 1:-1)*perp;
        pair p2 = a + (ends*L + (i+1)  *step)*d;
        draw(p0 -- p1 -- p2, linewidth(0.9));
    }
}

// ----------------------------------------------------------------
// Helper: draw a link as a "rod" (rounded-end bar)
// ----------------------------------------------------------------
void rod(pair a, pair b, real w=0.055) {
    pair d    = unit(b - a);
    pair perp = (-d.y, d.x) * w;
    path outline = (a + perp) -- (b + perp) -- (b - perp) -- (a - perp) -- cycle;
    filldraw(outline, rgb(0.88,0.88,0.88), linewidth(1.4));
}

// ----------------------------------------------------------------
// Helper: filled revolute joint circle
// ----------------------------------------------------------------
void rjoint(pair c, real r=0.075) {
    filldraw(circle(c, r), white, linewidth(1.4));
}

// ----------------------------------------------------------------
// Helper: ground-pin symbol (triangle + hatch line + circle)
// ----------------------------------------------------------------
void gpin(pair c) {
    real h=0.20, w=0.22;
    pair L = c + (-w/2, -h);
    pair R = c + ( w/2, -h);
    filldraw(c -- L -- R -- cycle, gray(0.55), linewidth(0.9));
    draw((L + (-0.08,-0.03)) -- (R + (0.08,-0.03)), linewidth(1.3));
    rjoint(c);
}

// ----------------------------------------------------------------
// Ground-level y-coordinates  (stepped ground)
// ----------------------------------------------------------------
real yG1 = 0.00;   // upper-left platform
real yG2 = -1.70;  // middle platform
real yG3 = -3.55;  // lower platform (slider track)

// ----------------------------------------------------------------
// Kinematic joint positions (tuned to match the figure layout)
// ----------------------------------------------------------------
pair J1  = (0.55,  yG1);          // Fixed pivot – link 2 on upper ground
pair J23 = (-0.55, 2.45);         // Link 2 / Link 3 joint
pair JPIN= (4.25,  3.55);         // Fixed PIN  – pivot for link 4 (on bracket)
pair J34 = (3.55,  2.30);         // Link 3 / Link 4 joint (near PIN arm)
pair J45 = (3.05,  0.75);         // Link 4 / Link 5 joint (lower hook end)
pair J56 = (5.10,  yG2 + 0.05);   // Link 5 / Link 6 joint
pair J67 = (6.50,  yG3 + 0.28);   // Link 6 / Slider (link 7) joint

// Slider (link 7) dimensions and centre
real sw=0.90, sh=0.40;
pair SLC = (J67.x, yG3 + sh/2);

// Spring attachment: ground anchor and point on link 2
pair SpGnd = (0.12,  yG1);
pair SpLnk = (0.10,  1.05);      // lies approximately on link 2

// Fixed-bracket anchor on the upper-right wall
pair BkBase = (5.00, yG1);       // foot of bracket (on upper ground)

// ================================================================
//  1.  DRAW GROUND / PLATFORMS
// ================================================================
groundHatch((-1.60, yG1), (2.20, yG1));          // upper platform
draw((2.20, yG1) -- (2.20, yG2), linewidth(1.3)); // step-down wall
groundHatch((2.20, yG2), (5.10, yG2));            // middle platform
draw((5.10, yG2) -- (5.10, yG3), linewidth(1.3)); // step-down wall
groundHatch((5.10, yG3), (8.10, yG3));            // lower platform

// ================================================================
//  2.  FIXED BRACKET FOR PIN  (right-side vertical wall)
// ================================================================
// Bracket post: goes up from the upper ground level to the PIN
pair BkTop = (BkBase.x, JPIN.y + 0.25);
wallHatch(BkBase, BkTop);
// Horizontal arm from post to PIN
draw((BkBase.x, JPIN.y) -- JPIN, linewidth(1.4));
// Mark bracket attachment to ground
draw((BkBase + (-0.20, 0)) -- (BkBase + (0.20, 0)), linewidth(2.0) + gray(0.3));

// ================================================================
//  3.  DRAW LINKS (back-to-front order)
// ================================================================

// ---- Link 3  (J23 → J34) ----
rod(J23, J34);

// ---- Link 2  (J1 → J23) ----
rod(J1, J23);

// ---- Link 4  (curved J-hook, pivots at JPIN) ----
// Build the hook as a swept path: JPIN → (straight arm) → J34 pivot arm,
// and JPIN → (curved hook) → J45 output arm.
// First arm: from JPIN to J34
rod(JPIN, J34);

// Curved hook arm from JPIN down to J45
// Control points chosen to reproduce the "J" shape in the figure
pair hCtrl1 = JPIN + (0.60, -0.80);
pair hCtrl2 = J45  + (0.60,  0.80);
path hookCurve = JPIN .. controls hCtrl1 and hCtrl2 .. J45;

// Draw it as a thick curved rod (offset curves for width)
real hw = 0.055;
path hookL = shift(-hw * (0,1)) * hookCurve;   // rough offset – fine for diagram
path hookR = shift( hw * (0,1)) * hookCurve;
filldraw(hookL -- reverse(hookR) -- cycle, rgb(0.88,0.88,0.88), linewidth(1.4));
draw(hookCurve, linewidth(0)); // centre line (invisible, keeps shape)

// ---- Link 5  (J45 → J56) ----
rod(J45, J56);

// ---- Link 6  (J56 → J67) ----
rod(J56, J67);

// ---- Link 7 = Slider  ----
filldraw(box((SLC.x-sw/2, SLC.y-sh/2), (SLC.x+sw/2, SLC.y+sh/2)),
         rgb(0.78, 0.85, 0.95), linewidth(1.8));

// ================================================================
//  4.  SPRING  (between ground and link 2)
// ================================================================
spring(SpGnd, SpLnk);

// ================================================================
//  5.  JOINTS
// ================================================================
gpin(J1);           // fixed pivot on ground

// Fixed PIN  – outer ring + inner filled circle
filldraw(circle(JPIN, 0.13), white,      linewidth(2.0));
filldraw(circle(JPIN, 0.04), gray(0.35), linewidth(0));

rjoint(J23);
rjoint(J34);
rjoint(J45);
rjoint(J56);
rjoint(J67);

// ================================================================
//  6.  LABELS
// ================================================================
// Link numbers (placed near link mid-point)
label("$\mathbf{1}$",  J1  + (-0.30, -0.30));
label("$\mathbf{2}$",  (J1 + J23)*0.5   + (-0.28,  0.0));
label("$\mathbf{3}$",  (J23 + J34)*0.5  + (-0.10,  0.28));
label("$\mathbf{4}$",  JPIN             + ( 0.35,  0.0));
label("$\mathbf{5}$",  (J45 + J56)*0.5  + ( 0.0,   0.28));
label("$\mathbf{6}$",  (J56 + J67)*0.5  + ( 0.28,  0.0));
label("$\mathbf{7}$",  SLC);

label("\textbf{PIN}",    JPIN + (0.20,  0.28), fontsize(9pt));
label("\textbf{SLIDER}", SLC  + (1.10,  0.0),  fontsize(9pt));
label("\textit{Spring}", (SpGnd + SpLnk)*0.5 + (-0.48, 0.05), fontsize(9pt));

// ================================================================
//  7.  MOBILITY ANALYSIS  (Grübler's Formula)
// ================================================================
//
//  Links (n) : 1-Ground, 2, 3, 4, 5, 6, 7-Slider  → n = 7
//  Full joints (J₁, 1-DOF):
//    ① Ground – Link 2    (revolute at J1)
//    ② Link 2 – Link 3    (revolute at J23)
//    ③ Link 3 – Link 4    (revolute at J34)
//    ④ Link 4 – Ground    (revolute at JPIN, fixed pivot)
//    ⑤ Link 4 – Link 5    (revolute at J45)
//    ⑥ Link 5 – Link 6    (revolute at J56)
//    ⑦ Link 6 – Link 7    (revolute at J67)
//    ⑧ Link 7 – Ground    (prismatic, slider track)
//             → J₁ = 8
//
//  Half joints (J₂, 2-DOF) : none  → J₂ = 0
//
//  Grübler:  M = 3(n−1) − 2 J₁ − J₂
//            M = 3(7−1) − 2(8) − 0
//            M = 18 − 16
//            M = 2
//
//  Note: The spring is a force element (not a kinematic link).
//        If the spring is treated as a binary link (adds 1 link + 2 joints):
//            n=8, J₁=10  →  M = 3(7)−2(10) = 1
//        The spring constrains the mechanism to 1 effective DOF.
// ================================================================

// Print mobility annotation below figure
real yText = yG3 - 0.60;
label("\underline{\textbf{Mobility Analysis (Grübler's Formula)}}",
      (3.0, yText), fontsize(9pt));
label("$n = 7$ links \quad $J_1 = 8$ (full joints) \quad $J_2 = 0$",
      (3.0, yText - 0.42), fontsize(9pt));
label("$M = 3(n-1) - 2J_1 - J_2 = 3(6) - 2(8) - 0 = \mathbf{2}$",
      (3.0, yText - 0.84), fontsize(9pt));
label("(\textit{Spring as binary link: } $n{=}8,\; J_1{=}10 \;\Rightarrow\; M = 1$)",
      (3.0, yText - 1.22), fontsize(8.5pt) + gray(0.3));
