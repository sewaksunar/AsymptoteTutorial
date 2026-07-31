settings.outformat = "pdf";
import graph;

// Dimensions: stretch time axis for better detail
size(12cm, 6cm, IgnoreAspect);

// Parameters
real A = 1.5;           // Amplitude
real T = 2*pi;          // Period

// Construct a single connected path to make it "continuous"
// This includes the requested jumps: 0->0+, pi- to pi+, and 2pi- to 2pi+
path waveform = (0,0) -- (0,A)         // Jump at 0 (0 to 0+)
             -- (pi,A) -- (pi,0)       // pi- to pi (midpoint)
             -- (pi,-A)                // pi to pi+
             -- (2*pi,-A) -- (2*pi,0)  // 2pi- to 2pi (midpoint)
             -- (2*pi,A)               // 2pi to 2pi+
             -- (3*pi,A);              // Next period segment

draw(waveform, blue + linewidth(1pt));

// Mark the specific discrete values requested
dot((0,0), blue);
dot((pi,0), blue);
dot((2*pi,0), blue);

// --- Axis Configuration ---
real[] pi_ticks = {0, pi, 2*pi, 3*pi};

// Suppress decimal labels (3.14...) using "%"
xaxis("$t$", xmin=-0.5, xmax=3.5*pi, Ticks("%", pi_ticks, Size=2pt), Arrow(TeXHead));
yaxis("$x(t)$", ymin=-A-0.5, ymax=A+0.5, LeftTicks(Step=A), Arrow(TeXHead));

// Add mathematical labels manually
labelx("$0$", 0, SW);
labelx("$\pi$", pi, S);
labelx("$2\pi$", 2*pi, S);
labelx("$3\pi$", 3*pi, S);

// Amplitude labels
label("$A$", (0, A), W);
label("$-A$", (0, -A), W);