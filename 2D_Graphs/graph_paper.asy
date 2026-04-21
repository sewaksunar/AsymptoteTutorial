import graph;

real a4W = 21cm;
real a4H = 29.7cm;
size(a4W, a4H, IgnoreAspect);

// Standard graph paper (both axes linear), matching semilog style.
real xL = 0;
real xR = 16;
real yB = 0;
real yT = 24;

real margin = 0.2;
real pageMargin = 0.2;

real xSubStep = 0.25;
int xMinorStep = 1;
int xMidStep   = 5;
int xMajorStep = 10;

real ySubStep = 0.25;
int yMinorStep = 1;
int yMidStep   = 5;
int yMajorStep = 10;

real lineLW = 0.08;
pen gridSub   = gray(0.82)+linewidth(lineLW);
pen gridMinor = gray(0.68)+linewidth(1.15*lineLW);
pen gridMid   = gray(0.52)+linewidth(1.45*lineLW);
pen gridMajor = black+linewidth(1.90*lineLW);

// Keep equal white page margin around the sheet.
fill(box((xL-margin-pageMargin, yB-margin-pageMargin),
         (xR+margin+pageMargin, yT+margin+pageMargin)),
     white);

// Vertical linear grid.
for (real x = xL; x <= xR + 1e-9; x += xSubStep) {
  int ix = round(4*x); // quarter-step index
  pen p = (ix % (4*xMajorStep) == 0) ? gridMajor : ((ix % (4*xMidStep) == 0) ? gridMid : ((ix % (4*xMinorStep) == 0) ? gridMinor : gridSub));
  draw((x, yB)--(x, yT), p);
}

// Horizontal linear grid.
for (real y = yB; y <= yT + 1e-9; y += ySubStep) {
  int iy = round(4*y); // quarter-step index
  pen p = (iy % (4*yMajorStep) == 0) ? gridMajor : ((iy % (4*yMidStep) == 0) ? gridMid : ((iy % (4*yMinorStep) == 0) ? gridMinor : gridSub));
  draw((xL, y)--(xR, y), p);
}

// Inner border only (outer border intentionally transparent).
draw(box((xL, yB), (xR, yT)), black+linewidth(0.20));
