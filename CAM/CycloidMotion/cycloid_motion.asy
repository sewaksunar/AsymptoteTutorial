import graph;
unitsize(0.14cm);

real Stk = 40;
real r   = Stk/(2*pi);
int  ni  = 6;
real n   = 6.0;

real xA = 0, xB = 90;
real Sd = Stk;
real dx = xB/n;
real slope = Sd/xB;

// ---- Bounding rectangle (outstroke only) ----
//draw((xA,0)--(xB,0)--(xB,Sd)--(xA,Sd)--cycle, grey+1pt);
// x axis
draw((xA,0)--(xB+5,0), black+1pt, Arrow(5));
label("$\theta \longrightarrow$", ((xA+xB)/2, -4), fontsize(8));

draw((xB+5,Sd)--(xA,Sd), dashed+grey);


// ---- Corner labels ----
label("$A$", (xA,0),  SW, fontsize(10));
label("$B$", (xB,Sd), NE, fontsize(10));

// ---- Y-axis arrow ----
draw((xA,-r-3)--(xA,Sd+5), black+1pt, Arrow(5));
label(rotate(90)*"$y \longrightarrow$", (xA-4, Sd/2), fontsize(8));

// ---- theta_O arrow ----
draw((xA,-r-3)--(xB,-r-3), black+0.8pt, Arrows(4));
draw((xB,0)--(xB,-r-3), dashed+gray);
label("$\theta_O$", ((xA+xB)/2, -r-5), fontsize(9));

// ---- stroke arrow ----
draw((xB+5,0)--(xB+5,Sd), black+0.8pt, Arrows(4));
//draw((xB,-r-5)--(xB,-r+5), dashed+gray);
label(rotate(90)*"$S$", (xA+xB+3, Sd/2), fontsize(8));


// ---- AB diagonal ----
draw((xA,0)--(xB,Sd), dashed+grey);

// ---- Division verticals 1' to 5' ----
for(int i=1; i<=ni; ++i){
    draw((i*dx,0)--(i*dx,Sd), dashed+grey+0.7pt);
    label("$"+string(i)+"'$", (i*dx,0), S, fontsize(8));
}

// ====================================================
// CIRCLE centered at A=(0,0)
// ====================================================
pair ctr = (0,0);
draw(circle(ctr, r), grey+1.2pt);
draw((0,-r)--(0,r),  black+0.6pt);
draw((-r,0)--(r,0),  gray+dashed+0.4pt);

pair[] cp;
for(int i=0; i<ni; ++i){
    real ang = i*60;
    cp.push((r*Cos(ang), r*Sin(ang)));
}

for(int i=0; i<ni; ++i){
    draw(ctr--cp[i], dashed+gray(0.5)+0.5pt);
    dot(cp[i], black+linewidth(2.5));
}

label("$6$", cp[0], NE,  fontsize(7));
label("$5$", cp[1], NE, fontsize(7));
label("$4$", cp[2], NW, fontsize(7));
label("$3$", cp[3], W,  fontsize(7));
label("$2$", cp[4], SW, fontsize(7));
label("$1$", cp[5], SE, fontsize(7));

// ====================================================
// a' and b' projections on vertical centre line
// ====================================================
real ya = -r*Sin(60);
real yb =  r*Sin(60);

draw(cp[4]--(0,ya), grey+dashed+0.5pt);
draw(cp[5]--(0,ya), grey+dashed+0.5pt);
draw(cp[1]--(0,yb), grey+dashed+0.5pt);
draw(cp[2]--(0,yb), grey+dashed+0.5pt);

dot((0,ya), black+linewidth(3));
dot((0,yb), black+linewidth(3));
label("$a'$", (0,ya), NW, fontsize(9));
label("$b'$", (0,yb), SW, fontsize(9));

// ====================================================
// PARALLEL LINES TO AB through a' and b'
// ====================================================
// Through a': from b' at x=0 to vertical 2'
draw((0, ya)--(2*dx, ya + slope*2*dx), dashed+gray);

// Through b': from b' at x=0 all the way to vertical 5'
draw((0, yb)--(5*dx, yb + slope*5*dx), dashed+gray);

// ====================================================
// CYCLOIDAL CURVE POINTS
// ====================================================
pair[] curvePts;
for(int i=0; i<=ni; ++i){
    real xi = i*dx;
    real yi = Sd*(i/n) - r*Sin(360.0*i/n);
    curvePts.push((xi,yi));
}

dot(curvePts[0],  black+linewidth(5));
dot(curvePts[ni], black+linewidth(5));

string[] ptlbls  = {"$a$","$b$","$c$","$d$","$e$"};
pair[]   ptalign = {NW,    SE,    SE,    NW,   SE  };
for(int i=1; i<ni; ++i){
    dot(curvePts[i], black+linewidth(4));
    label(ptlbls[i-1], curvePts[i], ptalign[i-1], fontsize(9)+black);
}

guide gc;
for(int i=0; i<=ni; ++i) gc = gc..curvePts[i];
draw(gc, red+2pt);

// ====================================================
// TITLE
// ====================================================
//label("{\bf Cycloidal Displacement (Outstroke only)}",
 //     (xB/2, Sd+8), fontsize(9));