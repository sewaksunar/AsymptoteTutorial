settings.outformat = "pdf";
unitsize(1cm);

// 1. Define the Aluminum Structure (The Bar)
real barL = 7, barW = 2;
filldraw(box((0,0), (barL, barW)), lightgray+opacity(0.3), black+linewidth(0.8pt));
label("\textbf{Aluminum Structure}", (barL/2, barW), 1.5N);

// 2. Draw Loading Arrows (Tensile Force F)
draw((-1.5, barW/2) -- (-0.2, barW/2), Arrow(TeXHead));
draw((barL+0.2, barW/2) -- (barL+1.5, barW/2), Arrow(TeXHead));
label("$F$ (Tension)", (-1.5, barW/2), N);
label("$F$", (barL+1.5, barW/2), N);

// 3. Draw the Strain Gauge (Serpentine pattern)
pair gridStart = (2.5, 0.5);
real gridW = 2, gridH = 1;
int segments = 6;
real dy = gridH / segments;

path grid;
for(int i=0; i <= segments; ++i) {
    real y = gridStart.y + i*dy;
    if (i % 2 == 0) {
        // Horizontal line left to right
        if (i == 0) grid = (gridStart.x, y);
        else grid = grid -- (gridStart.x, y);
        grid = grid -- (gridStart.x + gridW, y);
    } else {
        // Horizontal line right to left
        grid = grid -- (gridStart.x + gridW, y) -- (gridStart.x, y);
    }
}

// Draw the grid and lead wires
draw(grid, darkblue + linewidth(1.2pt));
// Change 'path' to 'path[]' (an array of paths)
path[] leads = (gridStart.x - 0.5, gridStart.y - 0.3) -- (gridStart.x, gridStart.y)
             ^^ (gridStart.x + gridW, gridStart.y + gridH) -- (gridStart.x + gridW + 0.5, gridStart.y + gridH + 0.3);

// The draw command handles path[] arrays automatically
draw(leads, darkblue + linewidth(0.8pt));

draw(leads, darkblue + linewidth(0.8pt));
dot((gridStart.x - 0.5, gridStart.y - 0.3), darkblue);
dot((gridStart.x + gridW + 0.5, gridStart.y + gridH + 0.3), darkblue);

// 4. Add Labels and Data [Conversation History]
label("Strain Gauge ($R = 120\Omega$)", (gridStart.x + gridW/2, gridStart.y - 0.2), S, darkblue);
label("$GF = 2$", (gridStart.x + gridW/2, gridStart.y + gridH + 0.2), N, darkblue);

// Parameters for Aluminum from user query
// label(minipage("\centering \textbf{Material Properties}\\ $E = 68.7$ GPa \\ $\sigma_{yield} = 0.2$ GPa"), (barL/2, barW/2));

// Dimension indicators for strain
draw((gridStart.x, -0.3) -- (gridStart.x + gridW, -0.3), Arrows(TeXHead), bar=Bars);
// label("Active Grid Length ($L$)", (gridStart.x + gridW/2, -0.3), S);

// 5. Resulting Change in Resistance
label(minipage("\raggedright \textbf{Result at Yield Point:}\\ 
      $\epsilon = \sigma / E \approx 0.0029$ \\ 
      $\Delta R = GF \cdot \epsilon \cdot R \approx 0.70 \Omega$"), (barL, -0.8), NW);