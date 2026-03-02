// ============================================================
//  Complete Velocity Vector Diagram
//  For Slotted-Link Mechanism
// ============================================================
unitsize(2.2cm);
defaultpen(fontsize(11pt));

// Vector magnitudes (from mechanism analysis)
pair v1 = 2.0 * dir(120);    // v_{B/O1} - perpendicular to crank
pair v2 = 1.5 * dir(60);     // v_{C/O2} - perpendicular to link
pair v3 = -1.2 * dir(30);    // v_{slip} - along slot
pair v4 = (-1.8, 0);         // v_D - horizontal

// ========== PART 1: Vector Diagram ==========
pair O = (0, 0);

// Draw origin point
fill(circle(O, 0.08), black);
draw(circle(O, 0.08), black+0.5pt);
label("$O$", O, SW, fontsize(10pt));

// Draw vectors with different colors
draw(O -- O + v1, red+2pt, Arrow(HookHead, 8));
label("$v_{B/O_1}$", O + 0.5*v1 + (0.25, 0.15), red+fontsize(10pt), Fill(white));

draw(O + v1 -- O + v1 + v2, blue+2pt, Arrow(HookHead, 8));
label("$v_{C/O_2}$", O + v1 + 0.5*v2 + (-0.30, 0.20), blue+fontsize(10pt), Fill(white));

draw(O + v1 + v2 -- O + v1 + v2 + v3, heavygreen+2pt, Arrow(HookHead, 8));
label("$v_{slip}$", O + v1 + v2 + 0.5*v3 + (-0.35, -0.15), heavygreen+fontsize(10pt), Fill(white));

draw(O + v1 + v2 + v3 -- O + v1 + v2 + v3 + v4, black+2pt, Arrow(HookHead, 8));
label("$v_D$", O + v1 + v2 + v3 + 0.5*v4 + (-0.20, -0.30), black+fontsize(10pt), Fill(white));

// Closure vector (dotted)
draw(O -- O + v1 + v2 + v3 + v4, dashed+gray+1pt);

// Grid for reference
for(int i = -2; i <= 2; ++i) {
    draw((i, -2.5) -- (i, 2.5), gray(0.85)+0.3pt);
    draw((-2.5, i) -- (2.5, i), gray(0.85)+0.3pt);
}

// Axes
draw((-2.5, 0) -- (2.5, 0), black+0.6pt);
draw((0, -2.5) -- (0, 2.5), black+0.6pt);

// Title
label("{\Large Velocity Polygon}", (0, 2.9), fontsize(12pt));

// ========== PART 2: Velocity Constraint Equations ==========
picture eqns;
currentpicture = eqns;

label("{\bf Constraints:}", (0, 0), NW, fontsize(11pt));
label("$\vec{v}_B = \vec{v}_{B/O_1}$", (-0.05, -0.40), NW, fontsize(10pt));
label("(B on crank)", (0.7, -0.40), NW, fontsize(9pt)+gray);

label("$\vec{v}_{B} = \vec{v}_{C/O_2} + \vec{v}_{slip}$", (-0.05, -0.85), NW, fontsize(10pt));
label("(B on slotted link)", (0.9, -0.85), NW, fontsize(9pt)+gray);

label("$\vec{v}_D = \vec{v}_{slip}$ component along link", (-0.05, -1.30), NW, fontsize(10pt));
label("(D horizontal constraint)", (1.1, -1.30), NW, fontsize(9pt)+gray);

label("{\bf Closure:}", (0, -1.80), NW, fontsize(11pt));
label("$\vec{v}_{B/O_1} + \vec{v}_{C/O_2} + \vec{v}_{slip} + \vec{v}_D = \vec{0}$", (-0.05, -2.25), NW, fontsize(10pt)+blue);

currentpicture = currentpicture;
add(shift(-4.5, -4)*eqns);

// ========== PART 3: Legend ==========
picture legend;
currentpicture = legend;

fill(box((0,0), (0.3, 0.25)), white);
draw((0.05, 0.125) -- (0.25, 0.125), red+2pt, Arrow(HookHead, 6));
label("velocity rel. to O$_1$", (0.4, 0.125), W, red+fontsize(9pt));

fill(box((0, -0.35), (0.3, -0.10)), white);
draw((0.05, -0.225) -- (0.25, -0.225), blue+2pt, Arrow(HookHead, 6));
label("velocity rel. to O$_2$", (0.4, -0.225), W, blue+fontsize(9pt));

fill(box((0, -0.70), (0.3, -0.45)), white);
draw((0.05, -0.575) -- (0.25, -0.575), heavygreen+2pt, Arrow(HookHead, 6));
label("slip velocity", (0.4, -0.575), W, heavygreen+fontsize(9pt));

fill(box((0, -1.05), (0.3, -0.80)), white);
draw((0.05, -0.925) -- (0.25, -0.925), black+2pt, Arrow(HookHead, 6));
label("velocity of D", (0.4, -0.925), W, black+fontsize(9pt));

currentpicture = currentpicture;
add(shift(2.8, -4)*legend);
