settings.outformat = "pdf";
unitsize(1cm);

// 1. Define nodes (The Diamond Shape)
pair Top    = (0, 2);
pair Bottom = (0, -2);
pair Left   = (-2, 0);
pair Right  = (2, 0);

// 2. Define a standard resistor zigzag path
// This path is 1 unit long and centered on the y=0 line
path resistorZigzag = (0,0) -- (0.1, 0.2) -- (0.3, -0.2) -- (0.5, 0.2) 
                      -- (0.7, -0.2) -- (0.9, 0.2) -- (1,0);

// 3. Robust Helper function to draw an arm with a resistor
void drawArm(pair start, pair end, string name, align al) {
    path armPath = start -- end;
    pair mid = midpoint(armPath);
    real angle = degrees(atan2(end.y - start.y, end.x - start.x));
    real resLen = 0.8; // Length of the resistor symbol

    // Draw the wires leading to/from the resistor
    draw(start -- relpoint(armPath, 0.35));
    draw(relpoint(armPath, 0.65) -- end);

    // Positioning logic: 
    // 1. Center the zigzag at (0,0) with shift(-0.5, 0)
    // 2. Scale it to the desired length
    // 3. Rotate it to match the arm's angle
    // 4. Shift it to the arm's midpoint [2, 3]
    transform t = shift(mid) * rotate(angle) * scale(resLen) * shift(-0.5, 0);
    draw(t * resistorZigzag, linewidth(0.8pt));

    // Place the label outside the diamond [4, 5]
    label(name, mid, al);
}

// 4. Draw the four arms (Clockwise sequence for R1*R3 = R2*R4)
drawArm(Left, Top,    "$R_1$", NW); // Top-Left arm
drawArm(Top, Right,   "$R_2$", NE); // Top-Right arm
drawArm(Right, Bottom, "$R_3$", SE); // Bottom-Right arm
drawArm(Bottom, Left,  "$R_4$", SW); // Bottom-Left arm

// 5. Output Terminals (Vout)
draw(Left -- Right, dashed + gray);
dot(Left, blue); 
dot(Right, blue);
label("$V_{out}$", (0, 0), 2N);

// 6. Power Source (Vin)
path sourceWire = Top -- (0, 3) -- (4, 3) -- (4, -3) -- (0, -3) -- Bottom;
draw(sourceWire);
filldraw(circle((4, 0), 0.4), white, black);
label("$V_{in}$", (4, 0));
label("+", (4, 0.6));
label("-", (4, -0.6));

// 7. Add connection dots at source junctions [4, 6]
dot(Top);
dot(Bottom);