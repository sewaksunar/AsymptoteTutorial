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

// Center of the block
pair center = (0, 0);

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
    if (pointLabel != "") {
        label(pointLabel, pointOfApplication + (-0.8, 0.4), forceColor);
    }
    
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

// Draw the block
draw(center + (-boxSize,-boxSize)--center + (boxSize,-boxSize)--center + (boxSize,boxSize)--center + (-boxSize,boxSize)--cycle, linewidth(1.5));
dot(center, linewidth(5) + black);
label("Block", center, black);
label("(mass $m$)", center + (0, -0.5));

// NEWTON'S SECOND LAW: F = ma
// Apply multiple forces to demonstrate net force and acceleration

// Force F1: Horizontal force at center (passes through center)
pair pointOfApp1 = center + (-boxSize, 0);
real F1mag = 2.5;
drawForce(pointOfApp1, F1mag, 0, red, "$\vec{F}_1$", "P1", center);

// Force F2: 45° force above center (creates torque)
pair pointOfApp2 = center + (-boxSize, 0.8);
real F2mag = 1.8;
drawForce(pointOfApp2, F2mag, 45, green, "$\vec{F}_2$", "P2", center);

// Force F3: Downward force on right side
pair pointOfApp3 = center + (boxSize, 0.5);
real F3mag = 1.5;
drawForce(pointOfApp3, F3mag, 270, purple, "$\vec{F}_3$", "P3", center);

// Calculate net force (simplified - just showing F1 component for demonstration)
pair netForceStart = center + (boxSize + 1, 0);
pair netForceEnd = netForceStart + (2.0, 0);
draw(netForceStart--netForceEnd, linewidth(2) + orange, Arrow(8));
label("$\vec{F}_{net}$", (netForceStart + netForceEnd)/2 + (0, 0.4), orange);

// Draw acceleration vector
pair accelStart = center + (boxSize + 1, -1);
pair accelEnd = accelStart + (2.0, 0);
draw(accelStart--accelEnd, linewidth(2) + magenta, Arrow(8));
label("$\vec{a}$", (accelStart + accelEnd)/2 + (0, 0.4), magenta);

// Newton's Second Law statement
label("Newton's Second Law:", (0, 3.8), blue);
label("$\vec{F}_{net} = m\vec{a}$", (0, 3.3), blue);
label("The acceleration of an object is proportional to the net force and inversely proportional to its mass", (0, 2.8), blue);

// Explanation box on the right
real explainX = 5.5;
label("Net Force:", (explainX, 1.5));
label("$\vec{F}_{net} = \vec{F}_1 + \vec{F}_2 + \vec{F}_3$", (explainX, 1.0));

label("Acceleration:", (explainX, 0.2));
label("$\vec{a} = \frac{\vec{F}_{net}}{m}$", (explainX, -0.3));

label("Direction:", (explainX, -1.1));
label("Same as $\vec{F}_{net}$", (explainX, -1.6));

// Force descriptions
label("Multiple forces acting on the block:", (-5.5, -2.8));
label("$\vec{F}_1$: Horizontal push (2.5 units)", (-5.5, -3.2), red);
label("$\vec{F}_2$: Angled force at 45° (1.8 units)", (-5.5, -3.6), green);
label("$\vec{F}_3$: Downward force (1.5 units)", (-5.5, -4.0), purple);

// Key concept
label("Key: The block accelerates in the direction of the net force!", (0, -4.0), orange);