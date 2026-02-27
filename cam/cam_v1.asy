import graph;
size(18cm, 8cm, IgnoreAspect);

real xscale = 1;
real ystroke = 40;            // chosen graph height for constant velocity segments

real xA = 0;
real xS = 60;
real xT = 90;
real xP = 150;
real xX = 360;

pair A = (xA, 0);
pair G = (xS, ystroke);
pair H = (xT, 0);
pair P = (xP, -ystroke);
pair X = (xX, 0);

// Bounding rectangle
draw((xA,0)--(xX,0)--(xX,ystroke)--(xA,ystroke)--cycle, dashed+gray);

// enablesmooth(true);  % not recognized in some Asymptote versions
// Axes and labels
label("$A$", A, SW, fontsize(9));
draw((xA,0)--(xA,ystroke+2), Arrow(4));
label("$y$", (xA, ystroke+2), NW, fontsize(9));

draw((xA,0)--(xA+xX+20, 0), Arrow(4));
label("$\theta$", X+(10, 0), SE, fontsize(9));

// Velocity curve segments
// outstroke constant positive
draw((xA, ystroke)--(xS, ystroke), red+2pt);
// dwell
draw((xS, 0)--(xT, 0), red+2pt);
// return constant negative
draw((xT, -ystroke)--(xP, -ystroke), red+2pt);
// dwell
draw((xP, 0)--(xX, 0), red+2pt);

// Key points
dot(A, black+linewidth(4));
dot(G, black+linewidth(4));
dot(H, black+linewidth(4));
dot(P, black+linewidth(4));
dot(X, black+linewidth(4));

label("$G$", G, N, fontsize(9));
label("$H$", H, N, fontsize(9));
label("$P$", P, S, fontsize(9));

// Vertical division lines: Outstroke
int n = 6;
string[] right_label = {"$B$","$C$","$D$","$E$", "$F$", "$G$"};
for(int i = 1; i < n; ++i) {
    real xd = xA + i*(xS - xA)/n;
    real yd = ystroke;                // all these lie on the constant segment
    draw((xd, 0)--(xd, yd), dashed+gray(0.5));
    dot((xd, yd), black+linewidth(3));
    label(right_label[i-1], (xd, yd), W, fontsize(9));
    label(string(i), (xd, 0), S, fontsize(7));
}

string[] left_label = {"$I$","$J$","$K$","$L$", "$M$", "$N$"};
// Vertical division lines: Return stroke
for(int i = 1; i < n; ++i) {
    real xd = xT + i*(xP - xT)/n;
    real yd = -ystroke;              // constant negative velocity
    draw((xd, 0)--(xd, yd), dashed+gray(0.5));
    dot((xd, yd), black+linewidth(3));
    label(left_label[i-1], (xd, yd), E, fontsize(9));
    label("$"+string(i)+"'$", (xd, 0), S, fontsize(7));
}

// Horizontal dashed grid lines
for(int i = -1; i <= 1; ++i) {
    real yd = i*ystroke;
    draw((xA, yd)--(xP, yd), dashed+gray(0.7));
    if(i != 0) label(string(round(yd)), (xA, yd), W, fontsize(7));
}

// Vertical marker lines at key angular positions
real markers[] = {xS, xT, xP};
for(int j = 0; j < markers.length; ++j) {
    real xx = markers[j];
    draw((xx, -ystroke)--(xx, ystroke), dashed+gray+0.7pt);
}

// Angular labels on x-axis
label("$S$", (xS, 0), SE, fontsize(9));
label("$T$", (xT, 0), SW, fontsize(9));

// Brace annotations below x-axis (same as displacement)
real braceY = -7;
real tickH  = -5;

real ticks[] = {xA, xS, xT, xP, xX};
for(int j = 0; j < ticks.length; ++j) {
    real xpos = ticks[j];
    draw((xpos, 0)--(xpos, tickH), dashed+gray);
}

// Segment arrows
draw((xA,braceY+2.5)--(xS,braceY+2.5), red+0.7pt, Arrows(4));
draw((xS,braceY+2.5)--(xT,braceY+2.5), deepgreen+0.7pt, Arrows(4));
draw((xT,braceY+2.5)--(xP,braceY+2.5), orange+0.7pt, Arrows(4));
draw((xP,braceY+2.5)--(xX,braceY+2.5), purple+0.7pt, Arrows(4));

// Segment labels
label("$60^\circ$ (Outstroke)",  ((xA+xS)/2,  braceY), fontsize(8)+red);
label("$30^\circ (Dwell)$",              ((xS+xT)/2,  braceY), fontsize(8)+deepgreen);
label("$60^\circ$ (Return)",     ((xT+xP)/2,  braceY), fontsize(8)+orange);
label("$210^\circ$ (Dwell)",     ((xP+xX)/2,  braceY), fontsize(8)+purple);

// Y-axis label
label(rotate(90)*"Velocity (mm/deg)", (-18, 0), fontsize(9));

// X-axis label
label("Angular displacement of cam (degrees)", (xX/2, braceY-5), fontsize(9));

// Stroke arrow on right side just for consistency
 draw((xX+8, -ystroke)--(xX+8, ystroke), black+0.7pt, Arrows(4));
 label(rotate(90)*"Scale arbitrary", (xX+15, 0), fontsize(8));

// Title
//label("{\bf Velocity Diagram (Uniform Velocity Follower)}",
//      (xX/2, ystroke+8), fontsize(9);
