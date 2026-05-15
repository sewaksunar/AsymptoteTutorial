// Non-dimensional unit-step response of a second-order system
// Plots representative responses for:
//  - underdamped:    zeta = 0.3
//  - critically damped: zeta = 1.0
//  - overdamped:     zeta = 1.5
// Natural frequency is normalized to 1 (wn = 1) so time is non-dimensional (t*wn -> t)
// Compare: overshoot & oscillation (underdamped), fastest no-oscillation (critically),
// slower monotonic approach (overdamped).

import graph;
size(500, 300);
real stepResponse(real zeta, real t)
{
	if (zeta < 1.0 - 1e-12) {
		real wd = sqrt(1 - zeta*zeta);
		// y(t) = 1 - (1/wd) * e^{-zeta t} * sin(wd t + acos(zeta))
		return 1 - (1/wd) * exp(-zeta * t) * sin(wd * t + acos(zeta));
	} else if (abs(zeta - 1) < 1e-9) {
		// critically damped: y(t) = 1 - e^{-t}(1 + t)
		return 1 - exp(-t) * (1 + t);
	} else {
		// overdamped: real distinct poles s1, s2 where s = -zeta +/- sqrt(zeta^2 - 1)
		real r = sqrt(zeta*zeta - 1);
		real s1 = -zeta + r;
		real s2 = -zeta - r;
		real denom = s2 - s1; // = -2r
		real A = s2/denom;
		real B = -s1/denom;
		return 1 - A * exp(s1 * t) - B * exp(s2 * t);
	}
}

// time span and sampling
real tmax = 10;
int N = 600;

// choose representative damping ratios
real zeta_under = 0.3;
real zeta_crit  = 1.0;
real zeta_over  = 1.5;

// build sampled paths
path p_under, p_crit, p_over;
for (int i = 0; i <= N; ++i) {
	real t = tmax * i / N;
	pair P = (t, stepResponse(zeta_under, t));
	pair Q = (t, stepResponse(zeta_crit, t));
	pair R = (t, stepResponse(zeta_over, t));
	if (i == 0) {
		p_under = P;
		p_crit  = Q;
		p_over  = R;
	} else {
		p_under = p_under -- P;
		p_crit  = p_crit  -- Q;
		p_over  = p_over  -- R;
	}
}

// axes and grid
real ymin = -0.2, ymax = 1.6;
// axis labels (plain text)
xaxis(Label("t (non-dimensional)"), BottomTop, Ticks(Step=1.0,Size=2), Arrows);
yaxis(Label("y(t)"), LeftRight, Ticks(Step=0.2,Size=2), Arrows, ymin=ymin, ymax=ymax);
// draw the sampled paths we built above
draw(p_under, red+1.2bp);
draw(p_crit,  blue+1.2bp);
draw(p_over,  darkgreen+1.2bp);

// horizontal reference at final value (1)
draw((0,1)--(tmax,1), dashed+black+0.8bp);

// Legend
real lx = 6.5, ly = 1.45;
guide g1 = shift((lx, ly)) * (0,0)--(1.2,0);
label(rotate(0)*"Underdamped (zeta=0.3)", (lx+1.4, ly), red);
draw(shift((lx, ly))*((0,0)--(1.2,0)), red+1.2bp);
label("Critically damped (zeta=1.0)", (lx+1.4, ly-0.25), blue);
draw(shift((lx, ly-0.25))*((0,0)--(1.2,0)), blue+1.2bp);
label("Overdamped (zeta=1.5)", (lx+1.4, ly-0.5), darkgreen);
draw(shift((lx, ly-0.5))*((0,0)--(1.2,0)), darkgreen+1.2bp);

// Informational text on the plot

label("Overshoot and oscillation: underdamped", (2.2, 1.4), red);
label("Fastest non-oscillatory: critically damped", (2.2, 1.2), blue);
label("No overshoot, slower approach: overdamped", (2.2, 1.0), darkgreen);

// Do not call shipout here. You can run `asy -f pdf 2ndOrder.asy` or just `asy 2ndOrder.asy` to create the output.

// End of file

