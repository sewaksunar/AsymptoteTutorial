import geometry;
import graph;

size(13cm, 13cm);

real R      = 50;
real stroke = 40;
real e      = 20;
int  n      = 6;

real angOS    = 60;
real angST    = 30;
real angTP    = 60;
real angDwell = 210;

real yA = sqrt(R*R - e*e);   // ~45.83

// cam profile point: cam rotated phi deg CCW, follower displaced s
pair camPt(real phi, real s) {
    return rotate(-phi)*(e, yA + s);
}

void drawCross(pair p, real half=1.3, pen pstyle=black+0.8pt) {
    draw((p+(-half,-half))--(p+(half,half)), pstyle);
    draw((p+(-half,half))--(p+(half,-half)), pstyle);
}

// key cam-rotation angles
real phi_G    = angOS;
real phi_H    = angOS + angST;
real phi_Pval = angOS + angST + angTP;

pair ptA = camPt(0,       0);
pair ptG = camPt(phi_G,   stroke);
pair ptH = camPt(phi_H,   stroke);
pair ptP = camPt(phi_Pval, 0);

// direction angles of key points from O
real angA    = degrees(atan2(ptA.y, ptA.x));
real angG    = degrees(atan2(ptG.y, ptG.x));
real angH    = degrees(atan2(ptH.y, ptH.x));
real angPval = degrees(atan2(ptP.y, ptP.x));

real outerR = length(ptG);   // ~88.1

// ── circles ────────────────────────────────────────────────────
draw(circle((0,0), R),       blue+1pt);
draw(circle((0,0), e),       gray+0.7pt);
draw(circle((0,0), outerR),  gray+dashed+0.5pt);

dot((0,0));
label("$O$", (0,0), SW, fontsize(7));
label("offset circle", e*dir(180), dir(180), fontsize(5));

// ── dimensions ─────────────────────────────────────────────────
draw((0,0)--R*dir(145), black+0.7pt, Arrows(4));
label("$50$", 0.48*R*dir(145)+(1,2), fontsize(7));

draw((0,yA)--(e,yA), black+0.7pt, Arrows(4));
draw((0,0)--(0,yA), gray+dashed+0.5pt);
label("$e{=}20$", (e/2, yA-3), fontsize(6));

draw((e,yA)--(e,yA+stroke), black+0.7pt, Arrows(4));
label("$40$", (e+5, yA+stroke/2), fontsize(7));

// ── reference dashed lines through key profile points ──────────
real ext = outerR + 10;
draw((0,0)--ext*unit(ptA), dashed+gray);
draw((0,0)--ext*unit(ptG), dashed+gray);
draw((0,0)--ext*unit(ptH), dashed+gray);
draw((0,0)--ext*unit(ptP), dashed+gray);

// ── key-point labels on base circle ────────────────────────────
label("$A$", R*unit(ptA),  unit(ptA)*1.35,  fontsize(8));
label("$P$", R*unit(ptP),  unit(ptP)*1.35,  fontsize(8));
label("$G$", ptG,          unit(ptG)*1.13,  fontsize(8));
label("$H$", ptH,          unit(ptH)*1.13,  fontsize(8));

// ── sector-angle arcs ──────────────────────────────────────────
real ai = 13;

draw(arc((0,0), ai, angG, angA), red);
label("$60^\circ$", ai*dir((angA+angG)/2)*0.65, red+fontsize(5));
label("Outstroke",  ai*dir((angA+angG)/2)*2.6,  red+fontsize(5));

draw(arc((0,0), ai*0.75, angH, angG), deepgreen);
label("$30^\circ$", ai*0.75*dir((angG+angH)/2)*1.65, deepgreen+fontsize(5));
label("Dwell",      ai*0.75*dir((angG+angH)/2)*3.1,  deepgreen+fontsize(5));

draw(arc((0,0), ai, angPval, angH), orange);
label("$60^\circ$",   ai*dir((angH+angPval)/2)*0.65, orange+fontsize(5));
label("Returnstroke", ai*dir((angH+angPval)/2)*2.6,  orange+fontsize(5));

real midBase = (angA - 360 + angPval)/2;
draw(arc((0,0), ai*1.3, angA-360, angPval), purple);
label("$210^\circ$", ai*1.3*dir(midBase)*0.7,purple+fontsize(5));
label("Dwell",       ai*1.3*dir(midBase)*0.7+(0,-4.5), purple+fontsize(5));

// ── OUTSTROKE construction points ──────────────────────────────
pair[] outPts;
string[] profLet = {"", "B","C","D","E","F", ""};

for(int i = 0; i <= n; ++i) {
    real phi = i*(angOS/n);
    real s   = i*(stroke/n);
    pair pos = camPt(phi, s);
    pair bpt = camPt(phi, 0);
    pair axd = rotate(-phi)*(0,1);
    pair tpt = e*dir(-phi);

    outPts.push(pos);

    // follower axis line tangent to offset circle
    draw(tpt -- (tpt + (yA + s + 10)*axd), dotted+gray(0.65));
    dot(tpt, gray+linewidth(2));
    dot(pos, red+linewidth(3));

    if(i >= 0 && i <= n) {
        label("$"+profLet[i]+"$", pos, unit(pos)*1.35, fontsize(7));
        if(i == n) {
            dot(bpt);
            label("$S$", bpt, unit(bpt)*1.5, fontsize(7));
        } else {
            dot(bpt, black+linewidth(2));
        }
        label("$"+string(i)+"$", bpt, unit(bpt)*-1.5, fontsize(7));
    }
}

// ── RETURN STROKE construction points ──────────────────────────
pair[] retPts;
string[] profLetP = {"","J","K","L","M","N", ""};

for(int i = 0; i <= n; ++i) {
    real phi = phi_H + i*(angTP/n);
    real s   = stroke - i*(stroke/n);
    pair pos = camPt(phi, s);
    pair bpt = camPt(phi, 0);
    pair axd = rotate(-phi)*(0,1);
    pair tpt = e*dir(-phi);

    retPts.push(pos);

    draw(tpt -- (tpt + (yA + s + 10)*axd), dotted+gray(0.65));
    dot(tpt, gray+linewidth(2));
    dot(pos, blue+linewidth(3));

    if(i >= 0 && i <= n) {
        label("$"+profLetP[i]+"$", pos, unit(pos)*1.35, fontsize(7));
        if(i == 0) {
            dot(bpt);
            label("$T$", bpt, unit(bpt)*1.5, fontsize(7));
        } else {
            dot(bpt, black+linewidth(2));
        }
        label("$"+string(i)+"'$", bpt, unit(bpt)*-1.5, fontsize(7));
    }
}

// ── CAM PROFILE (4 pieces) ─────────────────────────────────────

// 1) Outstroke: A -> G
draw(operator..(...outPts), red+2pt);

// 2) Outer dwell arc: G -> H (30 deg, CCW from angH to angG)
draw(arc((0,0), outerR, angH, angG), red+2pt);

// 3) Return stroke: H -> P
draw(operator..(...retPts), red+2pt);

// 4) Base dwell arc: P -> A (210 deg, CCW from angA-360 to angPval)
draw(arc((0,0), R, angA-360, angPval), red+2pt);

// ── title ──────────────────────────────────────────────────────
// label("Cam Profile --- Offset Knife-edge Follower ($e = 20$\,mm, Uniform Velocity)",
//       (0, -(outerR + 16)), fontsize(8));
