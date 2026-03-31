import graph;

unitsize(0.055cm);

real ystroke = 50;
real radius  = ystroke/2;   // = 25

// Cumulative angle positions (degrees → x units)
real xA = 0;
real xS = 90;    // end of outstroke  (0° → 90°)
real xR = 120;   // end of outer dwell (90° → 120°, i.e. 30° dwell)
real xP = 180;   // end of return stroke (120° → 180°, i.e. 60° return)
real xX = 360;   // end of base dwell  (180° → 360°, i.e. 180° dwell)

int n = 6;

// ── bounding rectangle + axes ────────────────────────────────
draw((xA,0)--(xX,0)--(xX,ystroke)--(xA,ystroke)--cycle, dashed+gray);
draw((xA,0)--(xX+5,0), black, Arrows(3));
draw((xA,0)--(xA,ystroke+5), black, Arrows(3));

label("$A$",       (xA,0),       SW, fontsize(9));
label("$\theta$",  (xX+5,0),     E,  fontsize(9));
label("$y$",       (xA,ystroke+5), N, fontsize(9));

// segment boundary lines
draw((xS,0)--(xS,ystroke), gray+0.8pt);
draw((xR,0)--(xR,ystroke), gray+0.8pt);
draw((xP,0)--(xP,ystroke), gray+0.8pt);

label("$S$", (xS,0), S, fontsize(9));
label("$R$", (xR,0), S, fontsize(9));
label("$P$", (xP,0), S, fontsize(9));

// ── SEMICIRCLE  (center (0, radius), opens left) ─────────────
// i=0 → angle 270° → bottom (y=0); i=n → angle 90° → top (y=50)
real cx = 0;
real cy = radius;   // = 25

draw(arc((cx,cy), radius, 90, 270), gray+1pt);

pair[] semiPts;
for(int i = 0; i <= n; ++i) {
    real ang = 270 - i*(180/n);
    semiPts.push((cx + radius*Cos(ang),
                  cy + radius*Sin(ang)));
}

string[] semiLabels = {"$a$","$b$","$c$","$d$","$e$"};
for(int i = 1; i < n; ++i) {
    draw((cx,cy)--semiPts[i], dotted+gray(0.5));
    dot(semiPts[i], red+linewidth(3));

    // horizontal dashed projection to right boundary
    draw(semiPts[i]--(xX, semiPts[i].y), dashed+gray(0.5));

    // label on semicircle
    label(semiLabels[i-1], semiPts[i]+(-4,0), fontsize(8));

    // corresponding y-axis tick + primed label
    dot((xA, semiPts[i].y), gray+linewidth(2));
    label(semiLabels[i-1]+"$'$", (xA, semiPts[i].y), W, fontsize(8));
}
dot((cx,cy), black+linewidth(2));
dot(semiPts[0], black+linewidth(4));   // (0, 0)
dot(semiPts[n], black+linewidth(4));   // (0, 50)

// ── OUTSTROKE  (x: 0 → 90,  y: 0 → 50) ─────────────────────
pair[] outPts;
for(int i = 0; i <= n; ++i) {
    real xd = xA + i*(xS-xA)/n;
    real yd = semiPts[i].y;
    outPts.push((xd,yd));
    if(i > 0 && i < n) {
        draw((xd,0)--(xd,yd), dotted+gray(0.5));
        dot((xd,yd), blue+linewidth(3));
        label(string(i), (xd,0), S, fontsize(7));
    }
}
dot(outPts[0], black+linewidth(4));
dot(outPts[n], black+linewidth(4));

string[] outLabels = {"$B$","$C$","$D$","$E$","$F$"};
for(int i = 1; i < n; ++i)
    label(outLabels[i-1], outPts[i], NW, fontsize(8));
label("$G$", outPts[n], NW, fontsize(8));

// ── RETURN STROKE  (x: 120 → 180,  y: 50 → 0) ───────────────
pair[] retPts;
for(int i = 0; i <= n; ++i) {
    real xd = xR + i*(xP-xR)/n;
    real yd = ystroke - semiPts[i].y;
    retPts.push((xd,yd));
    if(i > 0 && i < n) {
        draw((xd,0)--(xd,yd), dotted+gray(0.5));
        dot((xd,yd), blue+linewidth(3));
        label("$"+string(i)+"'$", (xd,0), S, fontsize(7));
    }
}
dot(retPts[0], black+linewidth(4));
label("$H$", retPts[0], NW, fontsize(8));
dot(retPts[n], black+linewidth(4));

string[] retLabels = {"$J$","$K$","$L$","$M$","$N$"};
for(int i = 1; i < n; ++i)
    label(retLabels[i-1], retPts[i]+(2,2), fontsize(8));

// ── DISPLACEMENT CURVE ────────────────────────────────────────
guide gOut;
for(int i = 0; i <= n; ++i) gOut = gOut..outPts[i];
draw(gOut, red+2pt);

draw((xS,ystroke)--(xR,ystroke), red+2pt);   // outer dwell

guide gRet;
for(int i = 0; i <= n; ++i) gRet = gRet..retPts[i];
draw(gRet, red+2pt);

draw((xP,0)--(xX,0), red+2pt);               // base dwell

// ── SEGMENT ARROWS ────────────────────────────────────────────
real braceY = -10;

for(real xpos : new real[]{xA, xS, xR, xP, xX})
    draw((xpos,0)--(xpos,braceY), dashed+gray);

draw((xA,braceY+2.5)--(xS,braceY+2.5), red+0.7pt,      Arrows(4));
draw((xS,braceY+2.5)--(xR,braceY+2.5), deepgreen+0.7pt, Arrows(4));
draw((xR,braceY+2.5)--(xP,braceY+2.5), orange+0.7pt,    Arrows(4));
draw((xP,braceY+2.5)--(xX,braceY+2.5), purple+0.7pt,    Arrows(4));

label("$90^\circ$ (Outstroke)", ((xA+xS)/2, braceY-2), red+fontsize(8));
label("$30^\circ$ (Dwell)",     ((xS+xR)/2, braceY-2), deepgreen+fontsize(7));
label("$60^\circ$ (Return)",    ((xR+xP)/2, braceY-2), orange+fontsize(8));
label("$180^\circ$ (Dwell)",    ((xP+xX)/2, braceY-2), purple+fontsize(8));

// ── AXIS LABELS ───────────────────────────────────────────────
label(rotate(90)*"Displacement (mm)", (-30, ystroke/2), fontsize(9));
label("Angular displacement of cam (degrees)", (xX/2, braceY-9), fontsize(9));

draw((xX+8,0)--(xX+8,ystroke), black+0.7pt, Arrows(4));
label("$50$ mm",  (xX+22, ystroke/2+3), fontsize(8));
label("(Stroke)", (xX+22, ystroke/2-3), fontsize(8));

label("{\bf Displacement Diagram (Simple Harmonic Motion Follower)}",
      (xX/2, ystroke+9), fontsize(9));
