size(7cm, 0);
settings.tex = "pdflatex";
unitsize(1cm);

// Define base points  
pair A = (0,0);
pair B = (3,0);
pair P = (2,3);
pair Q = (-1,2);

// Draw points only (no labels for now)
dot(A, red);
dot(B, red);
dot(P, red);

// Compute circumcenter
pair M1 = (A + B)/2;
pair M2 = (A + P)/2;
pair dir1 = rotate(90)*(B - A);
pair dir2 = rotate(270)*(P - A);
pair C = extension(M1, M1 + dir1, M2, M2 + dir2);

// Adjust Q to lie on circle
real r = abs(C - A);
Q = C + r * (Q - C) / abs(Q - C);

dot(Q, red);

// Draw everything
draw(A--B--P--cycle, blue+1bp);
draw(A--B--Q--cycle, red+1bp);
draw(circle(C, r), heavygreen);
dot(C, heavygreen);

draw(M1--(M1 + dir1), dashed+gray);
pair M3 = (A + Q)/2;
pair dir3 = rotate(90)*(A - Q);
draw(M3--(M3 + dir3), dashed+gray);
