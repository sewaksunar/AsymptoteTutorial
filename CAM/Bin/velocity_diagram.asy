// ============================================================
//  COMPLETE VELOCITY DIAGRAM - Slotted-Link Mechanism
//  Shows polygon, equations, and relationships clearly
// ============================================================
unitsize(2.5cm);
defaultpen(fontsize(9pt));

// Mechanism geometry (from space.asy)
real r1 = 2.8;
real theta1 = 55;
real pi = 3.14159265;

// Crank velocity
real omega1 = 1.0;
real v_B_O1 = omega1 * r1;
real angle_O1B = 90 - theta1;

// ========== LEFT: Main Velocity Polygon ==========
pair O = (-3.5, 1.5);

// Grid
for(int i = -3; i <= 3; ++i) {
    draw((O.x + i, O.y - 3) -- (O.x + i, O.y + 2.5), gray(0.95)+0.25pt);
    draw((O.x - 3, O.y + i) -- (O.x + 3, O.y + i), gray(0.95)+0.25pt);
}

// Axes
draw((O.x - 3, O.y) -- (O.x + 3, O.y), black+0.7pt);
draw((O.x, O.y - 3) -- (O.x, O.y + 2.5), black+0.7pt);

// Origin point
fill(circle(O, 0.12), black);
label("O", O + (-0.20, -0.20), fontsize(9pt));

// --- Vector 1: v_{B/O_1} (red)
pair v1 = O + v_B_O1 * dir(angle_O1B + 90);
draw(O -- v1, red+2.8pt, Arrow(HookHead, 7));
dot(v1, red+3pt);
pair label1_pos = v1 + 0.25*unit(v1 - O);
label("$v_{B/O_1}$", label1_pos, NE, red+fontsize(10pt));

// --- Vector 2: v_{C/O_2} (blue, perpendicular to link)
// Approximate angle for O2D link (from mechanism)
real angle_O2D_approx = atan2(8.5, 3.2) * 180 / pi;
real angle_perp_O2D = angle_O2D_approx + 90;
pair v2 = v1 + 1.8 * dir(angle_perp_O2D);
draw(v1 -- v2, blue+2.8pt, Arrow(HookHead, 7));
dot(v2, blue+3pt);
pair label2_pos = v1 + 0.9*unit(v2 - v1);
label("$v_{C/O_2}$", label2_pos + (0.25, 0.15), NE, blue+fontsize(10pt));

// --- Vector 3: v_{slip} (green, along link)
pair v3 = v2 + (-0.95) * dir(angle_O2D_approx);
draw(v2 -- v3, heavygreen+2.8pt, Arrow(HookHead, 7));
dot(v3, heavygreen+3pt);
pair label3_pos = v2 + 0.5*unit(v3 - v2);
label("$v_{slip}$", label3_pos + (-0.30, -0.25), S, heavygreen+fontsize(10pt));

// --- Vector 4: v_D (black, horizontal)
pair v4 = v3 + (-1.15, 0);
draw(v3 -- v4, black+2.8pt, Arrow(HookHead, 7));
dot(v4, black+3pt);
label("$v_D$", v3 + (-0.6, -0.25), S, black+fontsize(10pt));

// Closure check (dashed)
draw(O -- v4, dashed+gray(0.5)+1pt);
label("closure", (O + v4)/2 + (0.15, 0.15), gray(0.4)+fontsize(8pt));

// Title for polygon
label("VELOCITY POLYGON", O + (-2.8, 2.8), fontsize(11pt));

// ========== RIGHT: Equations and Info ==========

// Title
label("CONSTRAINT EQUATIONS", (2, 2.5), fontsize(11pt));

// --- Equation section
label("At joint B:", (0.5, 2.0), NW, fontsize(9pt));

label("$\vec{v}_B^{abs} = \vec{v}_{B/O_1}$", (0.6, 1.65), NW, fontsize(9pt)+red);
label("velocity of crank point", (2.0, 1.65), NW, fontsize(8pt)+gray);

label("$\vec{v}_B = \vec{v}_{C/O_2} + \vec{v}_{slip}$", (0.6, 1.25), NW, fontsize(9pt)+blue);
label("B on link O$_2$D (slotted)", (2.1, 1.25), NW, fontsize(8pt)+gray);

// --- Constraint at D
label("At block D:", (0.5, 0.65), NW, fontsize(9pt));

label("$\vec{v}_D = v_D \hat{\mathbf{i}}$", (0.6, 0.30), NW, fontsize(9pt)+black);
label("D slides horizontally", (1.55, 0.30), NW, fontsize(8pt)+gray);

// --- Closure
label("CLOSURE CONDITION:", (0.5, -0.35), NW, fontsize(10pt));
label("$\vec{v}_{B/O_1} + \vec{v}_{C/O_2} + \vec{v}_{slip} + \vec{v}_D = \vec{0}$", (0.6, -0.75), NW, fontsize(9pt)+darkblue);

// ========== BOTTOM LEFT: Vector Relations ==========

label("VECTOR COMPONENTS", (-3.5, -2.0), fontsize(11pt));

real y_comp = -2.5;

label("$v_{B/O_1}$ direction:", (-3.4, y_comp), NW, fontsize(8pt)+red);
label("perpendicular to crank O$_1$B", (-2.5, y_comp), NW, fontsize(7pt)+red);

label("$v_{C/O_2}$ direction:", (-3.4, y_comp - 0.45), NW, fontsize(8pt)+blue);
label("perpendicular to link O$_2$D", (-2.5, y_comp - 0.45), NW, fontsize(7pt)+blue);

label("$v_{slip}$ direction:", (-3.4, y_comp - 0.90), NW, fontsize(8pt)+heavygreen);
label("along slot direction (O$_2$D)", (-2.5, y_comp - 0.90), NW, fontsize(7pt)+heavygreen);

label("$v_D$ direction:", (-3.4, y_comp - 1.35), NW, fontsize(8pt)+black);
label("horizontal (sliding constraint)", (-2.5, y_comp - 1.35), NW, fontsize(7pt)+black);

// ========== BOTTOM RIGHT: Legend ==========

label("LEGEND", (1.8, -2.0), fontsize(11pt));

real y_leg = -2.5;

draw((0.6, y_leg) -- (1.0, y_leg), red+2.5pt, Arrow(HookHead, 6));
label("relative to O$_1$", (1.2, y_leg), W, fontsize(8pt)+red);

draw((0.6, y_leg - 0.45) -- (1.0, y_leg - 0.45), blue+2.5pt, Arrow(HookHead, 6));
label("relative to O$_2$", (1.2, y_leg - 0.45), W, fontsize(8pt)+blue);

draw((0.6, y_leg - 0.90) -- (1.0, y_leg - 0.90), heavygreen+2.5pt, Arrow(HookHead, 6));
label("sliding velocity", (1.2, y_leg - 0.90), W, fontsize(8pt)+heavygreen);

draw((0.6, y_leg - 1.35) -- (1.0, y_leg - 1.35), black+2.5pt, Arrow(HookHead, 6));
label("absolute velocity", (1.2, y_leg - 1.35), W, fontsize(8pt)+black);
