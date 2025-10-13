import markers;

settings.tex="pdflatex";

// Set canvas size to 1280x720 pixels
size(1280, 720);

// Define canvas dimensions in cm for drawing
real canvasWidth = 16;
real canvasHeight = 9;

// Draw container canvas (big frame)
draw((-canvasWidth/2, -canvasHeight/2)--(canvasWidth/2, -canvasHeight/2)--(canvasWidth/2, canvasHeight/2)--(-canvasWidth/2, canvasHeight/2)--cycle, linewidth(2) + blue);
label("Canvas (1280x720)", (canvasWidth/2 - 1.5, canvasHeight/2 - 0.3), blue);

real boxSize = 1.5; // Box size

// Centers of the two blocks
pair center1 = (-3.5, 0); // Left block
pair center2 = (3.5, 0);  // Right block

// FUNCTION TO DRAW FORCE VECTOR WITH AUTOMATIC LINE OF ACTION
void drawForce(pair pointOfApplication, real forceMagnitude, real angleInDegrees, 
               pen forceColor, string forceLabel, string pointLabel, pair centerOfMass) {
    
    // Convert angle to radians and get force direction
    real angleRad = radians(angleInDegrees);
    pair forceDirection = (cos(angleRad), sin(angleRad));
    
    // Calculate force vector tail
    pair forceArrowTail = pointOfApplication - forceMagnitude * forceDirection;
    
    // Draw the force vector
    draw(forceArrowTail--pointOfApplication, linewidth(1.5) + forceColor, Arrow(6));
    label(forceLabel, (forceArrowTail + pointOfApplication)/2 + 0.4*(-sin(angleRad), cos(angleRad)), forceColor);
    
    // Mark point of application
    dot(pointOfApplication, linewidth(4) + forceColor);
    
    // Calculate foot of perpendicular from center to line of action
    real t = dot(centerOfMass - pointOfApplication, forceDirection);
    pair footOfPerpendicular = pointOfApplication + t * forceDirection;
    
    // Calculate perpendicular distance from center to line of action
    real perpDistance = length(centerOfMass - footOfPerpendicular);
    
    // Tolerance for checking if line passes through center
    real tolerance = 0.01;
    
    if (perpDistance < tolerance) {
        // Line of action passes through center of mass
        draw(pointOfApplication--centerOfMass, dashed + linewidth(0.6) + forceColor);
    } else {
        // Line of action does NOT pass through center
        // Draw line of action from point of application to foot of perpendicular
        draw(pointOfApplication--footOfPerpendicular, dashed + linewidth(0.6) + forceColor);
        
        // Draw perpendicular distance (moment arm)
        draw(centerOfMass--footOfPerpendicular, linewidth(0.8) + orange, Arrow(5));
        label("$d$", (centerOfMass + footOfPerpendicular)/2 + (-0.3, 0), orange);
        
        // Mark intersection point
        dot(footOfPerpendicular, linewidth(3) + orange);
    }
}

// Draw Block 1 (Left block)
draw(center1 + (-boxSize,-boxSize)--center1 + (boxSize,-boxSize)--center1 + (boxSize,boxSize)--center1 + (-boxSize,boxSize)--cycle, linewidth(1.5));
dot(center1, linewidth(5) + black);
label("Block A", center1, black);
label("(mass $m_A$)", center1 + (0, -0.5), fontsize(9pt));

// Draw Block 2 (Right block)
draw(center2 + (-boxSize,-boxSize)--center2 + (boxSize,-boxSize)--center2 + (boxSize,boxSize)--center2 + (-boxSize,boxSize)--cycle, linewidth(1.5));
dot(center2, linewidth(5) + black);
label("Block B", center2, black);
label("(mass $m_B$)", center2 + (0, -0.5), fontsize(9pt));

// NEWTON'S THIRD LAW: ACTION-REACTION PAIR
// Block A pushes Block B to the right
pair contactPoint1 = center1 + (boxSize, 0); // Right face of Block A
drawForce(contactPoint1, 2.0, 0, red, "$\vec{F}_{AB}$", "", center1);
label("Action", contactPoint1 + (1.0, 0.5), red);

// Block B pushes Block A to the left (reaction force)
pair contactPoint2 = center2 + (-boxSize, 0); // Left face of Block B
drawForce(contactPoint2, 2.0, 180, green, "$\vec{F}_{BA}$", "", center2);
label("Reaction", contactPoint2 + (-1.2, 0.5), green);

// Show that forces are equal and opposite
draw((-1.5, -3)--(-1.5, -2.5), linewidth(1.5) + red, Arrow(6));
label("$\vec{F}_{AB}$", (-1.5, -2.2), red);

draw((1.5, -2.5)--(1.5, -3), linewidth(1.5) + green, Arrow(6));
label("$\vec{F}_{BA}$", (1.5, -2.2), green);

label("$\vec{F}_{AB} = -\vec{F}_{BA}$", (0, -3.5), fontsize(11pt));
label("(Equal magnitude, opposite direction)", (0, -3.9), fontsize(9pt));

// Newton's Third Law statement
label("Newton's Third Law:", (0, 3.8), fontsize(12pt) + blue);
label("For every action, there is an equal and opposite reaction", (0, 3.4), fontsize(10pt) + blue);
label("Forces always occur in pairs", (0, 3.0), fontsize(9pt) + blue);

// Additional explanation
label("Block A exerts force on Block B $\rightarrow$ $\vec{F}_{AB}$ (Action)", (-4, -4.3), red + fontsize(9pt));
label("Block B exerts force on Block A $\rightarrow$ $\vec{F}_{BA}$ (Reaction)", (4, -4.3), green + fontsize(9pt));