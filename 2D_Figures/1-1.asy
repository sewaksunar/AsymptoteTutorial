// Place A and B on x-axis
pair A = (0,0);
pair B = (4,0);

// Place C
pair C = (1, 3);

pair M = (A + B) / 2;

// Draw triangle
draw(A--B--C--cycle);

// Label vertices
label("$A$", A, SW, red);
label("$B$", B, SE, red);
label("$C$", C, N, red);
label("$M$", M, S, red);

// // Angle marker at A using arc()
// draw("$\angle A$", arc(A, 0.3, degrees(B - A), degrees(C - A)), blue, Arrow, EndPenMargin);

// // Angle marker at B using arc()
// draw("$\angle B$", arc(B, 0.3, degrees(C - B), degrees(A - B)), blue, Arrow, EndPenMargin);

// // Angle marker at C using perpendicular()
// label("$\angle C$", C + (-0.1, -0.4), blue); // offset label a bit up-right
// perpendicular(C,NE,C--A,blue);
// ----------- Custom Line Marker Function -----------
void LineMarker(path p, int n=1, real len=0.15, pen tickpen=black) {
  // p: the path (line segment)
  // n: number of tick marks
  // len: half-length of each tick (perpendicular to line)
  // tickpen: pen color/style

  for (int i = 1; i <= n; ++i) {
    real t = i / (n + 1.0);             // equally spaced along the line
    pair P = relpoint(p, t);            // point at fraction t of the path
    pair v = dir(p, t);                 // direction of the line
    pair nvec = rotate(90) * v;         // perpendicular direction
    draw(P - len * nvec -- P + len * nvec, tickpen + linewidth(0.8bp));
  }
}
// Draw line markers on sides
LineMarker(M--C, 1, 0.1, red); 
LineMarker(M--A, 1, 0.1, red);
LineMarker(M--B, 1, 0.1, red);