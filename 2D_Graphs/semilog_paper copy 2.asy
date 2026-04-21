import graph;

real a4W = 21cm;
real a4H = 29.7cm;
size(a4W, a4H, IgnoreAspect);

// Standard semilog paper: x-axis logarithmic, y-axis linear.
real xL = 0;
real xR = 16;
real yB = 0;
real yT = 24;

int decades = 4;        // 1 to 10^4
int yMajorStep = 10;    // major horizontal spacing
int yMidStep   = 5;     // medium horizontal spacing
int yMinorStep = 1;     // minor horizontal spacing

real margin = 0.8;
real pageMargin = 0.8;

real X(real w)
{
	return xL + (log(w)/log(10))/decades*(xR-xL);
}

pen gridMinor = rgb(0.72,0.86,0.90)+linewidth(0.18);
pen gridMid   = rgb(0.60,0.79,0.86)+linewidth(0.26);
pen gridMajor = rgb(0.42,0.69,0.78)+linewidth(0.38);

// Keep equal white margin in final exported page.
fill(box((xL-margin-pageMargin, yB-margin-pageMargin),
		 (xR+margin+pageMargin, yT+margin+pageMargin)),
	 white);

// Vertical logarithmic grid: decade lines (major), k=5 lines (mid), others (minor).
for (int d = 0; d < decades; ++d) {
	for (int k = 1; k <= 9; ++k) {
		real w = k*10^d;
		pen p = (k == 1) ? gridMajor : ((k == 5) ? gridMid : gridMinor);
		draw((X(w), yB)--(X(w), yT), p);
	}
}
draw((X(10^decades), yB)--(X(10^decades), yT), gridMajor);

// Horizontal linear grid with standard hierarchy.
for (int y = (int)yB; y <= (int)yT; y += yMinorStep) {
	pen p = (y % yMajorStep == 0) ? gridMajor : ((y % yMidStep == 0) ? gridMid : gridMinor);
	draw((xL, y)--(xR, y), p);
}

// Outer and inner borders.
draw(box((xL-margin, yB-margin), (xR+margin, yT+margin)), gray(0.42)+linewidth(0.8));
draw(box((xL, yB), (xR, yT)), gray(0.30)+linewidth(0.9));

// Bottom decade labels.
for (int n = 0; n <= decades; ++n) {
	real w = 10^n;
	string t = (n == 0) ? "$1$" : "$10^{"+string(n)+"}$";
	label(t, (X(w), yB-0.12), S, fontsize(9));
}

