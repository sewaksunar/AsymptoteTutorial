settings.outformat = "pdf";
import fontsize;
import geometry;

texpreamble("\usepackage{amsmath,amssymb}");

pair origin = (0,0);
real ro4o2 = 300;
pair pointO4 = origin;
pair pointO2 = origin + ro4o2*dir(90);
pair pointA = pointO2 + 175*dir(-75);
pair vecO4A = pointA - pointO4;
pair normalO4A = unit(vecO4A);
real velO4A_len = 700;
pair pointB = origin + velO4A_len * normalO4A;

pair get_midpoint(pair p1, pair p2) { return (p1+p2)/2; }
real get_angle(pair v) { return degrees(atan2(v.y, v.x)); }

path rectangle(pair center, real len, real wid, real angle) {
  pair d = dir(angle), p = rotate(90)*d;
  pair c0 = center - (len/2)*d - (wid/2)*p;
  pair c1 = center + (len/2)*d - (wid/2)*p;
  pair c2 = center + (len/2)*d + (wid/2)*p;
  pair c3 = center - (len/2)*d + (wid/2)*p;
  return c0--c1--c2--c3--cycle;
}

pair get_corner(pair center, real len, real wid, real angle, int idx) {
  pair d = dir(angle), p = rotate(90)*d;
  pair[] c = new pair[4];
  c[0] = center - (len/2)*d - (wid/2)*p;
  c[1] = center + (len/2)*d - (wid/2)*p;
  c[2] = center + (len/2)*d + (wid/2)*p;
  c[3] = center - (len/2)*d + (wid/2)*p;
  return c[idx];
}

real omega2 = (60 * 2*pi)/60;
pair velpole = (238.478498150755, -182.726789419917);
real  velA2O2_mag = omega2 * length(pointA - pointO2);
pair  unitA2O2 = unit(rotate(90)*(pointA - pointO2));
real  velscale = velA2O2_mag / 400;
pair  pt_vA2O2 = velpole + (velA2O2_mag/velscale) * unitA2O2;

pair sliderDir = unit(pointA - pointO4);
path lineL1 = pt_vA2O2 + 1000*sliderDir -- pt_vA2O2 - 1000*sliderDir;

pair perpO4A_dir = unit(rotate(-90)*(pointA - pointO4));
path lineL2 = velpole + 1000*perpO4A_dir -- velpole - 1000*perpO4A_dir;

pair[] inters = intersectionpoints(lineL1, lineL2);
pair p_vA4O4 = inters[0];

real velA4O4_mag = length(velpole - p_vA4O4) * velscale;
real velA2A4_mag = length(p_vA4O4 - pt_vA2O2) * velscale;
real omega4 = velA4O4_mag / length(pointA - pointO4);

write("B = (" + string(pointB.x) + ", " + string(pointB.y) + ") mm");
write("omega2 = " + string(omega2) + " rad/s");
write("v_{A2/O2} = " + string(velA2O2_mag) + " mm/s");
write("v_{A4/O4} = " + string(velA4O4_mag) + " mm/s");
write("v_{A2/A4} = " + string(velA2A4_mag) + " mm/s");
write("omega4 = " + string(omega4) + " rad/s");

picture spaceDiagram;
draw(spaceDiagram, pointO4--pointO2, black+1.5pt+dashed);
dot(spaceDiagram, "$O_2$", pointO2, W);
dot(spaceDiagram, "$O_4$", pointO4, W);
draw(spaceDiagram, pointO2--pointA, black+1.5pt);
dot(spaceDiagram, "$A$", pointA, NE);
draw(spaceDiagram, pointO4--pointB, black+1.5pt);
dot(spaceDiagram, "$B$", pointB, NE);

path rectA = rectangle(pointA, 50, 30, get_angle(pointA - pointO4));
fill(spaceDiagram, rectA, white);
draw(spaceDiagram, rectA, black+1.5pt);

label(spaceDiagram, "$4$", get_midpoint(pointO4, pointB),  NE);
label(spaceDiagram, "$2$", get_midpoint(pointO2, pointA),  NE);
label(spaceDiagram, "$1$", get_midpoint(pointO4, pointO2), NE);
label(spaceDiagram, "$3$", get_corner(pointA, 50, 30, get_angle(pointA-pointO4), 1), NE);

shipout("q3-2-space", spaceDiagram, Portrait, "pdf", false, false);

