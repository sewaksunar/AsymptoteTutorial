import markers;

settings.tex="pdflatex";

unitsize(1cm);

// Define canvas size
real canvasWidth = 12;
real canvasHeight = 10;

// Draw container canvas (big frame)
draw((-canvasWidth/2, -canvasHeight/2)--(canvasWidth/2, -canvasHeight/2)--(canvasWidth/2, canvasHeight/2)--(-canvasWidth/2, canvasHeight/2)--cycle, linewidth(2) + blue);
label("Canvas", (canvasWidth/2 - 1, canvasHeight/2 - 0.5), blue);

pair center = (0,0);
real boxSize = 3; // 3cm on each side = 6cm total

// Draw the square block
draw(center + (-boxSize,-boxSize)--center + (boxSize,-boxSize)--center + (boxSize,boxSize)--center + (-boxSize,boxSize)--cycle, linewidth(1.5));

// FIRST FORCE VECTOR (Horizontal)
// 1. Point of application: on the LEFT face (at arrow TIP)
pair pointOfApplication1 = center + (-boxSize, 0); // Left face at center height

// 2. Force magnitude (length of arrow represents magnitude)
real forceMagnitude1 = 2.5; // 2.5 cm = magnitude

// 3. Direction of force (horizontal to the right)
pair forceDirection1 = (1, 0);

// Calculate force vector START point (tail of arrow)
pair forceArrowTail1 = pointOfApplication1 - forceMagnitude1 * forceDirection1;

// 4. Draw the force vector (FROM tail TO point of application)
draw(forceArrowTail1--pointOfApplication1, linewidth(1.5) + red, Arrow(6));
label("$F_1$", (forceArrowTail1 + pointOfApplication1)/2 + (0, 0.4), red);

// 5. Dashed line from arrow tip (point of application) to center of mass
draw(pointOfApplication1--center, dashed + linewidth(0.6) + gray);
label("Line of action $F_1$", (pointOfApplication1 + center)/2 + (0, -0.4), gray);

// Mark point of application (at arrow tip/end)
dot(pointOfApplication1, linewidth(4) + red);
label("Point 1", pointOfApplication1 + (-1.2, -0.5), red);


// SECOND FORCE VECTOR (45° angle)
// 1. Point of application: on the LEFT face, above the first force
pair pointOfApplication2 = center + (-boxSize, 1.5); // Left face, 1.5 cm above center

// 2. Force magnitude
real forceMagnitude2 = 2.8; // 2.8 cm = magnitude

// 3. Direction of force (45° angle: both x and y components equal)
pair forceDirection2 = (cos(45), sin(45)); // 45 degrees

// Calculate force vector START point (tail of arrow)
pair forceArrowTail2 = pointOfApplication2 - forceMagnitude2 * forceDirection2;

// 4. Draw the force vector (FROM tail TO point of application)
draw(forceArrowTail2--pointOfApplication2, linewidth(1.5) + green, Arrow(6));
label("$F_2$", (forceArrowTail2 + pointOfApplication2)/2 + (-0.3, 0.5), green);

// 5. Calculate perpendicular from center to line of action of F2
// Find the foot of perpendicular on the line of action
real t = dot(center - pointOfApplication2, forceDirection2);
pair footOfPerpendicular = pointOfApplication2 + t * forceDirection2;

// 6. Line of action for F2: from arrow tip to foot of perpendicular
draw(pointOfApplication2--footOfPerpendicular, dashed + linewidth(0.6) + darkgreen);
label("Line of action $F_2$", (pointOfApplication2 + footOfPerpendicular)/2 + (0.5, 0.3), darkgreen);

// 7. Draw perpendicular from center to foot of perpendicular (moment arm)
draw(center--footOfPerpendicular, linewidth(1) + orange, Arrow(6));
label("$d$", (center + footOfPerpendicular)/2 + (-0.3, 0), orange);

// Mark the foot of perpendicular (intersection point)
dot(footOfPerpendicular, linewidth(4) + purple);
label("Intersection", footOfPerpendicular + (0.5, -0.4), purple);

// Mark point of application for F2 (at arrow tip/end)
dot(pointOfApplication2, linewidth(4) + green);
label("Point 2", pointOfApplication2 + (-1.2, 0.4), green);

// Mark the center of mass
dot(center, linewidth(5) + black);
label("Center of mass", center + (0,-0.8));

// Add magnitude annotations
label("$F_1$ Magnitude = " + string(forceMagnitude1) + " cm", (-4, -4.2), red);
label("$F_2$ Magnitude = " + string(forceMagnitude2) + " cm (45°)", (-4, -4.8), green);

// Newton's Second Law explanation
label("Newton's Second Law: $F = ma$", (3, -4.5));