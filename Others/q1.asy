import graph;
size(15cm, 4cm);

// Helper function to draw blocks with multi-line LaTeX support
void drawBlock(pair p, string labelText, real w=2.8, real h=1.5) {
    path b = box(p-(w/2, h/2), p+(w/2, h/2));
    filldraw(b, white, black+1pt);
    // Using tabular to allow multi-line labels inside the block
    label("\begin{tabular}{c}" + labelText + "\end{tabular}", p);
}

// Define block positions
pair sensorPos = (0,0);
pair condPos = (4.5,0);
pair adcPos = (9,0);
pair compPos = (13.5,0);

// Draw the Blocks with LaTeX line breaks (\\\\)
drawBlock(sensorPos, "Sensor /\\\\ Transducer");
drawBlock(condPos, "Signal\\\\ Conditioning");
drawBlock(adcPos, "A/D\\\\ Converter");
drawBlock(compPos, "Computer /\\\\ Display");

// Draw Signal Connections
// Input arrow
draw((-4,0)--sensorPos-(1.4,0), Arrow(TeXHead));
label("\begin{tabular}{c} Measurand ($X$)\\\\ (Physical Variable) \end{tabular}", (-3,0.8), N, fontsize(9pt));

// Sensor to Conditioning
draw(sensorPos+(1.4,0)--condPos-(1.4,0), Arrow(TeXHead));
label("\begin{tabular}{c} Signal\\\\ Variable ($S$) \end{tabular}", (2.25,0), N, fontsize(8pt));

// Conditioning to ADC
draw(condPos+(1.4,0)--adcPos-(1.4,0), Arrow(TeXHead));
label("Analog Signal", (6.75,0.2), N, fontsize(8pt));

// ADC to Computer
draw(adcPos+(1.4,0)--compPos-(1.4,0), Arrow(TeXHead));
label("Digital Signal", (11.25,0.2), N, fontsize(8pt));

// Output arrow
draw(compPos+(1.4,0)--(17,0), Arrow(TeXHead));
label("\begin{tabular}{c} Measurement ($M$)\\\\ (Observed Output) \end{tabular}", (16,0.8), N, fontsize(9pt));