picture velDiagram;
draw(velDiagram, pointO4--pointO2, black+1.5pt+dashed);
dot(velDiagram, "$O_2$", pointO2, W);
dot(velDiagram, "$O_4$", pointO4, W);
draw(velDiagram, pointO2--pointA, black+1.5pt);
dot(velDiagram, "$A$", pointA, NE);
draw(velDiagram, pointO4--pointB, black+1.5pt);
dot(velDiagram, "$B$", pointB, NE);

path rectA = rectangle(pointA, 50, 30, get_angle(pointA - pointO4));
fill(velDiagram, rectA, white);
draw(velDiagram, rectA, black+1.5pt);

label(velDiagram, "$4$", get_midpoint(pointO4, pointB),  NE);
label(velDiagram, "$2$", get_midpoint(pointO2, pointA),  NE);
label(velDiagram, "$1$", get_midpoint(pointO4, pointO2), NE);
label(velDiagram, "$3$", get_corner(pointA, 50, 30, get_angle(pointA-pointO4), 1), NE);

draw(velDiagram, velpole--pt_vA2O2, red, Arrow(8));
dot(velDiagram, "$o$", velpole, W);
dot(velDiagram, "$\overset{\checkmark\checkmark}{v}_{A_2/O_2}$", pt_vA2O2, NW);

draw(velDiagram, velpole -- (velpole + 1200/velscale*perpO4A_dir), red+dashed+1pt, Arrow(8));
label(velDiagram, "$\overset{?\checkmark}{v}_{A_4/O_4}$", velpole + 1200/velscale*perpO4A_dir, SE);

draw(velDiagram, pt_vA2O2 -- (pt_vA2O2 + 200/velscale*sliderDir), red+dashed+1pt, Arrow(8));
label(velDiagram, "$\overset{?\checkmark}{v}_{A_2/A_4}$", pt_vA2O2 + 200/velscale*sliderDir, NE);

dot(velDiagram, "$b$", p_vA4O4, NW+(0,2));
draw(velDiagram, velpole--p_vA4O4, red, Arrow(8));
label(velDiagram, "$\overset{\checkmark \checkmark}{v}_{A_4/O_4}$", p_vA4O4, SW);
draw(velDiagram, p_vA4O4--pt_vA2O2, red, Arrow(8));
label(velDiagram, "$\overset{\checkmark\checkmark}{v}_{A_2/A_4}$", pt_vA2O2+(0,-5), SE);

shipout("q3-2-velocity", velDiagram, Portrait, "pdf", false, false);

pair accpole = (800, 600);
pair unitO4A = unit(pointA - pointO4);
pair unitPerpO4A = unit(rotate(90)*(pointA - pointO4));

pair unitCentripO2 = unit(pointO2 - pointA);
real accA2O2n_mag = (omega2^2) * length(pointA - pointO2);
real accscale = accA2O2n_mag / 200;
pair pt_accA2O2n = accpole + (accA2O2n_mag/accscale) * unitCentripO2;

pair unitCentripO4 = unit(pointO4 - pointA);
real accA4O4n_mag = (omega4^2) * length(pointA - pointO4);
pair pt_accA4O4n = accpole + (accA4O4n_mag/accscale) * unitCentripO4;

real accCor_mag = 2 * omega4 * velA2A4_mag;
pair pt_accCor = pt_accA2O2n + (accCor_mag/accscale) * unitPerpO4A;

path lineAt_A4O4 = pt_accA4O4n + 2000*unitPerpO4A -- pt_accA4O4n - 2000*unitPerpO4A;
path lineAt_A2A4 = pt_accCor + 2000*unitO4A -- pt_accCor - 2000*unitO4A;

pair[] accInters = intersectionpoints(lineAt_A4O4, lineAt_A2A4);
pair pt_accD = accInters[0];

real accA4O4t_mag = length(pt_accD - pt_accA4O4n) * accscale;
real alpha4 = accA4O4t_mag / length(pointA - pointO4);
real totalA4O4 = length(accpole - pt_accD) * accscale;

real rB = length(pointB - pointO4);
real accB_normal = (omega4^2) * rB;
real accB_tangent = alpha4 * rB;
real accB_total = sqrt(accB_normal^2 + accB_tangent^2);

