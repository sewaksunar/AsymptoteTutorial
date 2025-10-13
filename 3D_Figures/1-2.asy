// =======================
// Tetrahedron Stress Visualization with In-Plane Vectors
// =======================

// Required modules
import three;         // 3D drawing capabilities
import math;          // Math utilities
texpreamble("\usepackage{bm}"); // Bold math symbols in labels

// Figure setup
size(300,0);          // Canvas size
currentprojection = perspective(4,2,3); // 3D viewing angle

// -----------------------
// Define tetrahedron vertices
// -----------------------
triple O = (0, 0, 0); // Origin
triple A = (2, 0, 0);
triple B = (0, 2, 0);  
triple C = (0, 0, 2);

// -----------------------
// Centroids of projected faces
// -----------------------
triple Pyz = (O + B + C)/3;   // yz-plane face centroid
triple Pxy = (O + A + B)/3;   // xy-plane face centroid
triple Pxz = (O + A + C)/3;   // xz-plane face centroid

// Centroid of face ABC
triple G = (A + B + C)/3;

// -----------------------
// Compute outward normal vectors for each face
// -----------------------

// Face ABC
triple AB = B - A;
triple AC = C - A;
triple normal_ABC = unit(cross(AB, AC));

// Face OAC (xz-plane)
triple OA = A - O;
triple OC = C - O;
triple normal_OAC = unit(cross(OA, OC));

// Face OBC (yz-plane)
triple OB = B - O;
triple OC_2 = C - O;
triple normal_OBC = unit(cross(OB, OC_2));

// Face OAB (xy-plane)
triple OA_2 = A - O;
triple OB_2 = B - O;
triple normal_OAB = unit(cross(OA_2, OB_2));

// Length of normal vectors for display
real normal_length = 0.8;
real vector_length = 0.6; // Length for in-plane vectors

// -----------------------
// Define vector R in plane ABC
// -----------------------
// Create basis vectors for plane ABC
triple u1_ABC = unit(AB);                           // First basis vector
triple u2_ABC = unit(AC - dot(AC,u1_ABC)*u1_ABC);   // Orthogonal second basis vector
triple R = 0.7*u1_ABC + 0.4*u2_ABC;                 // Vector R in plane ABC
R = unit(R);                                         // Normalize R

// -----------------------
// Styling pens
// -----------------------
pen thickp    = linewidth(0.5mm);
pen normalp   = linewidth(0.3mm);
pen dashp     = dashed + linewidth(0.2mm);
pen axispen   = black;
pen stresspen = red + linewidth(0.4mm);
pen vectorpen = darkgreen + linewidth(0.5mm);       // For in-plane vectors

// -----------------------
// Draw coordinate axes
// -----------------------
real r = 2.5;
draw(Label("$x$",1), O--(r,0,0), axispen, Arrow3);
draw(Label("$y$",1), O--(0,r,0), axispen, Arrow3); 
draw(Label("$z$",1), O--(0,0,r), axispen, Arrow3);

// -----------------------
// Draw tetrahedron faces
// -----------------------
pen bg = gray(0.8) + opacity(0.3); // Face ABC
draw(surface(A--B--C--cycle), bg);

// Projected faces on coordinate planes
draw(surface(O--C--B--cycle), lightred + opacity(0.5));   // yz-plane
draw(surface(O--C--A--cycle), lightblue + opacity(0.5));  // xz-plane
draw(surface(O--A--B--cycle), lightgreen + opacity(0.5)); // xy-plane

// -----------------------
// Label vertices and centroids
// -----------------------
label("$A$", A, SE);
label("$B$", B, NW);
label("$C$", C, SW);
dot("$P_{yz}$", Pyz, E);
dot("$P_{xy}$", Pxy, E);
dot("$P_{xz}$", Pxz, E);
dot("$G$", G, E);

// -----------------------
// Draw normal vectors from centroids
// -----------------------
pen normalpen_ABC = blue + linewidth(0.6mm);
pen normalpen_OAC = magenta + linewidth(0.6mm);
pen normalpen_OBC = cyan + linewidth(0.6mm);
pen normalpen_OAB = orange + linewidth(0.6mm);

