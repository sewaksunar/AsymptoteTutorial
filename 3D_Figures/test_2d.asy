import graph;

size(300, 300);

// Draw concentric circles
draw(circle((0,0), 2), linewidth(2bp));
draw(circle((0,0), 3), linewidth(2bp));

// Draw coordinate axes
real axislen = 3.5;
draw((-axislen, 0)--(axislen, 0), gray);
draw((0, -axislen)--(0, axislen), gray);

// Draw arrows for axes
draw((axislen-0.2, 0)--(axislen, 0), gray, Arrow);
draw((0, axislen-0.2)--(0, axislen), gray, Arrow);

// Label axes
label("$x$", (axislen, -0.3));
label("$y$", (-0.3, axislen));

// Draw force vectors
draw((0,0)--(1.5, 0), red, Arrow);
label("$\vec{F}_a$", (1.5, 0.2), red);

draw((0,0)--(0, 1.5), blue, Arrow);
label("$\vec{F}_c$", (-0.3, 1.5), blue);

draw((0,0)--(-1.0, 0.7), green, Arrow);
label("$\vec{R}_N$", (-1.2, 0.9), green);

// Mark center point
dot((0,0), 5bp+black);
label("$O$", (-0.3, -0.3));
