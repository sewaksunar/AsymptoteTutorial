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
    label(pointLabel, pointOfApplication + (-1.2, 0.4), forceColor);
    
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
        label("" + forceLabel, (pointOfApplication + centerOfMass)/2 + (0.3, -0.3), forceColor);
    } else {
        // Line of action does NOT pass through center
        // Draw line of action from point of application to foot of perpendicular
        draw(pointOfApplication--footOfPerpendicular, dashed + linewidth(0.6) + forceColor);
        label("" + forceLabel, (pointOfApplication + footOfPerpendicular)/2 + (0.3, 0.3), forceColor);
        
        // Draw perpendicular distance (moment arm)
        draw(centerOfMass--footOfPerpendicular, linewidth(1) + orange, Arrow(6));
        label("$d = " + string(perpDistance) + "$", (centerOfMass + footOfPerpendicular)/2 + (-0.4, 0), orange);
        
        // Mark intersection point
        dot(footOfPerpendicular, linewidth(3) + orange);
    }
}

// Mark the center of mass
dot(center, linewidth(5) + black);
label("Center of mass", center + (0,-0.8));

// DRAW FORCES USING THE FUNCTION

// Force F1: Horizontal force at center height (passes through center)
pair pointOfApp1 = center + (-boxSize, 0);
drawForce(pointOfApp1, 2.5, 0, red, "$$", "", center);

// Force F2: 45° force above center (does NOT pass through center)
pair pointOfApp2 = center + (-boxSize, 1.5);
drawForce(pointOfApp2, 2.8, 45, green, "", "", center);

// Force F3: 30° force below center (does NOT pass through center)
pair pointOfApp3 = center + (-boxSize, -1.2);
drawForce(pointOfApp3, 2.2, 30, purple, "$F_3$", "Point 3", center);

// Add magnitude annotations
label("Forces applied to the block:", (-4, -4.2));
label("$F_1$: 2.5 cm at 0° (horizontal)", (-4, -4.6), red);
label("$F_2$: 2.8 cm at 45°", (-4, -5.0), green);
label("$F_3$: 2.2 cm at 30°", (-4, -5.4), purple);