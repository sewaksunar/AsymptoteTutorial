import three;
import graph3;

settings.tex="pdflatex";
settings.prc=false;
settings.render=16;

// Set canvas size
size(1280, 720);

// Set up 3D perspective
currentprojection=perspective(8,5,4);

// Draw 3D coordinate axes
draw(O--2X, red, arrow=Arrow3(TeXHead2));
draw(O--2Y, green, arrow=Arrow3(TeXHead2));
draw(O--2Z, blue, arrow=Arrow3(TeXHead2));

label("$x$", 2.2X, red);
label("$y$", 2.2Y, green);
label("$z$", 2.2Z, blue);

// Label origin
dot(O, black);
label("$O$", O, SW);

// Step 1: Define parameters for 3D transformation
real L = 1.5;                    // Scale factor
triple C = (O);      // Center position (Cx, Cy, Cz)
real angleX = 25;                // Rotation around X-axis (degrees)
real angleY = 35;                // Rotation around Y-axis (degrees)
real angleZ = 15;                // Rotation around Z-axis (degrees)

// Step 2: Define the combined transform T3
// Sequence (applied right-to-left):
// 1. Shift unit cube (center at 0.5,0.5,0.5) to origin
// 2. Scale by L
// 3. Rotate around Z, then Y, then X
// 4. Shift to final center C
transform3 T3 = shift(C) * 
                rotate(angleX, X) * 
                rotate(angleY, Y) * 
                rotate(angleZ, Z) * 
                scale3(L) * 
                shift(-0.5, -0.5, -0.5);

// Step 3: Define the 8 vertices of unit cube and transform them
triple[] unitVertices = {
    (0,0,0), (1,0,0), (1,1,0), (0,1,0),  // Bottom face
    (0,0,1), (1,0,1), (1,1,1), (0,1,1)   // Top face
};

triple[] V;
for (int i = 0; i < 8; ++i) {
    V.push(T3 * unitVertices[i]);
}

// Draw the edges of the transformed cube
// Bottom face
draw(V[0]--V[1]--V[2]--V[3]--cycle, linewidth(1.5) + black);
// Top face
draw(V[4]--V[5]--V[6]--V[7]--cycle, linewidth(1.5) + black);
// Vertical edges
draw(V[0]--V[4], linewidth(1.5) + black);
draw(V[1]--V[5], linewidth(1.5) + black);
draw(V[2]--V[6], linewidth(1.5) + black);
draw(V[3]--V[7], linewidth(1.5) + black);

// Label all 8 vertices
string[] vertexLabels = {"V_0", "V_1", "V_2", "V_3", "V_4", "V_5", "V_6", "V_7"};
for (int i = 0; i < 8; ++i) {
    dot(V[i], red);
    label("$" + vertexLabels[i] + "$", V[i]);
}

// Step 4: Calculate and label edge midpoints
// Bottom face edges
triple M01 = T3 * (0.5, 0, 0);
triple M12 = T3 * (1, 0.5, 0);
triple M23 = T3 * (0.5, 1, 0);
triple M30 = T3 * (0, 0.5, 0);

// Top face edges
triple M45 = T3 * (0.5, 0, 1);
triple M56 = T3 * (1, 0.5, 1);
triple M67 = T3 * (0.5, 1, 1);
triple M74 = T3 * (0, 0.5, 1);

// Vertical edges
triple M04 = T3 * (0, 0, 0.5);
triple M15 = T3 * (1, 0, 0.5);
triple M26 = T3 * (1, 1, 0.5);
triple M37 = T3 * (0, 1, 0.5);

// Draw and label edge midpoints
triple[] edgeMidpoints = {M01, M12, M23, M30, M45, M56, M67, M74, M04, M15, M26, M37};
string[] edgeLabels = {"M_{01}", "M_{12}", "M_{23}", "M_{30}", 
                       "M_{45}", "M_{56}", "M_{67}", "M_{74}",
                       "M_{04}", "M_{15}", "M_{26}", "M_{37}"};

for (int i = 0; i < edgeMidpoints.length; ++i) {
    dot(edgeMidpoints[i], blue);
    label("$" + edgeLabels[i] + "$", edgeMidpoints[i], fontsize(8pt));
}

// Step 5: Calculate and label face centers
triple FC_bottom = T3 * (0.5, 0.5, 0);    // Bottom face center
triple FC_top = T3 * (0.5, 0.5, 1);       // Top face center
triple FC_front = T3 * (0.5, 0, 0.5);     // Front face center
triple FC_back = T3 * (0.5, 1, 0.5);      // Back face center
triple FC_left = T3 * (0, 0.5, 0.5);      // Left face center
triple FC_right = T3 * (1, 0.5, 0.5);     // Right face center

triple[] faceCenters = {FC_bottom, FC_top, FC_front, FC_back, FC_left, FC_right};
string[] faceLabels = {"F_{bot}", "F_{top}", "F_{frt}", "F_{bck}", "F_{lft}", "F_{rgt}"};

for (int i = 0; i < faceCenters.length; ++i) {
    dot(faceCenters[i], green);
    label("$" + faceLabels[i] + "$", faceCenters[i], fontsize(8pt));
}

// Mark the cube center
dot(C, purple);
label("$C$", C, fontsize(10pt));