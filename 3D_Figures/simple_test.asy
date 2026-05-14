import three;

size(300,300);
currentprojection=orthographic(10,-5,5);

draw((0,0,0)--(1,0,0), red);
draw((0,0,0)--(0,1,0), green);
draw((0,0,0)--(0,0,1), blue);

draw(unitcircle3);
