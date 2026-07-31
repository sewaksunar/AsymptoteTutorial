settings.outformat = "pdf";
import graph;

// Dimensions: Independent scaling for waveform detail [1, 2]
size(12cm, 6cm, IgnoreAspect);

// Parameters
real A = 1.5;           // Amplitude
int N = 11;             // Terms in the series (higher = sharper peaks)

// Fourier Series Approximation Function for Triangle Wave
// f(x) = A/2 - (4A/pi^2) * sum_{n=1,3,5...}^N (1/n^2) * cos(nx)
real f_fourier(real x) {
  real sum = 0;
  for (int n = 1; n <= N; n += 2) {
    sum += (1/(n^2)) * cos(n*x);
  }
  return (A/2) - (4*A/(pi^2)) * sum;
}

// Draw the approximation as a solid red line [3, 4]
// n=1000 ensures smooth rendering of the peaks
path approx = graph(f_fourier, 0, 4*pi, n=1000);
draw(approx, red + linewidth(1pt));

// --- Axis Configuration ---
// Locations for ticks and labels at multiples of pi
real[] pi_ticks = {0, pi, 2*pi, 3*pi, 4*pi};

// Suppress decimal labels (3.14...) using the LaTeX comment "%" [5]
xaxis("$x$", xmin=-0.5, xmax=4.5*pi, Ticks("%", pi_ticks, Size=2pt), Arrow(TeXHead));
yaxis("$f(x)$", ymin=-0.2, ymax=A+0.5, LeftTicks(Step=A), Arrow(TeXHead));

// Add mathematical labels manually at the tick locations [6, 7]
labelx("$0$", 0, SW);
labelx("$\pi$", pi, S);
labelx("$2\pi$", 2*pi, S);
labelx("$3\pi$", 3*pi, S);
labelx("$4\pi$", 4*pi, S);

// Amplitude labels
label("$A$", (0, A), W);