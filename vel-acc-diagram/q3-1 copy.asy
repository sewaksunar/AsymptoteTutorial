settings.outformat = "pdf";
import fontsize;
import geometry;

texpreamble("\usepackage{amsmath,amssymb}");

pair origin = (0,0);

real ro4o2 = 300; // in relative units

pair pointO4 = origin;

pair pointO2 = origin + ro4o2*dir(90);

// draw(origin--pointO4, black+1.5pt, dashed);
path lineO4O2 = pointO4--pointO2;
// draw(lineO4O2, black+1.5pt, dashed);
draw(lineO4O2, black+1.5pt+dashed);
dot("$O_2$", pointO2, W);
dot("$O_4$", pointO4, W);

pair pointA = pointO2 + 175*dir(-75);

path lineA = pointO2--pointA;
draw(lineA, black+1.5pt);
dot("$A$", pointA, NE);

pair vecO4A = pointA - pointO4;
pair normalO4A = unit(vecO4A);
real velO4A_len = 700; // in relative units
pair pointB = origin + velO4A_len * normalO4A;
path lineBO4 = pointO4--pointB;
draw(lineBO4, black+1.5pt);
dot("$B$", pointB, NE);

pair get_midpoint(pair p1, pair p2) {
  return (p1 + p2)/2;
}

path rectangle(pair center, real lenght, real width, real angle) {
  pair dir = dir(angle);
  pair perp = rotate(90)*dir;
  pair[] corners = new pair[4];
  corners[0] = center - (lenght/2)*dir - (width/2)*perp;
  corners[1] = center + (lenght/2)*dir - (width/2)*perp;
  corners[2] = center + (lenght/2)*dir + (width/2)*perp;
  corners[3] = center - (lenght/2)*dir + (width/2)*perp;
  return corners[0] -- corners[1] -- corners[2] -- corners[3] -- cycle;
}

real get_angle(pair v) {
  return degrees(atan2(v.y, v.x));
}

pair get_corner(pair center, real lenght, real width, real angle, int cornerIndex) {
  pair dir = dir(angle);
  pair perp = rotate(90)*dir;
  pair[] corners = new pair[4];
  corners[0] = center - (lenght/2)*dir - (width/2)*perp;
  corners[1] = center + (lenght/2)*dir - (width/2)*perp;
  corners[2] = center + (lenght/2)*dir + (width/2)*perp;
  corners[3] = center - (lenght/2)*dir + (width/2)*perp;
  return corners[cornerIndex];
}

path rectA = rectangle(pointA, 50, 30, get_angle(pointA - pointO4));
fill(rectA, lightcyan+opacity(0.4));
draw(rectA);

pair get_corener(path rect, int index) {
  return point(rect, index/4.0);
}

label("$4$", get_midpoint(pointO4, pointB), NE);
label("$2$", get_midpoint(pointO2, pointA), NE);
label("$1$", get_midpoint(pointO4, pointO2), NE);
label("$3$", get_corner(pointA, 50, 30, get_angle(pointA - pointO4), 1), NE);


write("B =", pointB);

/// velocity diagram
real omega2 = (60 * 2*pi)/60; // in rad/s
write("omega2 =", omega2);

pair velpole = (238.478498150755,182.726789419917);

// v_{A_{2}/O_2} is perpendicular to OA and has magnitude omega2 * OA
real velO2A_len = omega2 * length(pointA - pointO2);

write("velO2A_len =", velO2A_len);
real velscale = velO2A_len / 200; // 400 units in diagram = velO2A_len

pair unitA2O2 = unit(rotate(90)*(pointA - pointO2));
pair ptA2O2 = velpole + (velO2A_len/velscale) * unitA2O2;
path velA2O2 = velpole--ptA2O2;
draw(velA2O2, red, Arrow(8));
dot("$O_2$", velpole, W);
dot("$\overset{\checkmark \checkmark}{v}_{A_{2}/O_2}$", ptA2O2, NW);
real mvelA2O2 = length(velpole - ptA2O2)*velscale;
write("v_{A_{2}/O_2} =", mvelA2O2);

