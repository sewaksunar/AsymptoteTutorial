import graph;

// 1. Explicitly set unitsize to fit the plot [Source 2, 192]
unitsize(x=10cm/7.5, y=6cm/60);

// Parameters from the problem [Theory Turn 21]
real tau = 1.5;
real K = 0.5; // Sensitivity in mm/degC
real step_input = 100; // degC
real final_height = step_input * K; // 50 mm

// Response function: y(t) = AK(1 - exp(-t/tau)) [Source 3, 407]
real f(real t) { return final_height * (1 - exp(-t/tau)); }

// 2. Draw Grid and Axes [Source 2, 177]
pen gridPen = gray + dashed + linewidth(0.2pt);
for (real t = 0; t <= 7.5; t += 1.5) draw((t, 0) -- (t, 55), gridPen);
for (real h = 0; h <= 50; h += 10)  draw((0, h) -- (7.5, h), gridPen);

draw((0,0) -- (8.0, 0), arrow=Arrow(TeXHead), L=Label("Time ($t$) [s]", position=EndPoint, align=S));
// Using tabular for multi-line axis label [Source 2, Turn 19]
draw((0,0) -- (0, 60), arrow=Arrow(TeXHead), L=Label("\begin{tabular}{c} Mercury Height\\ ($q_o$) [mm] \end{tabular}", position=EndPoint, align=W));

// 3. Plot the Response Curve
path p = graph(f, 0, 7.5, n=200);
draw(p, blue + linewidth(1.2pt));

// 4. Annotate Key Points [Source 3, 407]
// 1 Tau (63.2%)
real h1 = f(tau);
draw((tau, 0)--(tau, h1)--(0, h1), dashed + red);
dot((tau, h1), red);
// Combined pens with '+' operator [Source 2, 187]
label("$1\tau=1.5s$", (tau, 0), S, red + fontsize(8pt));
label("63.2\%", (0, h1), W, red + fontsize(8pt));

// 4 Tau (Settled/98%)
draw((4*tau, 0)--(4*tau, f(4*tau)), dashed + gray);
label("\begin{tabular}{c} $4\tau=6.0s$\\ (Settled) \end{tabular}", (4*tau, 0), S, gray + fontsize(8pt));

// Steady State Line
draw((0, final_height)--(7.5, final_height), dashed + black);
label("\begin{tabular}{c} Steady State\\ (50 mm) \end{tabular}", (7.5, final_height), E, fontsize(9pt));

// Title
label("\textbf{Thermometer Step Response ($\Delta T = 100^\circ$C)}", (3.75, 62), N, fontsize(11pt));