import geometry;
size(7cm,0);
settings.tex="pdflatex";

// Place A and B on x-axis
pair A = (0,0);
pair B = (4,0); // AB is horizontal
path ab = A--B;
transform T = shift(-4,-2);
transform t = shift(4,0);
// Place C such that AC makes 30° and BC makes 120° with x-axis
pair C = extension(A, A + dir(30), B, B + dir(120)); // Intersection of rays

pair M = (A + B) / 2; // Midpoint of AB
// Draw triangle ABC
draw(A--B--C--cycle);

dot("$A$", A, SW, red);
dot("$B$", B, SE, red);
dot("$C$", C, N, red);

// Label vertices
label("$A$", A, SW, red);
label("$B$", B, SE, red);
label("$C$", C, N, red);

// length markers 
label("$a$", (C + B) / 2, E, blue);
label("$b$", (A + C) / 2, NW, blue);
label("$c$", (A + B) / 2, S, blue);

// pythagorean theorem label
label("$a^2 + b^2 = c^2$", (A + C + B) / 3, blue);

label("Pythagorean Theorem", (A+B)/2 + (0, -1), blue);