import three;
size(300);

// Set up 3D projection - adjusted for better view
currentprojection = perspective(camera=(3,5,4), target=(-4,1,0.75));

// Define beam dimensions
real length = 8;  // Length along x-axis
real bottomWidth = 2.5;   // Bottom width
real topWidth = 1.5;      // Top width
real height = 1.5; // Height along z-axis

// Material for the beam
material m = material(diffusepen=gray(0.6), emissivepen=gray(0.3), opacity(0.7));

// Define vertices of the trapezoidal beam (in negative x direction)
triple[] left = {(-length, -bottomWidth/2, 0), (-length, bottomWidth/2, 0), 
                 (-length, topWidth/2, height), (-length, -topWidth/2, height)};
triple[] right = {(0, -bottomWidth/2, 0), (0, bottomWidth/2, 0), 
                  (0, topWidth/2, height), (0, -topWidth/2, height)};

// Draw faces of the beam
draw(surface(left[0]--left[1]--left[2]--left[3]--cycle), m); // Left face
draw(surface(right[0]--right[1]--right[2]--right[3]--cycle), m); // Right face
draw(surface(left[0]--right[0]--right[1]--left[1]--cycle), m); // Bottom
draw(surface(left[2]--right[2]--right[3]--left[3]--cycle), m); // Top
draw(surface(left[1]--right[1]--right[2]--left[2]--cycle), m); // Front
draw(surface(left[0]--right[0]--right[3]--left[3]--cycle), m); // Back

// Draw plane of symmetry (XZ plane at y=0)
material planeM = material(diffusepen=blue, emissivepen=white, opacity(0.3));
draw(surface((-length,0,0)--(0,0,0)--(0,0,height)--(-length,0,height)--cycle), planeM);

// Add coordinate axes for reference
draw(O--4X, arrow=Arrow3);
draw(O--3Y, arrow=Arrow3);
draw(O--3Z, arrow=Arrow3);
label("$x$", 4X, S);
label("$y$", 3Y, E);
label("$z$", 3Z, N);

// Add local axes at the center of the left face (centroid of trapezoid)
triple leftFaceCenter = (-length, 0, height/2);

// Draw local axes from the left face center
draw(leftFaceCenter -- leftFaceCenter + (2,0,0), red+linewidth(2), arrow=Arrow3);
draw(leftFaceCenter -- leftFaceCenter + (0,1.5,0), green+linewidth(2), arrow=Arrow3);
draw(leftFaceCenter -- leftFaceCenter + (0,0,1.5), blue+linewidth(2), arrow=Arrow3);

// Label the local axes
label("$x$", leftFaceCenter + (2,0,0), E, red);
label("$y$", leftFaceCenter + (0,1.5,0), N, green);
label("$z$", leftFaceCenter + (0,0,1.5), N, blue);

// Label plane of symmetry
label("Plane of Symmetry", (-length/2, 0, height*1.2), blue);