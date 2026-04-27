settings.outformat = "pdf";
import fontsize;
import geometry;
include "geometry_utils.asy";

// Setup canvas
path boundary = square((0,0), 20cm);
draw(boundary, dashed+gray);

pair center = (10 cm, 10 cm);

// Base circle (for involute profile)
real rb = 5 cm;
path baseCircle = circle(center, rb);
draw(baseCircle, dashed+red);

// Reference central line passing via center (vertical)
pair ptR = center + 2*rb*dir(100);
draw(center--ptR, 1pt+black);
dot("$R$", ptR, N);

// Pitch circle (defines tooth profile reference)
real rp = 5.5cm;
path pitchCircle = circle(center, rp);
draw(pitchCircle, dashed+blue);

// pitch point defiing line
pair ptP = center + 2*rb*dir(105);
draw(center--ptP, 1pt+black+dashed);
dot("$R$", ptR, N);

// Point P on pitch circle (at intersection with reference line) - HIGH ACCURACY
pair[] intersections = pathIntersection(pitchCircle, center--ptP);
pair ptP = (intersections.length > 1) ? intersections[1] : intersections[0];
dot("$P$", ptP, NW);



// Tangent to base circle on left, passing via P
pair ptT_left = tangentPointToCircle(center, rb, ptP, "left");
dot("$T_L$", ptT_left, SE);

// Extend line from T through P
pair dir_TP = unit(ptP - ptT_left);
pair ptExtended = ptP + 1.5cm * dir_TP;
draw(ptT_left--ptExtended, black+1.5pt);

// locus circle 
real arc = arcLengthByAngle(5cm, 45);