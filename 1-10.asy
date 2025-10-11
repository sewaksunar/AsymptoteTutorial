import geometry;
import math;
size(8cm);
settings.tex="pdflatex";

// === Triangle vertices ===
pair A = (0,0);
pair B = (5,0);
pair C = (4,3);

draw(A--B--C--cycle, blue);

dot("$A$", A, SW, red);
dot("$B$", B, SE, red);
dot("$C$", C, N, red);

// === Points on sides BC and CA ===
real tQ = 0.3; // along CA
pair Q = C + tQ*(A - C);
dot("$Q$", Q, NW, red);

// === Big circle through A, B, P, Q ===
// Perpendicular bisector of AB
pair M_AB = (A + B)/2;
pair dir_AB = rotate(90)*(B - A);

// Perpendicular bisector of AQ
pair M_AQ = (A + Q)/2;
pair dir_AQ = rotate(90)*(Q - A);

// Find center O_big
pair O_big = extension(M_AB, M_AB + dir_AB, M_AQ, M_AQ + dir_AQ);
dot("$O$", O_big, N, blue);

real R_big = abs(O_big - A);
draw(circle(O_big, R_big), heavygreen);

// Construct point P on circle (rotated 20° from B around O_big)
real angle = 20;
pair dir3 = rotate(angle)*(B - O_big);
dir3 = R_big * dir3/abs(dir3); // scale to circle radius
pair P = O_big + dir3;
dot("$P$", P, N);

// Verify distances (for debugging)
write("Distance O to A: ", abs(O_big - A));
write("Distance O to B: ", abs(O_big - B));
write("Distance O to P: ", abs(O_big - P));
write("Distance O to Q: ", abs(O_big - Q));

// === Small circle through C, P, Q ===
pair M1c = (C + P)/2;
pair M2c = (C + Q)/2;
pair dir1c = rotate(90)*(P - C);
pair dir2c = rotate(90)*(Q - C);
pair O_small = extension(M1c, M1c + dir1c, M2c, M2c + dir2c);
dot("$O_C$", O_small, NE, blue);

real R_small = abs(O_small - C);
draw(circle(O_small, R_small), heavygreen);

// === Perpendicular from C to AB passing through O_C ===
pair H = extension(A, B, C, O_small); // intersection of AB and line CO_C
dot("$H$", H, S, red);
draw(C--H, red+1bp);
