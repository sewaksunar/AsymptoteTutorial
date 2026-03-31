import geometry;
import graph;

size(12cm, 12cm);

real R = 50;
real stroke = 40;
int n = 6;

real angOS = 60;
real angST = 30;
real angTP = 60;
real angDwell = 210;

draw(circle((0,0), R), blue+1pt);

dot((0,0)); label("$O$", (0,0), SW);

// --- radial dimension line (CAD style) ---
// choose angle for radius (0° = rightwards) and offset for arrows
real radAngle = 120;
real offDist  = 0;        // small offset so arrows don't overlap origin
pair Rend     = R*dir(radAngle);
// extension for dimension arrows (start a bit away from origin)
pair arrowStart = offDist*dir(radAngle);
pair arrowEnd   = Rend + offDist*dir(radAngle);
// draw only the dimension line with arrows
draw(arrowStart--arrowEnd, black+0.7pt, Arrows(4));
// place label near middle of dimension line
label("$50$", (arrowStart+arrowEnd)/2 + (3,3), fontsize(8));

// --- radial dimension from base circle to outer circle (stroke distance) ---
real radAngle2 = 30;      // different angle to avoid overlap
pair strokeStart = R*dir(radAngle2);
pair strokeEnd   = (R+stroke)*dir(radAngle2);
// draw dimension line with arrows
draw(strokeStart--strokeEnd, black+0.7pt, Arrows(4));
// place label near middle of dimension line
label("$40$", (strokeStart+strokeEnd)/2 + (3,-3), fontsize(8));

real startAngle = 90;
real A_ang = startAngle;
real S_ang = startAngle - angOS;
real T_ang = startAngle - angOS - angST;
real P_ang = startAngle - angOS - angST - angTP;

// Reference dashed lines
draw((0,0)--1.15*(R+stroke)*dir(A_ang), dashed+gray);
draw((0,0)--1.15*(R+stroke)*dir(S_ang), dashed+gray);
draw((0,0)--1.15*(R+stroke)*dir(T_ang), dashed+gray);
draw((0,0)--1.15*(R+stroke)*dir(P_ang), dashed+gray);

// Base circle labels
// label("$A$", R*dir(A_ang), dir(A_ang)*1.2, fontsize(7));
// label("$S$", R*dir(S_ang), dir(S_ang)*1.2, fontsize(7));
// label("$T$", R*dir(T_ang), dir(T_ang)*1.2, fontsize(7));
// label("$P$", R*dir(P_ang), dir(P_ang)*1.2, fontsize(7));
label("$A$", R*dir(A_ang), NW, fontsize(7));
label("$S$", R*dir(S_ang), SE, fontsize(7));
label("$T$", R*dir(T_ang), NE, fontsize(7));
label("$P$", R*dir(P_ang), SE, fontsize(7));

// Sector angle arcs
real arcR = 15;
draw(arc((0,0), arcR, S_ang, A_ang), red);
label("$60^\circ$", arcR*dir((A_ang+S_ang)/2)*0.8, red+fontsize(5));
label("Outstroke", arcR*dir((A_ang+S_ang)/2)*2, red+fontsize(5));

draw(arc((0,0), arcR*0.75, T_ang, S_ang), deepgreen);
label("$30^\circ$", arcR*0.75*dir((S_ang+T_ang)/2)*1.5, deepgreen+fontsize(5));
label("Dwell", arcR*0.75*dir((S_ang+T_ang)/2)*2.5, deepgreen+fontsize(5));

draw(arc((0,0), arcR, P_ang, T_ang), orange);
label("$60^\circ$", arcR*dir((T_ang+P_ang)/2)*0.8, orange+fontsize(5));
label("Retrunstroke", arcR*dir((T_ang+P_ang)/2)*2.0, orange+fontsize(5));

draw(arc((0,0), arcR*1.3, P_ang-angDwell, P_ang), purple);
label("$210^\circ$", arcR*1.3*dir(P_ang - angDwell/2)*1.3, purple+fontsize(5));
label("Dwell", arcR*1.3*dir(P_ang - angDwell/2)*1.3+(0, -4), purple+fontsize(5));

// Letter labels for profile points (B, C, D, ...)
string[] profileLetters = {"B","C","D","E","F"};
// Primed letter labels for return stroke profile points
string[] profileLettersPrime = {"B'","C'","D'","E'","F'"};

// --- Outstroke trace points ---
pair[] outerPoints_out;
for(int i = 0; i <= n; ++i) {
    real ang = A_ang - i*(angOS/n);
    real r   = R + i*(stroke/n);
    pair pos = r*dir(ang);
    outerPoints_out.push(pos);
    draw((0,0)--pos, dotted+gray(0.6));
    dot(pos, red+linewidth(3));
    if(i > 0 && i < n) {
        // Label profile point as B, C, D, ...
        label("$"+profileLetters[i-1]+"$", pos, dir(ang)*1.3, fontsize(7));
        // Label base circle intersection as 1, 2, 3, ...
        pair basePos = R*dir(ang);
        dot(basePos, black+linewidth(2));
        label("$"+string(i)+"$", basePos, dir(ang)*1.35, fontsize(7));
    }
}

// --- Return stroke trace points ---
pair[] outerPoints_ret;
for(int i = 0; i <= n; ++i) {
    real ang = T_ang - i*(angTP/n);
    real r   = (R+stroke) - i*(stroke/n);
    pair pos = r*dir(ang);
    outerPoints_ret.push(pos);
    draw((0,0)--pos, dotted+gray(0.6));
    dot(pos, blue+linewidth(3));
    if(i > 0 && i < n) {
        // Label profile point as B', C', D', ...
        label("$"+profileLettersPrime[i-1]+"$", pos, dir(ang)*1.3, fontsize(7));
        // Label base circle intersection as 1', 2', 3', ...
        pair basePos = R*dir(ang);
        dot(basePos, black+linewidth(2));
        label("$"+string(i)+"'$", basePos, dir(ang)*1.35, fontsize(7));
    }
}

// === CAM PROFILE: 4 separate pieces ===

// 1) Outstroke: smooth curve A -> G
draw(operator..(...outerPoints_out), red+2pt);

// 2) Dwell at outer radius: true circular arc G -> H
draw(arc((0,0), R+stroke, T_ang, S_ang), red+2pt);

// 3) Return stroke: smooth curve H -> P
draw(operator..(...outerPoints_ret), red+2pt);

// 4) Dwell at base circle: true circular arc P -> A (going the long way: 210 deg)
draw(arc((0,0), R, P_ang-angDwell, P_ang), red+2pt);

// Key profile point labels (outer circle)
label("$G$", (R+stroke)*dir(S_ang), NE+(0,2), fontsize(5));
label("$H$", (R+stroke)*dir(T_ang), SE, fontsize(5));

// Outer reference circle
draw(circle((0,0), R+stroke), gray+dashed);

// Title
// label("Fig. 20.11: Cam Profile (Knife-edge Follower, Uniform Velocity)",
//       (0, -(R+stroke+18)), fontsize(9));