// 📦 Imports and LaTeX settings
import markers;     // For arrowhead customization
import geometry;    // For geometric utilities
settings.tex = "pdflatex"; // Enables LaTeX-style labels

// 🖼️ Canvas setup
size(1280, 720);    // Output resolution in pixels
unitsize(1cm);      // 1 unit = 1 cm

real canvasWidth = 16;
real canvasHeight = 9;

// Draw outer canvas frame
draw(box((-canvasWidth/2, -canvasHeight/2), (canvasWidth/2, canvasHeight/2)), linewidth(2) + blue);
label("Canvas (1280x720)", (canvasWidth/2 - 1.5, canvasHeight/2 - 0.3), blue);

// 📐 Axes and origin
draw((-4,0) -- (4,0), red, arrow=Arrow(TeXHead));   // x-axis
draw((0,-4) -- (0,4), blue, arrow=Arrow(TeXHead));  // y-axis

pair O = (0,0);
dot(O);
label("$O$", O, SW);  // Origin label

// 🔣 Transformation parameters
real L = 2.5;        // Scaling factor (length)
pair C = (O); // Final center position
real A = 30;         // Rotation angle in degrees

// 🔄 Composite transformation
transform T = shift(C) * rotate(A) * scale(L) * shift(-0.5, -0.5);
// Order: shift to origin → scale → rotate → shift to center

// 🧱 Draw transformed square
draw(T * unitsquare, linewidth(1) + black); // Apply transform to unit square

// 🔴 Vertex labeling
pair V0 = T * (0, 0), V1 = T * (1, 0), V2 = T * (1, 1), V3 = T * (0, 1);

dot(V0, red); label("$V_0$", V0, SW);
dot(V1, red); label("$V_1$", V1, SE);
dot(V2, red); label("$V_2$", V2, NE);
dot(V3, red); label("$V_3$", V3, NW);

// 🔵 Midpoint labeling
pair M01 = T * (0.5, 0), M12 = T * (1, 0.5), M23 = T * (0.5, 1), M30 = T * (0, 0.5);

dot(M01, blue); label("$M_{01}$", M01, S);
dot(M12, blue); label("$M_{12}$", M12, E);
dot(M23, blue); label("$M_{23}$", M23, N);
dot(M30, blue); label("$M_{30}$", M30, W);

// 🟣 Center point
dot(C, purple);
label("$C$", C, 2*SE);
