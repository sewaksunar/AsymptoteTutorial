import graph;

unitsize(0.055cm);

real ystroke = 40;
real radius  = ystroke/2;   // = 20

real xA = 0;
real xS = 90;
real xR = 120;
real xP = 180;
real xX = 360;

int n = 6;

// Bounding rectangle
draw((xA,0)--(xX,0)--(xX,ystroke)--(xA,ystroke)--cycle, dashed+gray);
// x and y axes
draw((xA,0)--(xX+5,0), black, Arrows(3));
draw((xA,0)--(xA,ystroke+5), black, Arrows(3));

// Corner labels
label("$A$", (xA,0),       SW, fontsize(9));
label("$\theta$", (xX,0),       SE, fontsize(9));
label("$y$", (xA,ystroke), NW, fontsize(9));

// Segment boundary lines
draw((xS,0)--(xS,ystroke), gray+0.8pt);
draw((xR,0)--(xR,ystroke), gray+0.8pt);
draw((xP,0)--(xP,ystroke), gray+0.8pt);

label("$S$", (xS,0), S, fontsize(9));
label("$R$", (xR,0), S, fontsize(9));
label("$P$", (xP,0), S, fontsize(9));

// ====================================================
// SEMICIRCLE  (opens LEFT, center at (0,20))
// Arc drawn CCW from 90 to 270 (left-opening half)
// Points go CW: angle = 270 - i*180/n
//   i=0 -> angle=270 -> (0, 0)   = bottom  (y=0,  displacement 0)
//   i=n -> angle= 90 -> (0,40)   = top     (y=40, full stroke)
// ====================================================
real cx = 0;
real cy = radius;   // = 20

draw(arc((cx,cy), radius, 90, 270), gray);

pair[] semiPts;
for(int i = 0; i <= n; ++i) {
    real ang = 270 - i*(180/n);            // CW from bottom to top
    real px  = cx + radius*Cos(ang);
    real py  = cy + radius*Sin(ang);
    semiPts.push((px, py));
}

// Radial lines, dots, horizontal dashed projections, letters on semicircle
for(int i = 1; i < n; ++i) {
    draw((cx,cy)--semiPts[i], dotted+gray(0.5));
    dot(semiPts[i], red+linewidth(3));
    // horizontal dashed line from each semicircle point to right boundary
    draw((semiPts[i].x, semiPts[i].y)--(xX, semiPts[i].y), dashed+gray(0.6));
    string lbl;
    if     (i==1) lbl="$a$";
    else if(i==2) lbl="$b$";
    else if(i==3) lbl="$c$";
    else if(i==4) lbl="$d$";
    else          lbl="$e$";
    // label the letter both on the semicircle and at the left end of the line
    label(lbl, semiPts[i]+(-4,0), fontsize(8));
    // mark corresponding y-axis point and label it with prime
    dot((xA, semiPts[i].y), gray);
    label(lbl + "$'$" , (xA, semiPts[i].y), W, fontsize(8));
}
dot((cx,cy), black+linewidth(2));
dot(semiPts[0], black+linewidth(4));   // bottom = (0,0)
dot(semiPts[n], black+linewidth(4));   // top    = (0,40)

// ====================================================
// OUTSTROKE  (x: xA -> xS,  y: 0 -> 40)
// ====================================================
pair[] outPts;
for(int i = 0; i <= n; ++i) {
    real xd = xA + i*(xS-xA)/n;
    real yd = semiPts[i].y;             // now correctly 0 -> 40
    outPts.push((xd,yd));
    if(i > 0 && i < n) {
        // ensure a–a', b–b', c–c' are clearly marked with thicker dashed lines
        if(i <= 3) draw((xd,0)--(xd,yd), dashed+gray+1pt);
        else        draw((xd,0)--(xd,yd), dotted+gray(0.5)); // others remain dotted
        dot((xd,yd), blue+linewidth(3));
        label(string(i), (xd,0), S, fontsize(7));
    }
}
dot(outPts[0], black+linewidth(4));
dot(outPts[n], black+linewidth(4));

