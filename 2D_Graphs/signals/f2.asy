settings.outformat = "pdf";
import graph;

// Dimensions: independent scaling for waveform detail
size(12cm, 6cm, IgnoreAspect);

// Parameters
real A = 1.5;           // Amplitude
int N = 21;             // Sum terms up to N (higher N = sharper square)

// Fourier Series Approximation Function for Square Wave
// x(t) = (4A/pi) * sum_{n=1,3,5...}^N (1/n) * sin(nt)
real x_fourier(real t) {
  real sum = 0;
  for (int n = 1; n <= N; n += 2) {
    sum += (1/n) * sin(n*t);
  }
  return (4*A/pi) * sum;
}

// Draw the approximation as a solid blue line
// n=1000 ensures smooth rendering of the oscillations (Gibbs phenomenon)
path approx = graph(x_fourier, 0, 3.5*pi, n=1000);
draw(approx, blue + linewidth(1pt));

// --- Axis Configuration ---
real[] pi_ticks = {0, pi, 2*pi, 3*pi};

// Suppress decimal labels (3.14...) using the LaTeX comment "%"
xaxis("$t$", xmin=-0.5, xmax=3.7*pi, Ticks("%", pi_ticks, Size=2pt), Arrow(TeXHead));
yaxis("$x(t)$", ymin=-A-0.5, ymax=A+0.5, LeftTicks(Step=A), Arrow(TeXHead));

// Add mathematical labels manually at the tick locations
labelx("$0$", 0, SW);
labelx("$\pi$", pi, S);
labelx("$2\pi$", 2*pi, S);
labelx("$3\pi$", 3*pi, S);

// Amplitude labels
label("$A$", (0, A), W);
label("$-A$", (0, -A), W);