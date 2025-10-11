import geometry;
import math;
size(8cm,0);
settings.tex = "pdflatex";

// === FUNCTION: Draw an arc with tick mark ===
void markEqualArc(pair center, real radius, real a1, real a2, pen p=deepgreen+1bp) {
  if (a2 < a1) a2 += 360;
  draw(arc(center, radius, a1, a2), p);
  real amid = (a1 + a2) / 2;
  pair arcPoint = center + radius * dir(amid);
  real tickLength = 0.08;
  pair radialDir = (arcPoint - center) / abs(arcPoint - center);
  draw(arcPoint - tickLength * radialDir -- arcPoint + tickLength * radialDir, p);
}

// === MAIN CODE ===

// Define triangle vertices
pair A = (0,0);
pair B = (3,0);
pair P = (2,3);

// Draw triangle
dot(A); label("$A$", A, SW, red);
dot(B); label("$B$", B, SE, red);
dot(P); label("$P$", P, N, red);
draw(A--P--B, black+1bp);

// -------- Circumcircle --------
pair M1 = (A + P)/2;
pair M2 = (B + P)/2;
pair dir1 = rotate(90)*(A - P);
pair dir2 = rotate(90)*(P - B);
pair C = extension(M1, M1 + dir1, M2, M2 + dir2);
dot(C); label("$C$", C, NE, blue);
real r = abs(C - A);
draw(circle(C, r), heavygreen);

// -------- Angle bisector and intersection with circle (M) --------
pair v1 = (A - P)/abs(A - P);
pair v2 = (B - P)/abs(B - P);
pair bis_dir = v1 + v2;
path bis_line = P -- (P + 10 * bis_dir);
pair[] inter = intersectionpoints(bis_line, circle(C, r));
pair M = inter[0];

draw(P--M, red+1bp);
dot(M); label("$M$", M, E, red);

// -------- Arcs AM and MB on the circle --------
real angleA = degrees(atan2(A.y - C.y, A.x - C.x));
real angleM = degrees(atan2(M.y - C.y, M.x - C.x));
real angleB = degrees(atan2(B.y - C.y, B.x - C.x));

if (angleM < angleA) angleM += 360;
if (angleB < angleM) angleB += 360;

markEqualArc(C, r, angleA, angleM, deepgreen+1.2bp);
markEqualArc(C, r, angleM, angleB, deepgreen+1.2bp);

draw(M--C, dashed+gray);
// label("$\text{Equal arcs}$", C + (r+0.5)*dir(angleM), gray(0.4));

// ---- Angles at P: APM and MPB using markEqualArc ----
real anglePA = degrees(atan2(A.y - P.y, A.x - P.x));
real anglePM = degrees(atan2(M.y - P.y, M.x - P.x));
real anglePB = degrees(atan2(B.y - P.y, B.x - P.x));
real arcRadius = 0.5;

markEqualArc(P, arcRadius, anglePA, anglePM, red+1bp);  // angle APM
markEqualArc(P, arcRadius, anglePM, anglePB, red+1bp);  // angle MPB
