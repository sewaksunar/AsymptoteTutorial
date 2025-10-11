import geometry;
import math;
size(8cm,0);
settings.tex = "pdflatex";

// === FUNCTION: Draw an arc with tick mark ===
void markEqualArc(pair center, real radius, real a1, real a2, pen p=deepgreen+1bp) {
//   if (a2 < a1) a2 += 360;
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
pair B = (0.5,2);
pair C = (-1,1);

dot(A); label("$A$", A, SE);
dot(B); label("$B$", B, SE);
dot(C); label("$C$", C, SW);

draw(A--B--C--cycle, blue);


// === Find perpendicular bisectors ===
pair M1 = (A + B)/2;
pair M2 = (B + C)/2;
pair dir1 = rotate(90)*(B - A);
pair dir2 = rotate(90)*(C - B);

// === Find circumcenter ===
pair O = extension(M1, M1 + dir1, M2, M2 + dir2);
dot("$O$", O, NE, blue);

// === Draw circumcircle ===
real R = abs(O - A);
draw(circle(O, R), heavygreen);

// normal to A--B
pair v1 = (A - B)/abs(A - B);
pair v2 = rotate(90)*v1;
pair N = extension(A, B, C, C + v2);
dot("$N$", N, NE, red);
draw(C--N, red+1bp);

draw(C--O, red+1bp);

void markEqualArc(pair center, real radius, real a1, real a2, pen p=deepgreen+1bp) {
//   if (a2 < a1) a2 += 360;
  draw(arc(center, radius, a1, a2), p);
  real amid = (a1 + a2) / 2;
  pair arcPoint = center + radius * dir(amid);
  real tickLength = 0.08;
  pair radialDir = (arcPoint - center) / abs(arcPoint - center);
  draw(arcPoint - tickLength * radialDir -- arcPoint + tickLength * radialDir, p);
}
real arcRadius = 0.3;
markEqualArc(C, arcRadius, 180+degrees(C - N), 180+degrees(C - A), red+1bp);  // angle APM
markEqualArc(C, arcRadius, 180+degrees(C - O), 180+degrees(C - B), red+1bp);  // angle BQN

