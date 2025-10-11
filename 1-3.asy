size(7cm, 0);
settings.tex = "pdflatex";
unitsize(1cm);

// Define base points
pair A = (0,0);
pair B = (3,0);
pair P = (2,3);
pair Q = (-1,2);

// Draw points and labels
dot(A); label("$A$", A, SW, red);
dot(B); label("$B$", B, SE, red);
dot(P); label("$P$", P, N, red);

// -------------------------------------------------------------
// Compute circumcenter (center of circle passing through A, B, P)
// -------------------------------------------------------------
pair M1 = (A + B)/2;            // midpoint of AB
pair M2 = (A + P)/2;            // midpoint of AP

// Perpendicular bisectors
pair dir1 = rotate(90)*(B - A);
pair dir2 = rotate(270)*(P - A);

// Intersection of perpendicular bisectors gives circumcenter C
pair C = extension(M1, M1 + dir1, M2, M2 + dir2);

// -------------------------------------------------------------
// Now adjust Q so that it also lies on the same circle
// -------------------------------------------------------------
real r = abs(C - A);            // circle radius
// Project Q radially outward/inward so that |CQ| = r
Q = C + r * (Q - C) / abs(Q - C);

dot(Q); label("$Q$", Q, NW, red);

pair M3 = (A + Q)/2;            // midpoint of AQ (not used)
pair dir3 = rotate(90)*(A - Q); // not used


// -------------------------------------------------------------
// Draw everything
// -------------------------------------------------------------
draw(A--B--P--cycle, blue+1bp);   // triangle ABP
draw(A--B--Q--cycle, red+1bp);    // triangle ABQ
draw(circle(C, r), heavygreen);   // circumcircle

dot(C, heavygreen);
label("$C$", C, NE, heavygreen);

// Optionally show perpendicular bisectors (for clarity)
draw(M1--(M1 + dir1), dashed+gray);
// draw(M2--(M2 + dir2), dashed+gray);
draw(M3--(M3 + dir3), dashed+gray);

// // Angle marker at P using arc()
draw("$\angle P$", arc(P, 0.3,  180+degrees(P - A), 180+degrees(P - B)), blue, EndPenMargin);

// // Angle marker at Q using arc()
draw("$\angle Q$", arc(Q, 0.3,  180+degrees(Q - B), 180+degrees(Q - A)), red, EndPenMargin);