// ============================================================
//  Slotted-Link Mechanism: Crank O1B + Oscillating link O2D
//  - Block D slides horizontally
//  - Block B slides along link O2D
// ============================================================
unitsize(1.5cm);
defaultpen(fontsize(10pt));

// ---------- Key geometry ----------
pair O2 = (0, 0);
pair O1 = (0, 3.5);
real r1 = 2.8;                       // crank radius O1B
real theta1 = 55;                    // crank angle from vertical
pair B  = O1 + r1 * dir(90 - theta1);

// D lies on a horizontal rail; O2D passes through B
// find D as intersection of line O2-B extended with horizontal y = yD
real yD = 9.0;
pair u_O2B = unit(B - O2);
real t = (yD - O2.y) / u_O2B.y;
pair D = O2 + t * u_O2B;

// unit vectors along and perpendicular to links
pair u_O2D    = unit(D - O2);
pair perp_O2D = rotate(90) * u_O2D;
pair u_O1B    = unit(B - O1);
pair perp_O1B = rotate(90) * u_O1B;

// ---------- Drawing helpers ----------

// Fixed pivot with ground hatching (below)
void fixedPivot(pair P, real ang=0) {
    real r = 0.18, w = 0.42;
    fill(circle(P, r), white);
    draw(circle(P, r), black+1pt);
    fill(circle(P, 0.06), black);
    pair d = dir(ang);
    pair n = rotate(-90)*d;
    pair base = P - r*d;
    draw(base - w*n -- base + w*n, black+1.2pt);
    for (int i = -3; i <= 3; ++i) {
        pair s = base + i*w/3*n;
        draw(s -- s - 0.22*d - 0.10*n, black+0.6pt);
    }
}

// Rectangular block aligned to direction
void block(pair cen, pair dir, real len=0.5, real wid=0.28, pen fill=cyan+opacity(0.3), pen stroke=blue+1pt) {
    pair u = unit(dir);
    pair v = rotate(90)*u;
    path b = (cen - len*u - wid*v) -- (cen + len*u - wid*v)
          -- (cen + len*u + wid*v) -- (cen - len*u + wid*v) -- cycle;
    filldraw(b, fill, stroke);
}

// Horizontal slider rail with hatching on top
void horizRail(pair cen, real hw=1.2) {
    real h = 0.12;
    // two horizontal lines (channel)
    draw((cen.x - hw, cen.y - h) -- (cen.x + hw, cen.y - h), black+1.2pt);
    draw((cen.x - hw, cen.y + h) -- (cen.x + hw, cen.y + h), black+1.2pt);
    // ground hatch above
    for (int i = 0; i <= 8; ++i) {
        real x = cen.x - hw + i * 2*hw/8;
        draw((x, cen.y + h) -- (x + 0.15, cen.y + h + 0.22), black+0.6pt);
    }
    // end caps
    draw((cen.x - hw, cen.y - h) -- (cen.x - hw, cen.y + h), black+1pt);
    draw((cen.x + hw, cen.y - h) -- (cen.x + hw, cen.y + h), black+1pt);
}

// Velocity arrow
void vel(pair tail, pair head, string lbl, pair loff=(0,0), pen p=black) {
    draw(tail -- head, p+1.2pt, Arrow(HookHead, 6));
    label(lbl, head + loff, p+fontsize(9pt));
}

// ---------- Draw mechanism ----------

// Centre-line (vertical dashed)
draw((0, -0.8) -- (0, 10.2), dashed+magenta+0.7pt);
label(rotate(90)*"{\scriptsize centre-line}", (-0.25, 5), magenta);

// Link O2-D (slotted oscillating link)
// Draw as thick bar with slot indication
draw(O2 -- D, blue+2.2pt);
// slot outline along O2D through B
real slotHalf = 0.55;
pair slotA = B - slotHalf * u_O2D;
pair slotB_pt = B + slotHalf * u_O2D;
pair off = 0.12 * perp_O2D;
draw(slotA + off -- slotB_pt + off, gray(0.3)+0.8pt);
draw(slotA - off -- slotB_pt - off, gray(0.3)+0.8pt);

// Crank O1-B
draw(O1 -- B, red+2pt);

// Horizontal rail at y = yD for block D
horizRail(D, 1.4);

// Block D (slides horizontally)
block(D, (1,0), 0.38, 0.22, lightblue+opacity(0.4), blue+1pt);

// Block B (slides along O2D)
block(B, u_O2D, 0.36, 0.20, lightgreen+opacity(0.4), heavygreen+1pt);

// Fixed pivots with proper ground orientation
fixedPivot(O2, -90);   // ground below
fixedPivot(O1, -90);   // ground below

// ---------- Velocity vectors ----------
real v = 1.3;

vel(B, B + v*perp_O1B,      "$v_{B/O_1}$",    (0.10, 0.15), red);
vel(B, B + v*perp_O2D,      "$v_{C/O_2}$",    (-0.55, 0.05), blue);
vel(B, B - 0.8*v*u_O2D,     "$v_{slip}$",     (-0.10, -0.35), heavygreen);
vel(D, D + (-v, 0),         "$v_D$",          (-0.40, 0.18), black);

// ---------- Labels ----------
label("$O_2$", O2, SW, fontsize(10pt));
label("$O_1$", O1, W, fontsize(10pt));
label("$D$",   D + (0.50, -0.05), fontsize(10pt));
label("$B$",   B + (0.45, 0.30), fontsize(9pt));
label("{\scriptsize slider on $O_2D$}", B + (0.45, 0.05), fontsize(8pt));

// Angle annotation for crank
draw(arc(O1, 0.6, 90, 90-theta1), black+0.7pt, Arrow(4));
label("$\theta_1$", O1 + 0.85*dir(90 - theta1/2), fontsize(9pt));

// Length annotations
pair midO1B = (O1 + B)/2;
label("$r_1$", midO1B + 0.22*perp_O1B, fontsize(8pt)+red);