// v_{A_{4}/O_4} is perpendicular to O4A and magnidue is unknown
real velO4A4_len = 1600; // unknown length for v_{A_{4}/O_{4}}
pair unitA4O4 = unit(rotate(-90)*(pointA - pointO4));
pair ptA4O4 = velpole + velO4A4_len/velscale * unitA4O4;
path velA4O4 = velpole--ptA4O4;

draw(velA4O4, red+dashed+1pt, Arrow(8));
label("$\overset{? \checkmark}{v}_{A_{4}/O_{4}}$", ptA4O4, NE);
write("b exten", ptA4O4);


// v_{A_{2}/A_{4}} is parallel to OA and has magnitude unknown
real velA2A4_len = 1000; // unknown length for v_{A_{2}/A_{4}}
pair unitA2A4 = unit(pointA - pointO2);
pair pointA2A4 = ptA2O2 + velA2A4_len/velscale * unitA2A4;
path velA2A4 = pointA2A4--ptA2O2;
draw(velA2A4, red+dashed+1pt, Arrow(8));
label("$\overset{?\checkmark}{v}_{A_{2}/A_{4}}$", pointA2A4, NE);

// intersections of v_A2A4 with line O4A gives vA2B4
guide lineO4A = velA2A4 -- velA2O2;
guide lineA2A4 = velA4O4 -- velpole;
pair[] inters = intersectionpoints(lineO4A, lineA2A4);
pair b = inters[0];
dot("$b$", b, NE);

path velA4O4 = velpole--b;
draw(velA4O4, red, Arrow(8));
label("$\overset{\checkmark \checkmark}{v}_{A_{4}/A_{4}}$", b, SW);
real mvelA4O4 = length(velpole - b)*velscale;
write("v_{A_{4}/O_{4}} =", mvelA4O4);

path velA4B4 = b -- ptA2O2;
draw(velA4B4, red, Arrow(8));
label("$\overset{\checkmark \checkmark}{v}_{A_{2}/A_{4}}$", ptA2O2 - (-5, 5), SE);
real mvelA2A4 = length(ptA2O2-b)*velscale;
write("v_{A_{2}/A_{4}} =", mvelA2A4);


/// acceleration diagram
pair accpole = (500, 600);
dot("$o$", accpole, E);

// a^n_{A_{2}/O_2}^n is parallel to OA and has magnitude (v_{A_{2}/O_2}^2) / OA
pair unitO2An = unit(pointA - pointO2);
real accO2An_len = (mvelA2O2^2) / length(pointA - pointO2);
real accscale = accO2An_len/400; // 400 units in diagram = accO2An_len
write("accO2An_len =", accO2An_len);

pair ptaccO2An = accpole + (accO2An_len) * unitO2An / accscale;
path accO2An = ptaccO2An--accpole;
draw(accO2An, blue, Arrow(8));
dot("$\overset{\checkmark \checkmark}{a}^n_{A_{2}/O_2}$", accpole, SW);
dot("$b$", ptaccO2An, SW);

// a^t_{A_{2}/O_4} is normal to O4A and has magnitude unknown
// pair normalO4A = unit(rotate(-90)*(pointA - pointO4));
// real accO4A_len = 0; // unknown length for a^t_{A_{4}/O_{4}}
// pair ptaccO4At = accpole + accO4A_len * normalO4A / accscale;
// path accO4A = ptaccO2An -- ptaccO4At;
// draw(accO4A, blue+dashed+1pt);
// label("$\overset{? \checkmark}{a}^t_{A_{4}/O_4}$", ptaccO4At, NE);
// write("accO4A_len =", accO4A_len);

real omega4 = mvelA4O4 / (length(pointA - pointO4));
write("omega4 =", omega4);
// corioslis acceleration a^c_{A_{2}/A_{4}} is perpendicular to O4A and has magnitude unknown
pair unitO2A4 = unit(rotate(-90)*(pointA - pointO4));
pair accA2A4c_len = 2 * omega4 * mvelA2A4; // unknown length for a^c_{A_{2}/A_{4}}
pair ptaccA3A4c = ptaccO2An + accA2A4c_len * unitO2A4 / accscale; // unknown length for a^t_{A_{2}/A_{4}}
draw(ptaccO2An--ptaccA3A4c, blue+dashed+1pt, Arrow(8));
write("accA2A4c_len =", accA2A4c_len);