write("a^n_{A2/O2} = " + string(accA2O2n_mag) + " mm/s^2");
write("a^n_{A4/O4} = " + string(accA4O4n_mag) + " mm/s^2");
write("a^c_{A2 A4} = " + string(accCor_mag) + " mm/s^2");
write("a^t_{A4/O4} = " + string(accA4O4t_mag) + " mm/s^2");
write("alpha4 = " + string(alpha4) + " rad/s^2");
write("a_{A4/O4} = " + string(totalA4O4) + " mm/s^2");
write("a^n_{B} = " + string(accB_normal) + " mm/s^2");
write("a^t_{B} = " + string(accB_tangent) + " mm/s^2");
write("a_{B} = " + string(accB_total) + " mm/s^2");

picture accDiagram;
draw(accDiagram, pointO4--pointO2, black+1.5pt+dashed);
dot(accDiagram, "$O_2$", pointO2, W);
dot(accDiagram, "$O_4$", pointO4, W);
draw(accDiagram, pointO2--pointA, black+1.5pt);
dot(accDiagram, "$A$", pointA, NE);
draw(accDiagram, pointO4--pointB, black+1.5pt);
dot(accDiagram, "$B$", pointB, NE);

fill(accDiagram, rectA, white);
draw(accDiagram, rectA, black+1.5pt);

label(accDiagram, "$4$", get_midpoint(pointO4, pointB), NE);
label(accDiagram, "$2$", get_midpoint(pointO2, pointA), NE);
label(accDiagram, "$1$", get_midpoint(pointO4, pointO2), NE);
label(accDiagram, "$3$", get_corner(pointA, 50, 30, get_angle(pointA-pointO4), 1), NE);

dot(accDiagram, "$o_2, o_4$", accpole, E);

