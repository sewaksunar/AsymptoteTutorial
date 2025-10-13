import geometry;
size(10cm,0);
settings.tex="pdflatex";

// Define focus and directrix
pair F = (-1, 0);
real directrix_x = -4;
real eccentricity = 0.5; // e < 1 for ellipse

// Draw directrix
draw((directrix_x, -3)--(directrix_x, 3), red + 1bp);
label("Directrix", (directrix_x, 3), N);

// Draw focus
dot(F, blue + 5bp);
label("$F$", F, S);

// Construct ellipse using focus-directrix property
// For a point P on ellipse: |PF| = e * d(P, directrix)
path ell;
real tmin = -180;
real tmax = 180;
int n = 200;

for (int i = 0; i <= n; ++i) {
    real angle = tmin + (tmax - tmin) * i / n;
    real theta = radians(angle);
    
    // Polar form: r = ed/(1 - e*cos(theta))
    // where d is distance from focus to directrix
    real d = abs(F.x - directrix_x);
    real r = eccentricity * d / (1 - eccentricity * cos(theta));
    
    pair P = F + r * dir(angle);
    
    if (i == 0) {
        ell = P;
    } else {
        ell = ell--P;
    }
}
ell = ell--cycle;

draw(ell, heavyblue + 1.5bp);

// Mark several points on the ellipse to show the property
real[] sample_angles = {30, 60, 120, 150};

for (real angle : sample_angles) {
    real theta = radians(angle);
    real d = abs(F.x - directrix_x);
    real r = eccentricity * d / (1 - eccentricity * cos(theta));
    pair P = F + r * dir(angle);
    
    // Draw line from P to focus
    draw(P--F, heavygreen + 0.5bp);
    
    // Draw perpendicular from P to directrix
    pair P_dir = (directrix_x, P.y);
    draw(P--P_dir, orange + 0.5bp + dashed);
    
    // Mark points
    dot(P, black + 4bp);
    dot(P_dir, orange + 3bp);
}

// Add labels
label("$e = " + string(eccentricity) + "$", (2, 2.5));

// Calculate and draw center and second focus
real a = eccentricity * abs(F.x - directrix_x) / (1 - eccentricity^2);
real c = a * eccentricity;
pair O = F + (c, 0);
pair F2 = F + (2*c, 0);

dot(O, black + 4bp);
label("$O$", O, S);
dot(F2, blue + 5bp);
label("$F'$", F2, S);

// Draw second directrix
real directrix2_x = F2.x + (F2.x - F.x) / eccentricity;
draw((directrix2_x, -3)--(directrix2_x, 3), red + 1bp + dashed);

// Add legend
label("Green: Distance to focus", (2, -2.5), heavygreen);
label("Orange: Distance to directrix", (2, -2.8), orange);
label("Ratio = $e = 0.5$", (2, -3.1));