import geometry;
size(7cm,0);
settings.tex="pdflatex";

// Define foci of ellipse
pair F1 = (-1, 0);
pair F2 = (1, 0);

// Distance between foci
real c = abs(F2 - F1) / 2;

// Semi-major axis (chosen so that 2a > 2c)
real a = 1.5;

// Semi-minor axis
real b = sqrt(a^2 - c^2);

// Center of ellipse
pair O = (F1 + F2) / 2;

// Draw the ellipse
path ell = ellipse(O, a, b);
draw(ell, blue + 1bp);

// Angles for lines from foci
real angle1 = 15;
real angle2 = 75;

// Direction vectors from foci
pair dir1 = dir(angle1);
pair dir2 = dir(angle2);

// Create lines from foci
pair P1 = F1 + 10 * dir1;
pair P2 = F2 + 10 * dir2;

// Find intersection point of the two lines with the ellipse
pair[] isect1 = intersectionpoints(ell, F1--P1);
pair[] isect2 = intersectionpoints(ell, F2--P2);

// Find the common point (if lines intersect on ellipse)
// Or find intersection of two lines first
pair P = extension(F1, F1 + dir1, F2, F2 + dir2);

// Find closest point on ellipse to P
real tmin = 0;
real dmin = abs(point(ell, 0) - P);
for (real t = 0; t <= length(ell); t += 0.01) {
    real d = abs(point(ell, t) - P);
    if (d < dmin) {
        dmin = d;
        tmin = t;
    }
}
pair P_ellipse = point(ell, tmin);

// Draw foci
dot(F1, red + 4bp);
dot(F2, red + 4bp);
label("$F_1$", F1, SW);
label("$F_2$", F2, SE);

// Draw lines from foci to point on ellipse
draw(F1--P_ellipse, heavygreen);
draw(F2--P_ellipse, heavygreen);

// Draw the point on ellipse
dot(P_ellipse, black + 5bp);
label("$P$", P_ellipse, N);

// Optional: Draw center
dot(O, black + 3bp);
label("$O$", O, S);