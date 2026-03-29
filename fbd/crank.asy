settings.outformat = "pdf";
import fontsize;
import geometry;

// Draw the linkage and the given force or forces to scale
real inToCm(real in) { return in/72*2.54; } //
real scale = 500; // 1 cm = 1000 units in the diagram
real aScale = scale; // scale for acceleration diagram

pair origin = (0,0);
real lenghtAO2 = inToCm(6.0) * scale; // in centimeters
real lenghtBA = inToCm(18.0) * scale; // in centimeters
real lenghtO4O2 = inToCm(8.0) * scale; // in centimeters
real lengthBO4 = inToCm(12.0) * scale; // in centimeters

pair pointA = origin + lenghtAO2*dir(135);
pair pointO4 = origin + lenghtO4O2*dir(0);

// Find intersection of circles centered at A and O4
path circleA = circle(pointA, lenghtBA);
path circleO4 = circle(pointO4, lengthBO4);
pair[] intersections = intersectionpoints(circleA, circleO4);
pair pointB = intersections[0]; // Take first intersection point

draw(origin--pointA--pointB--pointO4, black+1.5pt);
dot("$O2$", origin, S);
dot("$A$", pointA, N);
dot("$O4$", pointO4, S);
dot("$B$", pointB, N);
