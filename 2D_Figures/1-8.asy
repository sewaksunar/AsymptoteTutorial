//miquel's theorem

import geometry;
size(7cm,0);
settings.tex="pdflatex";
import math;

//mian
// Define triangle vertices
pair A = (0,0);
pair B = (5,0);
pair C = (4,3);
draw(A--B--C--cycle, blue);
dot("$A$", A, SW, red);
dot("$B$", B, SE, red);
dot("$C$", C, N, red);


real t = 0.8; // parameter along AB
pair R = A + t * (B - A);
t = 0.4;
dot("$R$", R, S, red);
pair P = B + t * (C - B);
dot("$P$", P, NE, red);
t = 0.3;
pair Q = C + t * (A - C);
dot("$Q$", Q, NW, red);

///cirlce form A
pair M1 = (A + R)/2;
pair M2 = (A + Q)/2;
pair dir1 = rotate(90)*(A - R); // perpendicular to AQ
pair dir2 = rotate(90)*(A - Q); // perpendicular to AR

// === Find circumcenter ===
pair O = extension(M1, M1 + dir1, M2, M2 + dir2);
dot("$O_A$", O, NE, blue);

// === Draw circumcircle ===
real RA = abs(O - A);
path CircleA = circle(O, RA);
draw(CircleA, heavygreen);

///circle form B
pair M1 = (B + R)/2;
pair M2 = (B + P)/2;
pair dir1 = rotate(90)*(B - R); // perpendicular to BP
pair dir2 = rotate(90)*(B - P); // perpendicular to BQ

// === Find circumcenter ===
pair O_B = extension(M1, M1 + dir1, M2, M2 + dir2);
dot("$O_B$", O_B, NE, blue);

// === Draw circumcircle ===
real RB = abs(O_B - B);
path CircleB = circle(O_B, RB);
draw(CircleB, heavygreen);

///circle form C
pair M1 = (C + Q)/2;
pair M2 = (C + P)/2;
pair dir1 = rotate(90)*(C - Q); // perpendicular to CQ
pair dir2 = rotate(90)*(C - P); // perpendicular to CP

// === Find circumcenter ===
pair O_C = extension(M1, M1 + dir1, M2, M2 + dir2);
dot("$O_C$", O_C, NE, blue);

// === Draw circumcircle ===
real RC = abs(O_C - C);
path CircleC = circle(O_C, RC);
draw(CircleC, dashed+heavygreen);

pair[] interAB = intersectionpoints(CircleA, CircleB);

for (int i = 0; i < interAB.length; ++i) {
  if (abs(interAB[i] - O_C) > RC - 0.001 && abs(interAB[i] - O_C) < RC + 0.001) {
    pair M = interAB[i];
    dot("$I$", M, NE);
  }
}
// thsi M is Miquel point 
