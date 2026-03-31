import three;
import math;
texpreamble("\usepackage{bm}");

size(300,0);

// currentprojection = oblique;
currentprojection=orthographic((1, 1, 1), Y);


real r=200;
pen p=black;
draw(Label("$x$",1),O--r*X,red+dashed,Arrow3());
draw(Label("$y$",1),O--r*Y,green+dashed,Arrow3());
draw(Label("$z$",1),O--r*Z,blue+dashed,Arrow3());

// label("$\rm O$",(0,0,0),-1.5Y-X);

triple Ax = (0,0,0);
triple Px = Ax + (25, 0, 0);
triple Qx = (50, 0, 0) + Px;
triple Rx = (25, 0, 0) + Qx;
triple Bx = (50, 0, 0) + Rx;

dot("$A$",Ax, SW);
dot("$P$",Px, S);
dot("$Q$",Qx, S);
dot("$R$",Rx, S);
dot("$B$",Bx, S);

triple P = (25, 75, 0);
dot(" ", P, N);
label("$P$", P + (0, 15, 0), NW);

draw(shift(P)*scale3(10)*unitsphere, surfacepen = material(white, emissivepen = gray(0.2)));

triple Q = Qx + (0, -50*sin(30*pi/180), 50*cos(30*pi/180));
dot(" ", Q, N);
label("$Q$", Q + (0, 15, 0), NW);

path3 line = Q -- Qx;
real len = length(line);
write("Length of line: ", len);
draw(line, p+1.5bp);
