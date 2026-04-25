settings.outformat = "pdf";
import fontsize;
import geometry;

// Draw the linkage and the given force or forces to scale
real inToCm(real in) { return in/72*2.54; } //
real scale = 500; // 1 cm = 1000 units in the diagram

pair origin = (0,0);
// real lenAO2 = inToCm(6.0) * scale; // in centimeters
// real lenBA = inToCm(18.0) * scale; // in centimeters
// real lenO4O2 = inToCm(8.0) * scale; // in centimeters
// real lenBO4 = inToCm(12.0) * scale; // in centimeters
// real lenQO4 = inToCm(12.5) * scale;

// all are in mm
real lenAO2 = 150;
real lenBA = 450;
real lenO4O2 = 200;
real lenBO4 = 300;
real lenQO4 = 125;

pair ptA = origin + lenAO2*dir(135);
pair ptO4 = origin + lenO4O2*dir(0);

// Find intersection of circles centered at A and O4
path circleA = circle(ptA, lenBA);
path circleO4 = circle(ptO4, lenBO4);
pair[] intersections = intersectionpoints(circleA, circleO4);
pair ptB = intersections[0]; // Take first intersection point

draw(origin--ptA--ptB--ptO4, black+1.5pt);
dot("$O2$", origin, S);
dot("$A$", ptA, N);
dot("$O4$", ptO4, S);
dot("$B$", ptB, N);

pair dirBO4 = unit(ptB - ptO4);
real magQO4 = lenQO4;
pair ptQ = ptO4 + lenQO4*dirBO4;
dot("$Q$", ptQ, NW);

// load force
real fscale = 500 / 200 ; // 500N for 100mm

// force P
real magP = 534 / fscale;
pair tipP = ptQ;
pair tailP = tipP + magP * dir(40);

path forceP = tailP -- tipP;
draw(forceP, 3pt+black, Arrow(15pt));

// ==============
// FBD
// ==============

// FBD of link 4
pair offset4 = (10, 10);

// force F_{34} (force by 3 on 4), magniture unknown
real magF34 = magP * 2;

pair shift4 = (400, 0);
pair ptO4 = ptO4 + shift4;
pair ptB = ptB + shift4;
pair ptQ = ptQ + shift4;
path link4 = ptO4--ptB--ptQ;
draw(link4, black+1.5pt);
dot("$O4$", ptO4, E);
dot("$B$", ptB, N);
dot("$Q$", ptQ, NW);

// force P
real magP = 534 / fscale;
pair tipP = ptQ;
pair tailP = tipP + magP * dir(40);

path forceP = tailP -- tipP;
draw(forceP, 3pt+black, Arrow(15pt));
label("$P$", tailP, E);

// force F_{34} (force by 3 on 4), magniture unknown
pair dirF34 = unit(ptB - ptA); // Perpendicular to BO4
pair tipF34 = ptB;
pair tailF34 = tipF34 - 0.5 * magF34 * dirF34;
path forceF34 = tailF34 -- tipF34;
draw(forceF34, 3pt+black+dashed, Arrow(15pt));
label("$F_{34}$", tailF34, W);

// construction line (line of F_{34} and P)
pair dirF34 = unit(ptB - ptA); // Direction of F34
path L1 = (tipF34) -- (tipF34 + 0.5 * magF34 * dirF34);
draw(L1, gray+dashed);

// construction line (line of P)
pair dirP = unit(tipP - tailP); // Direction of P
path L2 = (tailP) -- (tailP - 0.5 * magP * dirP);
draw(L2, gray+dashed);

// Find intersection of construction lines
pair I = intersectionpoint(L1, L2);
dot(I, red);
label("$I$", I, NE);

// force F_{14} (force by 1 on 4), magniture unknown
pair dirF14 = unit(I - ptO4); // Direction from O4 to intersection point I
pair tipF14 = ptO4;

// construction line for F_{14} (line from O4 to I)
path L3 = (ptO4) -- (I);
draw(L3, gray+dashed);

pair tailF14 = tipF14 - 0.5 * magF34 * dirF14; // Use same magnitude as F34 for visualization
path forceF14 = tailF14 -- tipF14;
draw(forceF14, 3pt+black+dashed, Arrow(15pt));
label("$F_{14}$", tailF14, S);

// vecotr polygon for link 4
pair pole = (800, 50);
pair ptP_poly = pole + magP * dirP;
label("$P$", ptP_poly, W);
draw(pole--ptP_poly, 3pt+black, Arrow(15pt));

pair ptF34_poly =  pole + magP * dirP + 0.2 * magF34 * dirF34;
path forceF34_poly = pole + magP * dirP--ptF34_poly;
label("$F_{34}$",  pole + magP * dirP + 0.2 * magF34 * dirF34, E);
draw(forceF34_poly, 1pt+black+dashed, Arrow(15pt));


pair ptF14_poly = pole - 0.5 * magF34 * dirF14;
path forceF14_poly = ptF14_poly -- pole;
label("$F_{14}$", pole, E);
draw(forceF14_poly, 1pt+black+dashed, Arrow(15pt));

pair I = intersectionpoint(forceF14_poly, forceF34_poly);
dot("$I$", I, S);

path forceF34 = ptP_poly--I;
draw(forceF34, 3pt+black, Arrow(15pt));

path forceF14 = I--pole;
draw(forceF14, 3pt+black, Arrow(15pt));

write("F_{34} =" + string(length(forceF34)));
write("F_{14} =" + string(length(forceF14)));