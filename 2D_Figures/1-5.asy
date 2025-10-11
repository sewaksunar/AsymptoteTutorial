import geometry;
size(7cm,0);
settings.tex="pdflatex";
import math;

// Define points
pair A = (0, 0);
pair B = (1, 1);
pair C = (-1, 2);

// Draw points
dot(A); label("$A$", A, SE);
dot(B); label("$B$", B, SE);
dot(C); label("$C$", C, SW);

// Perpendicular bisector of AC
pair M1 = (A + C)/2;
pair dir1 = rotate(90)*(A - C); // perpendicular to AC
draw(M1--(M1 + dir1), dashed + gray);

// Perpendicular bisector of AB
pair M2 = (A + B)/2;
pair dir2 = rotate(90)*(B - A); // perpendicular to AB
draw(M2--(M2 + dir2), dashed + gray);

// Circumcenter
pair C0 = extension(M1, M1 + dir1, M2, M2 + dir2);
dot(C0); label("$C_0$", C0, NE);

// Circumcircle
real r = abs(C0 - A);
draw(circle(C0, r), heavygreen);

// Construct point E on circle (rotated 60° from B around C0)
real angle = 60; 
pair dir3 = rotate(angle)*(B - C0); 
dir3 = r * dir3/abs(dir3); // scale to circle radius
pair E = C0 + dir3;
dot(E); label("$E$", E, N);

// Draw triangle lines
draw(A--B,   blue);
draw(A--C,   blue);
draw(B--E,   blue);
draw(E--C,   blue);

// Draw angle arcs and labels
real arcRadius = 0.3;

// Angle at A between B-A-C
draw(arc(A, arcRadius, degrees(B-A), degrees(C-A)), blue);
label("$\alpha$", A + 0.25*dir((degrees(B-A)+degrees(C-A))/2), blue);

// Angle at B between A-B-E
draw(arc(B, arcRadius, degrees(A-B), degrees(E-B)), blue);
label("$\beta$", B + 0.25*dir((degrees(A-B)+degrees(E-B))/2), blue);

// Angle at C between A-C-E
draw(arc(C, arcRadius, degrees(A-C), 180+degrees(C-E)), blue);
label("$\gamma$", C + 0.25*dir((degrees(A-C)+180+degrees(C-E))/2), blue);

// Angle at E between B-E-C
draw(arc(E, arcRadius, degrees(B-E), degrees(C-E)), blue);
label("$\delta$", E + 0.25*dir((degrees(B-E)+degrees(C-E))/2), blue);

perpendicular((C+A)/2,NE,((C+A)/2)--A,blue);

perpendicular((A+B)/2,NE,((A+B)/2)--B,blue);