draw(Label("$\vec{\sigma}$",1), G--G+(normal_length*normal_ABC), normalpen_ABC, Arrow3);
draw(Label("$\vec{\sigma}_{yy}$",1), Pxz--Pxz+(normal_length*normal_OAC), normalpen_OAC, Arrow3);
draw(Label("$\vec{\sigma}_{xx}$",1), Pyz--Pyz-(normal_length*normal_OBC), normalpen_OBC, Arrow3);
draw(Label("$\vec{\sigma}_{zz}$",1), Pxy--Pxy-(normal_length*normal_OAB), normalpen_OAB, Arrow3);

// -----------------------
// Draw in-plane vectors parallel to coordinate axes
// -----------------------

// At centroid G (plane ABC) - Vector R and coordinate-parallel vectors in plane


// At centroid Pxy (plane OAB, xy-plane) - only x and y directions
draw(Label("$\sigma_{zx}$",1), Pxy--Pxy+(vector_length,0,0), vectorpen, Arrow3);
draw(Label("$\sigma_{zy}$",1), Pxy--Pxy+(0,vector_length,0), vectorpen, Arrow3);

// At centroid Pxz (plane OAC, xz-plane) - only x and z directions  
draw(Label("$\sigma_{yx}$",1), Pxz--Pxz+(vector_length,0,0), vectorpen, Arrow3);
draw(Label("$\sigma_{yz}$",1), Pxz--Pxz+(0,0,vector_length), vectorpen, Arrow3);

// At centroid Pyz (plane OBC, yz-plane) - only y and z directions
draw(Label("$\sigma_{xy}$",1), Pyz--Pyz+(0,vector_length,0), vectorpen, Arrow3);
draw(Label("$\sigma_{xz}$",1), Pyz--Pyz+(0,0,vector_length), vectorpen, Arrow3);



// Length for vector display
real normal_length = 0.8;
real component_length = 0.8;

// Get components of normal vector
real nx = normal_ABC.x;
real ny = normal_ABC.y;
real nz = normal_ABC.z;

// -----------------------
// Styling pens
// -----------------------
pen thickp    = linewidth(0.5mm);
pen normalp   = linewidth(0.3mm);
pen dashp     = dashed + linewidth(0.2mm);
pen axispen   = black;
pen componentpen = red + linewidth(0.5mm);
// -----------------------
// Draw components of n_ABC vector at G
// -----------------------

// X-component of normal vector
draw(Label("$n_x$",1), G--G+(component_length*nx,0,0), componentpen, Arrow3);

// Y-component of normal vector  
draw(Label("$n_y$",1), G--G+(0,component_length*ny,0), componentpen, Arrow3);

// Z-component of normal vector
draw(Label("$n_z$",1), G--G+(0,0,component_length*nz), componentpen, Arrow3);

// -----------------------
// Draw component construction (dashed lines)
// -----------------------
pen constructpen = gray + dashed + linewidth(0.3mm);



// Draw the rectangular box showing vector decomposition
triple end_point = G + normal_length*normal_ABC;
triple x_proj = G + (normal_length*nx,0,0);
triple y_proj = G + (0,normal_length*ny,0);
triple z_proj = G + (0,0,normal_length*nz);

// Draw construction lines for vector decomposition
draw(G--x_proj, constructpen);
draw(G--y_proj, constructpen);
draw(G--z_proj, constructpen);

draw(x_proj--x_proj+(0,normal_length*ny,0), constructpen);
draw(x_proj--x_proj+(0,0,normal_length*nz), constructpen);
draw(y_proj--y_proj+(normal_length*nx,0,0), constructpen);
draw(y_proj--y_proj+(0,0,normal_length*nz), constructpen);
draw(z_proj--z_proj+(normal_length*nx,0,0), constructpen);
draw(z_proj--z_proj+(0,normal_length*ny,0), constructpen);

// -----------------------
// Add numerical values as labels
// -----------------------
//label(format("$n_x = %.3f$", nx), G + (component_length*nx/2, -0.2, 0), S);
//label(format("$n_y = %.3f$", ny), G + (-0.2, component_length*ny/2, 0), W);
//label(format("$n_z = %.3f$", nz), G + (0, -0.2, component_length*nz/2), SW);

// Overall magnitude
//real magnitude = length(normal_ABC);
//label(format("$|\vec{n}_{ABC}| = %.3f$", magnitude), G + normal_length*normal_ABC + (0.1, 0.1, 0.1), NE);


