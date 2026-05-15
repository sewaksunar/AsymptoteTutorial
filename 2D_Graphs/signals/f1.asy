settings.outformat = "pdf";
import graph;

// Dimensions: Independent scaling for waveform clarity
size(12cm, 6cm, IgnoreAspect);

// Parameters
real A = 1.5;           // Amplitude
real T = pi;            // Period [Conversation History]
int N = 50;             // Terms in Fourier series (higher = sharper approximation)

// Fourier Series Approximation Function
// x(t) = (2A/pi) * sum( (1/n) * sin(nt) )
real x_fourier(real t) {
  real sum = 0;
  for (int n = 1; n <= N; ++n) {
    sum += (1/n) * sin(n*t);
  }
  return (2*A/pi) * sum;
}

// Draw the approximation as a solid line (non-dashed)
// n=1000 ensures smooth rendering of the oscillations [6]
path approx = graph(x_fourier, 0, 6*pi, n=1000);
draw(approx, blue + linewidth(1pt));

// --- Axis Configuration ---
real[] pi_ticks = {0, pi, 2*pi, 3*pi, 4*pi, 5*pi, 6*pi};

// Suppress decimal labels (3.14...) using LaTeX comment "%" [4]
xaxis("$t$", xmin=-0.5, xmax=6.5*pi, Ticks("%", pi_ticks, Size=2pt), Arrow(TeXHead));
yaxis("$x(t)$", ymin=-A-0.5, ymax=A+0.5, LeftTicks(Step=A), Arrow(TeXHead));

// Add mathematical labels manually at the tick locations [5, 7]
labelx("$0$", 0, SW);
labelx("$\pi$", pi, S);
labelx("$2\pi$", 2*pi, S);
labelx("$3\pi$", 3*pi, S);
labelx("$4\pi$", 4*pi, S);
labelx("$5\pi$", 5*pi, S);
labelx("$6\pi$", 6*pi, S);

// Amplitude labels
label("$A$", (0, A), W);
label("$-A$", (0, -A), W);