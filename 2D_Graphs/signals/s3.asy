settings.outformat = "pdf";
import graph;

// Dimensions: stretch the x-axis for clarity [5]
size(12cm, 6cm, IgnoreAspect);

// Parameters [Source Query]
real A = 1.5;           
real T = 2*pi;

// Define the piecewise function
real f(real x) {
  real x_wrapped = x % T;
  if (x_wrapped < 0) x_wrapped += T; // Handle negative inputs
  
  if (x_wrapped < pi) {
    return (A/pi) * x_wrapped;       // Segment 1: 0 to pi
  } else {
    return (-A/pi) * x_wrapped + 2*A; // Segment 2: pi to 2pi
  }
}

// Draw the waveform as a continuous path [1]
path waveform = graph(f, 0, 4*pi, n=400);
draw(waveform, blue + linewidth(1pt));

// --- Axis Configuration ---
real[] pi_ticks = {0, pi, 2*pi, 3*pi, 4*pi};

// Suppress decimal labels using the "%" LaTeX comment [3]
xaxis("$x$", xmin=-0.5, xmax=4.5*pi, Ticks("%", pi_ticks, Size=2pt), Arrow(TeXHead));
yaxis("$f(x)$", ymin=-0.2, ymax=A+0.5, LeftTicks(Step=A), Arrow(TeXHead));

// Add mathematical labels manually [4]
labelx("$0$", 0, SW);
labelx("$\pi$", pi, S);
labelx("$2\pi$", 2*pi, S);
labelx("$3\pi$", 3*pi, S);
labelx("$4\pi$", 4*pi, S);

// Amplitude label
label("$A$", (0, A), W);