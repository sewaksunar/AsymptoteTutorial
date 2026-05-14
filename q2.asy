// 1. Explicitly set the scale to fit the physical area [Source 2, 192]
unitsize(x=10cm/3300, y=8cm/55);

// Data points
real[] velocity = {0, 500, 1000, 1500, 2000, 2500, 3000};
real[] voltage  = {0, 8.9, 15.1, 23.5, 29.7, 38.8, 47.5};

// 2. Draw Grid and Add Numeric Axis Labels [Source 2, 177, 243]
pen gridPen = gray + dashed + linewidth(0.2pt);

// Vertical grid lines and X-axis numbers (RPM)
for (real v = 0; v <= 3000; v += 500) {
    draw((v, 0) -- (v, 50), gridPen);
    label((string)v, (v, 0), S, fontsize(8pt)); // numeric label below axis
}

// Horizontal grid lines and Y-axis numbers (Volts)
for (real v = 0; v <= 50; v += 10) {
    draw((0, v) -- (3000, v), gridPen);
    label((string)v, (0, v), W, fontsize(8pt)); // numeric label to left of axis
}

// 3. Draw Main Axes [Source 2, 177]
draw((0,0) -- (3400, 0), arrow=Arrow(TeXHead), L=Label("Angular Velocity (rev/min)", position=EndPoint, align=S));
draw((0,0) -- (0, 55), arrow=Arrow(TeXHead), L=Label("Output Voltage (Volts)", position=EndPoint, align=W));

// 4. Plot data points and add Coordinate Labels [Source 2, 169, 186]
for (int i=0; i<velocity.length; ++i) {
    pair p = (velocity[i], voltage[i]);
    dot(p, red + 3pt);
    
    // Format coordinate string as (x, y)
    string coord = "(" + (string)velocity[i] + ", " + (string)voltage[i] + ")";
    
    // Place label slightly Northeast (NE) of the point
    label(coord, p, NE, fontsize(7pt)); 
}

// 5. Draw the calibration line
draw((0,0) -- (3000, 47.5), blue + linewidth(1pt), L=Label("Sensitivity $\approx 0.0158$ V/rpm", position=Relative(0.6), align=NW));

// Title
label("\textbf{Tachogenerator Calibration Plot}", (1500, 62), N, fontsize(12pt));