settings.outformat = "pdf";
import graph;

size(12cm, 6cm, IgnoreAspect);

real A = 0.5;           
real T = pi;            

real x(real t) {
  real t_wrapped = t % T;
  if (t_wrapped < 0) t_wrapped += T; 
  return A - (2*A/pi) * t_wrapped;
}

path[] waveform; 
for (int i = 0; i < 6; ++i) {
  waveform.push(graph(x, i*T + 0.001, (i+1)*T - 0.001));
}

draw(waveform, blue + linewidth(1pt));

// Define the locations where you want tick marks
real[] pi_ticks = {0, pi, 2*pi, 3*pi, 4*pi, 5*pi, 6*pi};

// Use "%" as the format string to suppress automatic decimal labels
xaxis("$t$", xmin=-0.5, xmax=6.5*pi, Ticks("%", pi_ticks, Size=2pt), Arrow(TeXHead));
yaxis("$x(t)$", ymin=-A-0.5, ymax=A+0.5, LeftTicks(Step=A), Arrow(TeXHead));

// Manually add mathematical labels at the tick locations
labelx("$\pi$", pi, S);
labelx("$2\pi$", 2*pi, S);
labelx("$3\pi$", 3*pi, S);
labelx("$4\pi$", 4*pi, S);
labelx("$5\pi$", 5*pi, S);
labelx("$6\pi$", 6*pi, S);

// Amplitude labels
label("$A$", (0, A) + (-0.1, 0), W);
label("$-A$", (0, -A) + (-0.1, 0), W);