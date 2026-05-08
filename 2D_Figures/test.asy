size(7cm, 0);
pair A = (0,0);
pair B = (3,0);
pair P = (2,3);

dot(A); label("$A$", A, SW);
dot(B); label("$B$", B, SE);
dot(P); label("$P$", P, N);

draw(A--B--P--cycle);