draw(accDiagram, accpole--pt_accA2O2n, blue+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{A}^n_{A_2/O_2}$", get_midpoint(accpole, pt_accA2O2n), W);
dot(accDiagram, "$a^n_2$", pt_accA2O2n, NE);

draw(accDiagram, accpole--pt_accA4O4n, orange+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{A}^n_{A_4/O_4}$", get_midpoint(accpole, pt_accA4O4n), E);
dot(accDiagram, "$a^n_4$", pt_accA4O4n, SE);

draw(accDiagram, pt_accA2O2n--pt_accCor, red+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{A}^c_{A_2 A_4}$", get_midpoint(pt_accA2O2n, pt_accCor), NE);
dot(accDiagram, "$a^c_{43}$", pt_accCor, NW);

draw(accDiagram, pt_accA4O4n -- pt_accA4O4n + 400*unitPerpO4A, orange+dashed+1pt, Arrow(8));
label(accDiagram, "$\overset{?\checkmark}{A}^t_{A_4/O_4}$", pt_accA4O4n + 400*unitPerpO4A, SW);

draw(accDiagram, pt_accCor + 125*unitO4A -- pt_accCor - 125*unitO4A, blue+dashed+1pt);
label(accDiagram, "$\overset{?\checkmark}{A}^t_{A_2/A_4}$", pt_accCor - 125*unitO4A, SW);

dot(accDiagram, "$a_4, a_2$", pt_accD, SW);

draw(accDiagram, pt_accA4O4n--pt_accD, orange+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{A}^t_{A_4/O_4}$", get_midpoint(pt_accA4O4n, pt_accD), NE);

draw(accDiagram, pt_accCor--pt_accD, blue+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{A}^t_{A_2/A_4}$", get_midpoint(pt_accCor, pt_accD), SE);

draw(accDiagram, accpole--pt_accD, orange+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{A}_{A_4/O_4}$", get_midpoint(accpole, pt_accD)+(0,-5), SW);

pair unitBdir = unit(pointO4 - pointB);
pair unitBperp = unit(rotate(90)*(pointB - pointO4));

pair pt_accBn = accpole + (accB_normal/accscale) * unitBdir;
pair pt_accB_final = pt_accBn + (accB_tangent/accscale) * unitBperp;

draw(accDiagram, accpole--pt_accBn, purple+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{a}^n_{B}$", get_midpoint(accpole, pt_accBn), W);

draw(accDiagram, pt_accBn--pt_accB_final, purple+2pt, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{a}^t_{B}$", get_midpoint(pt_accBn, pt_accB_final), NE);

draw(accDiagram, accpole--pt_accB_final, purple+2pt+dashed, Arrow(8));
label(accDiagram, "$\overset{\checkmark\checkmark}{a}_{B}$", get_midpoint(accpole, pt_accB_final)+(5,5), E);
dot(accDiagram, "$B$", pt_accB_final, NE);

shipout("q3-2-acceleration", accDiagram, Portrait, "pdf", false, false);

string nl = "
";

string latex_content = 
"\documentclass[12pt]{article}" + nl +
"\usepackage{amsmath,amssymb}" + nl +
"\usepackage[margin=1in]{geometry}" + nl +
"\usepackage{graphicx}" + nl +
nl +
"\title{Velocity and Acceleration Analysis}" + nl +
"\author{}" + nl +
"\date{}" + nl +
nl +
"\begin{document}" + nl +
nl +
"\maketitle" + nl +
nl +
"\section*{Problem Description}" + nl +
nl +
"This document presents the velocity and acceleration analysis of a four-bar linkage mechanism using both graphical (Asymptote diagrams) and analytical methods." + nl +
nl +
"\section*{Generated Diagrams}" + nl +
nl +
"The analysis produces three separate diagrams from a single Asymptote file (\texttt{q3-2.asy}):" + nl +
nl +
"\begin{enumerate}" + nl +
"  \item \textbf{q3-2-space.pdf} — Mechanism geometry showing the spatial configuration of all links and pivot points" + nl +
"  \item \textbf{q3-2-velocity.pdf} — Velocity polygon diagram using graphical analysis methods" + nl +
"  \item \textbf{q3-2-acceleration.pdf} — Acceleration polygon diagram using graphical analysis methods" + nl +
"\end{enumerate}" + nl +
nl +
"\section*{Analysis Results}" + nl +
nl +
"\subsection*{Point B Location}" + nl +
nl +
"The slider point $B$ is located at:" + nl +
"$$B = (" + format("%.10f", pointB.x) + ", " + format("%.10f", pointB.y) + ") \text{ mm}$$" + nl +
nl +
"\subsection*{Velocity Analysis}" + nl +
nl +
"The input link (link 2) rotates at a constant angular velocity (60 RPM)." + nl +
nl +
"\begin{table}[h]" + nl +
"\centering" + nl +
"\begin{tabular}{|l|r|}" + nl +
"\hline" + nl +
"\textbf{Parameter} & \textbf{Value} \\\\" + nl +
"\hline" + nl +
"$\omega_2$ (Input angular velocity) & " + format("%.14f", omega2) + " rad/s \\\\" + nl +
"$v_{A_2/O_2}$ (Velocity at $A$ on link 2) & " + format("%.14f", velA2O2_mag) + " mm/s \\\\" + nl +
"$v_{A_4/O_4}$ (Velocity at $A$ on link 4) & " + format("%.14f", velA4O4_mag) + " mm/s \\\\" + nl +
"$v_{A_2/A_4}$ (Relative velocity) & " + format("%.14f", velA2A4_mag) + " mm/s \\\\" + nl +
"$\omega_4$ (Angular velocity of link 4) & " + format("%.14f", omega4) + " rad/s \\\\" + nl +
"\hline" + nl +
"\end{tabular}" + nl +
"\caption{Velocity Analysis Results}" + nl +
"\end{table}" + nl +
nl +
"\subsection*{Acceleration Analysis}" + nl +
nl +
"\begin{table}[h]" + nl +
"\centering" + nl +
"\begin{tabular}{|l|r|}" + nl +
"\hline" + nl +
"\textbf{Parameter} & \textbf{Value} \\\\" + nl +
"\hline" + nl +
"$a^n_{A_2/O_2}$ (Centripetal acceleration at $A$ on link 2) & " + format("%.14f", accA2O2n_mag) + " mm/s$^2$ \\\\" + nl +
"$a^n_{A_4/O_4}$ (Centripetal acceleration at $A$ on link 4) & " + format("%.14f", accA4O4n_mag) + " mm/s$^2$ \\\\" + nl +
"$a^c_{A_2/A_4}$ (Coriolis acceleration) & " + format("%.14f", accCor_mag) + " mm/s$^2$ \\\\" + nl +
"$a^t_{A_4/O_4}$ (Tangential acceleration at $A$ on link 4) & " + format("%.14f", accA4O4t_mag) + " mm/s$^2$ \\\\" + nl +
"$\alpha_4$ (Angular acceleration of link 4) & " + format("%.14f", alpha4) + " rad/s$^2$ \\\\" + nl +
"$a_{A_4/O_4}$ (Total acceleration at $A$ on link 4) & " + format("%.14f", totalA4O4) + " mm/s$^2$ \\\\" + nl +
"\hline" + nl +
"\end{tabular}" + nl +
"\caption{Acceleration Analysis Results}" + nl +
"\end{table}" + nl +
nl +
"\subsection*{Slider Point B Acceleration}" + nl +
nl +
"At the slider point $B$:" + nl +
nl +
"\begin{table}[h]" + nl +
"\centering" + nl +
"\begin{tabular}{|l|r|}" + nl +
"\hline" + nl +
"\textbf{Component} & \textbf{Value} \\\\" + nl +
"\hline" + nl +
"$a^n_B$ (Normal acceleration component) & " + format("%.14f", accB_normal) + " mm/s$^2$ \\\\" + nl +
"$a^t_B$ (Tangential acceleration component) & " + format("%.14f", accB_tangent) + " mm/s$^2$ \\\\" + nl +
"$a_B$ (Total acceleration magnitude) & " + format("%.14f", accB_total) + " mm/s$^2$ \\\\" + nl +
"\hline" + nl +
"\end{tabular}" + nl +
"\caption{Point B Acceleration}" + nl +
"\end{table}" + nl +
nl +
"\section*{Key Relationships}" + nl +
nl +
"The analysis is based on the following kinematic relationships:" + nl +
nl +
"\textbf{Velocity:}" + nl +
"\begin{align*}" + nl +
"v &= \omega \cdot r \\\\" + nl +
"v_{rel} &= v_1 - v_2" + nl +
"\end{align*}" + nl +
nl +
"\textbf{Acceleration (components):}" + nl +
"\begin{align*}" + nl +
"a^n &= \omega^2 \cdot r \quad \text{(centripetal)} \\\\" + nl +
"a^t &= \alpha \cdot r \quad \text{(tangential)} \\\\" + nl +
"a^c &= 2\omega_1 \cdot v_{rel} \quad \text{(Coriolis)} \\\\" + nl +
"a_{total} &= \sqrt{(a^n)^2 + (a^t)^2}" + nl +
"\end{align*}" + nl +
nl +
"\section*{Notes}" + nl +
nl +
"\begin{itemize}" + nl +
"  \item All distances are measured in millimeters (mm)" + nl +
"  \item All velocities are in mm/s" + nl +
"  \item All accelerations are in mm/s$^2$" + nl +
"  \item All angular quantities are in radians per second (rad/s) or rad/s$^2$" + nl +
"  \item The mechanism analysis assumes constant input angular velocity" + nl +
"  \item Point $A$ is the connection between links 2 and 4" + nl +
"  \item Point $B$ is the slider constrained to move along link 4" + nl +
"\end{itemize}" + nl +
nl +
"\end{document}";

file out = output("values.tex");
write(out, latex_content);
close(out);

string nl = "
";

string output_text = "=== Velocity and Acceleration Analysis ===" + nl +
nl +
"POINT B LOCATION:" + nl +
"B = (" + format("%.10f", pointB.x) + ", " + format("%.10f", pointB.y) + ") mm" + nl +
nl +
"VELOCITY VALUES:" + nl +
"omega2 = " + format("%.14f", omega2) + " rad/s" + nl +
"v_{A2/O2} = " + format("%.14f", velA2O2_mag) + " mm/s" + nl +
"v_{A4/O4} = " + format("%.14f", velA4O4_mag) + " mm/s" + nl +
"v_{A2/A4} = " + format("%.14f", velA2A4_mag) + " mm/s" + nl +
"omega4 = " + format("%.14f", omega4) + " rad/s" + nl +
nl +
"ACCELERATION VALUES:" + nl +
"a^n_{A2/O2} = " + format("%.14f", accA2O2n_mag) + " mm/s^2" + nl +
"a^n_{A4/O4} = " + format("%.14f", accA4O4n_mag) + " mm/s^2" + nl +
"a^c_{A2/A4} = " + format("%.14f", accCor_mag) + " mm/s^2" + nl +
"a^t_{A4/O4} = " + format("%.14f", accA4O4t_mag) + " mm/s^2" + nl +
"alpha4 = " + format("%.14f", alpha4) + " rad/s^2" + nl +
"a_{A4/O4} = " + format("%.14f", totalA4O4) + " mm/s^2" + nl +
nl +
"POINT B ACCELERATION:" + nl +
"a^n_{B} = " + format("%.14f", accB_normal) + " mm/s^2" + nl +
"a^t_{B} = " + format("%.14f", accB_tangent) + " mm/s^2" + nl +
"a_{B} = " + format("%.14f", accB_total) + " mm/s^2" + nl;

file outtxt = output("q3-2-values.txt");
write(outtxt, output_text);
close(outtxt);

