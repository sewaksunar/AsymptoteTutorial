import graph;

real a4W = 21cm;
real a4H = 29.7cm;
size(a4W, a4H, IgnoreAspect);

real xL = 0;
real xR = 16;
real yB = 0;
real yT = 24;

int decades    = 4;
int yMajorStep = 10;
int yMidStep   = 5;
int yMinorStep = 1;
real ySubStep  = 0.5;

real margin     = 0.2;
real pageMargin = 0.2;

real X(real w) { return xL + (log(w)/log(10))/decades*(xR-xL); }

pen gridSub     = gray(0.88)+linewidth(0.14);
pen gridMinor   = gray(0.72)+linewidth(0.28);
pen vMidBlack   = black+linewidth(0.52);
pen vMajorBlack = black+linewidth(0.72);
pen hMidBlack   = black+linewidth(0.52);
pen hMajorBlack = black+linewidth(0.72);

fill(box((xL-margin-pageMargin, yB-margin-pageMargin),
         (xR+margin+pageMargin, yT+margin+pageMargin)), white);

// Vertical logarithmic grid.
for (int d = 0; d < decades; ++d) {
    for (int k = 1; k <= 9; ++k) {
        real w = k*10^d;
        pen p = (k == 1) ? vMajorBlack : ((k == 5) ? vMidBlack : gridMinor);
        draw((X(w), yB)--(X(w), yT), p);

        real kNext = (k == 9) ? 10 : (k+1);
        real w1 = k*10^d;
        real w2 = kNext*10^d;
        real lw1 = log(w1);
        real lw2 = log(w2);
        draw((X(exp((2*lw1+lw2)/3)), yB)--(X(exp((2*lw1+lw2)/3)), yT), gridSub);
        draw((X(exp((lw1+2*lw2)/3)), yB)--(X(exp((lw1+2*lw2)/3)), yT), gridSub);
    }
}
for (int d = 0; d < decades; ++d) {
    draw((X(1*10^d), yB)--(X(1*10^d), yT), vMajorBlack);
    draw((X(5*10^d), yB)--(X(5*10^d), yT), vMidBlack);
}
draw((X(10^decades), yB)--(X(10^decades), yT), vMajorBlack);

// Horizontal grid — fine to coarse, coarser always overdraws finer.
for (real y = yB; y <= yT + 1e-9; y += ySubStep)
    draw((xL, y)--(xR, y), gridSub);

for (int y = (int)yB; y <= (int)yT; ++y)
    draw((xL, (real)y)--(xR, (real)y), gridMinor);

for (int y = (int)yB; y <= (int)yT; y += yMidStep)
    draw((xL, (real)y)--(xR, (real)y), hMidBlack);

for (int y = (int)yB; y <= (int)yT; y += yMajorStep)
    draw((xL, (real)y)--(xR, (real)y), hMajorBlack);

// Boundaries: always black regardless of step alignment.
draw((xL, yB)--(xR, yB), hMajorBlack);
draw((xL, yT)--(xR, yT), hMajorBlack);

// Borders.
draw(box((xL-margin-pageMargin, yB-margin-pageMargin),
         (xR+margin+pageMargin, yT+margin+pageMargin)), white+linewidth(0.85));
draw(box((xL, yB), (xR, yT)), black+linewidth(0.85));

// Bottom decade labels.
for (int n = 0; n <= decades; ++n) {
    real w = 10^n;
    string t = (n == 0) ? "$1$" : "$10^{"+string(n)+"}$";
    label(t, (X(w), yB-0.05), S, fontsize(9));
}