// labels for the intermediate outstroke points (i=1..n-1)
string[] outLabels = {"$B$","$C$","$D$","$E$","$F$"};
for(int i = 1; i < n; ++i)
    label(outLabels[i-1], outPts[i], NW, fontsize(8)+black);
// label the last outstroke point (at xS) as G
label("$G$", outPts[n], NW, fontsize(8)+black);

// ====================================================
// RETURN STROKE  (x: xR -> xP,  y: 40 -> 0)
// ====================================================
pair[] retPts;
for(int i = 0; i <= n; ++i) {
    real xd = xR + i*(xP-xR)/n;
    real yd = ystroke - semiPts[i].y;   // 40 -> 0
    retPts.push((xd,yd));
    if(i > 0 && i < n) {
        draw((xd,0)--(xd,yd), dotted+gray(0.5));
        dot((xd,yd), blue+linewidth(3));
        label("$"+string(i)+"'$", (xd,0), S, fontsize(7));
    }
}
dot(retPts[0], black+linewidth(4));
// mark start of return stroke as H
label("$H$", retPts[0], NW, fontsize(8)+black);
dot(retPts[n], black+linewidth(4));

// 5 inner labels for n=6 return points
string[] retLabels = {"$J$","$K$","$L$","$M$","$N$"};
for(int i = 1; i < n; ++i)
    label(retLabels[i-1], retPts[i]+(-3,-4), fontsize(8)+black);

// ====================================================
// DISPLACEMENT CURVE
// ====================================================
guide gOut;
for(int i = 0; i <= n; ++i) gOut = gOut..outPts[i];
draw(gOut, red+2pt);

draw((xS,ystroke)--(xR,ystroke), red+2pt);   // outer dwell

guide gRet;
for(int i = 0; i <= n; ++i) gRet = gRet..retPts[i];
draw(gRet, red+2pt);

draw((xP,0)--(xX,0), red+2pt);               // base dwell

// ====================================================
// SEGMENT ARROWS
// ====================================================
real braceY = -10;
real tickH  = -10;

for(real xpos : new real[]{xA, xS, xR, xP, xX})
    draw((xpos,0)--(xpos, tickH), dashed+gray);

draw((xA,braceY+2.5)--(xS,braceY+2.5), red+0.7pt,       Arrows(4));
draw((xS,braceY+2.5)--(xR,braceY+2.5), deepgreen+0.7pt,  Arrows(4));
draw((xR,braceY+2.5)--(xP,braceY+2.5), orange+0.7pt,     Arrows(4));
draw((xP,braceY+2.5)--(xX,braceY+2.5), purple+0.7pt,     Arrows(4));

label("$90^\circ$ (Outstroke)",  ((xA+xS)/2, braceY-2), red+fontsize(8));
label("$30^\circ$ (Dwell)",      ((xS+xR)/2, braceY-2), deepgreen+fontsize(7));
label("$60^\circ$ (Return)",     ((xR+xP)/2, braceY-2), orange+fontsize(8));
label("$180^\circ$ (Dwell)",     ((xP+xX)/2, braceY-2), purple+fontsize(8));

// ====================================================
// AXIS LABELS + TITLE
// ====================================================
label(rotate(90)*"Displacement (mm)", (-30, ystroke/2), fontsize(9));
label("Angular displacement of cam (degrees)", (xX/2, braceY-9), fontsize(9));

draw((xX+8,0)--(xX+8,ystroke), black+0.7pt, Arrows(4));
label("$40$ mm",  (xX+22, ystroke/2+3), fontsize(8));
label("(Stroke)", (xX+22, ystroke/2-3), fontsize(8));

// label("{\bf Fig. 20.13 : Displacement Diagram (Simple Harmonic Motion Follower)}",
//       (xX/2, ystroke+9), fontsize(9));
