import graph;
size(15cm, 5cm);

// Helper function to draw blocks with multi-line support [Source 1, passage 47]
void drawBlock(pair p, string labelText, real w=3.0, real h=1.6) {
    path b = box(p-(w/2, h/2), p+(w/2, h/2));
    filldraw(b, white, black+1pt);
    // Wrapping text in tabular to allow multi-line labels inside the block
    label("\begin{tabular}{c}" + labelText + "\end{tabular}", p);
}

// Define block positions for the cascaded chain
pair transducerPos = (0,0);
pair bridgePos     = (4.5,0);
pair amplifierPos  = (9,0);
pair recorderPos   = (13.5,0);

// Draw the individual system elements [Theory Turn 17]
drawBlock(transducerPos, "Transducer\\\\ $S_1 = 0.3\ \Omega/^\circ$C");
drawBlock(bridgePos,     "Wheatstone\\\\ Bridge\\\\ $S_2 = 0.01\ $V/$\Omega$");
drawBlock(amplifierPos,  "Amplifier\\\\ $S_3 = 80\ $V/V");
drawBlock(recorderPos,   "Pen Recorder\\\\ $S_4 = 0.12\ $cm/V");

// Draw Signal Connections and intermediate variables
// Input: Temperature Change
draw((-4,0)--transducerPos-(1.5,0), Arrow(TeXHead));
label("$\Delta T$ ($^\circ$C)", (-2.7, 0.3), N, fontsize(9pt));

// Transducer to Bridge: Resistance Change
draw(transducerPos+(1.5,0)--bridgePos-(1.5,0), Arrow(TeXHead));
label("$\Delta R$ ($\Omega$)", (2.25, 0.3), N, fontsize(8pt));

// Bridge to Amplifier: Voltage
draw(bridgePos+(1.5,0)--amplifierPos-(1.5,0), Arrow(TeXHead));
label("$\Delta V_{in}$ (V)", (6.75, 0.3), N, fontsize(8pt));

// Amplifier to Recorder: Amplified Voltage
draw(amplifierPos+(1.5,0)--recorderPos-(1.5,0), Arrow(TeXHead));
label("$\Delta V_{out}$ (V)", (11.25, 0.3), N, fontsize(8pt));

// Output: Pen Movement
draw(recorderPos+(1.5,0)--(17.5,0), Arrow(TeXHead));
label("\begin{tabular}{c} Pen Deflection\\\\ (3 cm) \end{tabular}", (16, 0.8), N, fontsize(9pt));

// Overall System Sensitivity Label
label("\textbf{Overall Sensitivity:} $S_{total} = S_1 \cdot S_2 \cdot S_3 \cdot S_4 = 0.0288$ cm/$^\circ$C", (6.75, -1.8), S, blue);