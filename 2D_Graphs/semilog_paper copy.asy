import graph;

size(15cm, 21cm, IgnoreAspect);

// Horizontal log scale setup: omega in [1, 10^4]
real xL = 0;
real xR = 16;
real decades = 4;

real X(real w)
{
	return xL + (log(w)/log(10))/decades*(xR-xL);
}

// Vertical layout (single semilog paper background with 3 stacked regions)
real yB = 0;
real yT = 24;

real topB = 16;
real topH = 7;

real magB = 8;
real magH = 7;

real phB = 0.8;
real phH = 6.5;

real Ytop(real v) { return topB + (v/60.0)*topH; }          // 0 .. 60 dB
real Ymag(real v) { return magB + ((v+10.0)/70.0)*magH; }    // -10 .. 60 dB
real Yph(real v)  { return phB + ((v+220.0)/140.0)*phH; }    // -220 .. -80 deg

pen gridMinor = rgb(0.72,0.86,0.90)+linewidth(0.20);
pen gridMajor = rgb(0.48,0.72,0.80)+linewidth(0.35);

// Semilog vertical grid (1..9 subdivisions per decade)
for (int d = 0; d < 4; ++d) {
	for (int k = 1; k <= 9; ++k) {
		real w = k*10^d;
		pen p = (k == 1) ? gridMajor : gridMinor;
		draw((X(w), yB)--(X(w), yT), p);
	}
}
draw((X(1e4), yB)--(X(1e4), yT), gridMajor);

// Horizontal graph-paper lines
for (real y = yB; y <= yT + 1e-6; y += 0.25)
	draw((xL, y)--(xR, y), gridMinor);
for (real y = yB; y <= yT + 1e-6; y += 1.00)
	draw((xL, y)--(xR, y), gridMajor);

// Region separators
draw((xL, topB)--(xR, topB), gray(0.35));
draw((xL, magB)--(xR, magB), gray(0.35));

pen curve = black+linewidth(1.0);
pen dashp = black+linewidth(0.8)+dashed;

// -------- Top slope construction --------
draw((X(1), Ytop(60))--(X(10), Ytop(0)), curve);
draw((X(1), Ytop(40))--(X(10), Ytop(0)), curve);
draw((X(1), Ytop(20))--(X(10), Ytop(0)), curve);

label("$-60\,\mathrm{db/dec.}$", (X(2.8), Ytop(35)), E, fontsize(9));
label("$-40\,\mathrm{db/dec.}$", (X(3.6), Ytop(23)), E, fontsize(9));
label("$-20\,\mathrm{db/dec.}$", (X(4.4), Ytop(11)), E, fontsize(9));

filldraw(box((X(85), Ytop(42)), (X(2300), Ytop(58))), white, gray(0.55));
label("$G(s)=\\dfrac{1000}{s(1+0.1s)\,(1+0.001s)}$", (X(180), Ytop(49)), W, fontsize(10));

// -------- Magnitude plot --------
real wc = 100;

path mag = (X(1), Ymag(60))--(X(10), Ymag(40))--(X(100), Ymag(0))--(X(1000), Ymag(-80))--(X(1600), Ymag(-108));
draw(mag, curve);

// Asymptotic helper
draw((X(10), Ymag(40))--(X(1000), Ymag(0)), dashp);

label("$-20\,\mathrm{db/dec.}$", (X(5.0), Ymag(55)), E, fontsize(9));
label("$-40\,\mathrm{db/dec.}$", (X(130), Ymag(30)), E, fontsize(9));
label("$-60\,\mathrm{db/dec.}$", (X(600), Ymag(-73)), E, fontsize(9));

// Gain crossover marker and annotation
draw((X(wc), Ymag(0))--(X(wc), Yph(-180)), dashp);
label("$\\omega_c$", (X(110), Ymag(2)), SE, fontsize(9));

label("Gain crossover", (X(8), Ymag(11.2)), fontsize(10));
label("frequency", (X(8), Ymag(8.8)), fontsize(10));
draw((X(30), Ymag(12))--(X(wc), Ymag(2)), Arrow(TeXHead));

// -------- Phase plot --------
pair[] phPts = {
	(X(1),   Yph(-90)),
	(X(5),   Yph(-112)),
	(X(10),  Yph(-130)),
	(X(50),  Yph(-170)),
	(X(100), Yph(-176)),
	(X(150), Yph(-180)),
	(X(220), Yph(-188)),
	(X(500), Yph(-200))
};

path ph = phPts[0];
for (int i = 1; i < phPts.length; ++i) ph = ph--phPts[i];
draw(ph, curve);

for (int i = 0; i < phPts.length; ++i) {
	filldraw(circle(phPts[i], 0.10), white, black+linewidth(0.7));
}

label("Phase crossover", (X(11), Yph(-205)), fontsize(10));
label("frequency", (X(11), Yph(-212)), fontsize(10));
draw((X(55), Yph(-202))--(X(140), Yph(-182)), Arrow(TeXHead));

// -------- Axes labels / ticks --------
for (int n = 0; n <= 4; ++n) {
	real w = 10^n;
	string t = (n == 0) ? "$1$" : "$10^{"+string(n)+"}$";
	label(t, (X(w), yB-0.6), S, fontsize(9));
}

label("$|G(j\\omega)|\,\mathrm{db}$", (xL-1.0, Ymag(22)), W, rotate(90)*fontsize(10));
label("$\\angle G(j\\omega)$", (xL-1.0, Yph(-150)), W, rotate(90)*fontsize(10));

draw((X(80), yB-0.25)--(X(260), yB-0.25), Arrow(TeXHead));
label("$\\omega\,(\\mathrm{rad/sec})$", (X(95), yB-0.8), S, fontsize(10));

// Left side numerical labels (magnitude)
for (int v = -10; v <= 60; v += 10)
	label("$"+string(v)+"$", (xL-0.35, Ymag(v)), E, fontsize(8));

// Left side numerical labels (phase)
for (int v = -220; v <= -80; v += 20)
	label("$"+string(v)+"^{\\circ}$", (xL-0.35, Yph(v)), E, fontsize(8));

// Left side numerical labels (top panel)
for (int v = 0; v <= 60; v += 20)
	label("$"+string(v)+"$", (xL-0.35, Ytop(v)), E, fontsize(8));

label("Fig. 4.31.", ((xL+xR)/2, yB-1.7), S, fontsize(10));
