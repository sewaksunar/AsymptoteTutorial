// ==============================
// 3D Stress Transformation: Overlapping View
// Shows both original (x,y,z) and transformed (X',Y',Z') coordinate systems
// Color scheme: X'=blue, Y'=red, Z'=green
// ==============================
import three;

// ---------- Canvas & Projection ----------
size(800, 0);
currentprojection = perspective(8, 4, 4);

// ---------- Common parameters ----------
triple O = (0,0,0);
real axis_length = 1.0;
real cube_size = 0.8;
real stress_length = 1.1;

// ---------- Direction cosines (input) ----------
real l1 = 0.8, m1 = 0.5, n1 = 0.3;
real l2 = -0.3, m2 = 0.7, n2 = 0.6;
real l3 = -0.5, m3 = -0.5, n3 = 0.7;

// ---------- Orthogonalize (Gram-Schmidt) ----------
triple X_new = unit((l1, m1, n1));
triple Y_temp = (l2, m2, n2) - dot((l2, m2, n2), X_new) * X_new;
triple Y_new = unit(Y_temp);
triple Z_new = cross(X_new, Y_new);

// ---------- Pens & Styles ----------
pen origAxisPen = black + linewidth(1.0);
pen transX = blue + linewidth(1.2);
pen transY = red + linewidth(1.2);
pen transZ = rgb(0,0.6,0) + linewidth(1.2);
pen cubeEdge = black + linewidth(0.4);
pen cubeFaceOrig = red + opacity(0.80);
pen cubeFaceTrans = blue + opacity(0.80);
pen normalPen = magenta + linewidth(0.7);
pen shearPen = rgb(1.0,0.5,0) + linewidth(0.7);
pen labelPen = black;

arrowbar3 Arr = Arrow3(size=5);

// ---------- Unified cube drawing function ----------
void drawCube(triple center, real s=cube_size, pen facepen, 
              triple xdir=(1,0,0), triple ydir=(0,1,0), triple zdir=(0,0,1)) {
    triple[] v = new triple[8];
    v[0] = center - s/2*xdir - s/2*ydir - s/2*zdir;
    v[1] = center + s/2*xdir - s/2*ydir - s/2*zdir;
    v[2] = center + s/2*xdir + s/2*ydir - s/2*zdir;
    v[3] = center - s/2*xdir + s/2*ydir - s/2*zdir;
    v[4] = center - s/2*xdir - s/2*ydir + s/2*zdir;
    v[5] = center + s/2*xdir - s/2*ydir + s/2*zdir;
    v[6] = center + s/2*xdir + s/2*ydir + s/2*zdir;
    v[7] = center - s/2*xdir + s/2*ydir + s/2*zdir;
    
    // faces
    draw(surface(v[0]--v[1]--v[2]--v[3]--cycle), facepen);
    draw(surface(v[4]--v[5]--v[6]--v[7]--cycle), facepen);
    draw(surface(v[0]--v[1]--v[5]--v[4]--cycle), facepen);
    draw(surface(v[2]--v[3]--v[7]--v[6]--cycle), facepen);
    draw(surface(v[0]--v[3]--v[7]--v[4]--cycle), facepen);
    draw(surface(v[1]--v[2]--v[6]--v[5]--cycle), facepen);
    
    // edges
    draw(v[0]--v[1]--v[2]--v[3]--cycle, cubeEdge);
    draw(v[4]--v[5]--v[6]--v[7]--cycle, cubeEdge);
    draw(v[0]--v[4], cubeEdge); draw(v[1]--v[5], cubeEdge);
    draw(v[2]--v[6], cubeEdge); draw(v[3]--v[7], cubeEdge);
}

// ========================================
// OVERLAPPING VIEW
// ========================================
triple center = (0,0,0);

// Draw ORIGINAL coordinate axes (x, y, z) in BLACK
draw(center--center+(axis_length,0,0), origAxisPen, Arr);
draw(center--center+(0,axis_length,0), origAxisPen, Arr);
draw(center--center+(0,0,axis_length), origAxisPen, Arr);
label("$x$", center+(axis_length+0.3,0,0), labelPen);
label("$y$", center+(0,axis_length+0.3,0), labelPen);
label("$z$", center+(0,0,axis_length+0.3), labelPen);

// Draw TRANSFORMED coordinate axes (X', Y', Z') in COLORS
draw(center--center+axis_length*X_new, transX, Arr);
draw(center--center+axis_length*Y_new, transY, Arr);
draw(center--center+axis_length*Z_new, transZ, Arr);
label("$X'$", center + (axis_length+0.3)*X_new, transX);
label("$Y'$", center + (axis_length+0.3)*Y_new, transY);
label("$Z'$", center + (axis_length+0.3)*Z_new, transZ);

// Draw original cube (aligned with x,y,z)
drawCube(center, cube_size, cubeFaceOrig);

// Draw transformed cube (aligned with X',Y',Z')
drawCube(center, cube_size, cubeFaceTrans, X_new, Y_new, Z_new);

// Stress vectors on +X' face
triple faceXp = center + (cube_size/2)*X_new;
draw(faceXp--faceXp + stress_length*X_new, normalPen, Arr);
label("$\sigma_{X'X'}$", faceXp + 1.2*stress_length*X_new, normalPen);

draw(faceXp--faceXp + 0.75*stress_length*Y_new, shearPen, Arr);
label("$\sigma_{X'Y'}$", faceXp + 0.85*stress_length*Y_new, shearPen);

draw(faceXp--faceXp + 0.6*stress_length*Z_new, shearPen, Arr);
label("$\sigma_{X'Z'}$", faceXp + 0.7*stress_length*Z_new, shearPen);

// Title and direction cosines
label("Overlapping View: Original and Transformed Coordinate Systems", (0,0,3.8), fontsize(11pt));
label("Direction cosines (orthonormalized):", (3.2,-1.5,0), labelPen);
label("$X' = (0.80, 0.50, 0.30)$", (3.2,-1.9,0), labelPen);
label("$Y' = (-0.51, 0.75, 0.42)$", (3.2,-2.3,0), labelPen);
label("$Z' = (0.32, -0.43, 0.85)$", (3.2,-2.7,0), labelPen);