settings.outformat = "pdf";
import fontsize;
import geometry;
include "geometry_utils.asy";

// Function to position a point P on a circle such that arc P1-P = tp
// Parameters:
//   center: center of the circle
//   radius: radius of the circle (in mm)
//   ptP1: point P1 on the circle
//   arc_length: desired arc length from P1 to P
// Returns: pair representing the position of P
pair positionPointByArcLength(pair center, real radius, pair ptP1, real arc_length) {
  real theta_rad = arc_length / radius; // Angle in radians
  real theta_deg = degrees(theta_rad); // Convert to degrees
  real angle_P1_deg = angle(ptP1 - center); // Angle of P1 from center
  real angle_P_deg = angle_P1_deg - theta_deg; // P is on left side (closer to P1)
  pair ptP = center + radius * 1mm * dir(angle_P_deg);
  return ptP;
}

// Involute function: inv(α) = tan(α) - α
// α is in radians
real involute(real alpha_rad) {
  return tan(alpha_rad) - alpha_rad;
}

// Calculate the pressure angle ψ at radius r
// ψ = arccos(rb / r), where rb is base radius and r is the radius at which to calculate
real pressureAngleAtRadius(real rb, real r) {
  if (r < rb) {
    write("Error: radius r must be >= rb (base radius)");
    return 0;
  }
  return acos(rb / r);
}

// Calculate tooth thickness at radius r using the involute formula:
// t = 2*r * [tp/(2*rp) + inv(φ) - inv(ψ)]
// Where:
//   t = tooth thickness at radius r
//   r = radius at which to calculate thickness
//   tp = tooth thickness at pitch circle
//   rp = pitch radius
//   φ = pressure angle (in radians)
//   ψ = pressure angle at radius r
real toothThicknessAtRadius(real r, real tp, real rp, real phi_rad, real rb) {
  real psi = pressureAngleAtRadius(rb, r);
  real thickness = 2 * r * (tp / (2 * rp) + involute(phi_rad) - involute(psi));
  return thickness;
}

// Function to draw involute curve using proper parametric equations
// Involute: x = rb(cos(t + offset) + t·sin(t + offset)), y = rb(sin(t + offset) - t·cos(t + offset))
// We solve for 'offset' so the involute passes through point P
void drawInvoluteCurve(pair center, real rb, real ra, real tp, real rp, real phi_rad, pair ptP, int num_points = 100) {
  // Calculate parameter t at pitch circle
  real t_p = sqrt((rp / rb)^2 - 1);
  
  // Calculate parameter t at addendum circle
  real t_a = sqrt((ra / rb)^2 - 1);
  
  // Find angle offset so involute passes through P
  // At t = t_p, the involute point is: (rb(cos(t_p + offset) + t_p·sin(t_p + offset)), rb(sin(t_p + offset) - t_p·cos(t_p + offset)))
  // This should equal P
  real dx = (ptP.x - center.x) / (rb * 1mm);
  real dy = (ptP.y - center.y) / (rb * 1mm);
  
  // Solve for angle offset using atan2
  // From involute: x = cos(angle) + t·sin(angle), y = sin(angle) - t·cos(angle) at t = t_p
  // Where angle = t_p + offset
  // We can derive: offset = atan2(dy + t_p*dx, dx - t_p*dy) - t_p
  real angle_offset = atan2(dy + t_p * dx, dx - t_p * dy) - t_p;
  
  path involutePath;
  
  for (int i = 0; i <= num_points; ++i) {
    real t = t_p * i / num_points * (t_a / t_p); // Sweep from t=0 at base toward t=t_a at addendum
    real angle = angle_offset + t;
    real x = center.x + (rb * 1mm) * (cos(angle) + t * sin(angle));
    real y = center.y + (rb * 1mm) * (sin(angle) - t * cos(angle));
    involutePath = involutePath--(x, y);
  }
  
  draw(involutePath, black+1.5pt);
}


int numTeeth = 22; // Number of teeth
real phi = 20; // Pressure angle in degrees
real rp = 132; // Pitch radius in mm
real m = 2 * rp / numTeeth; // Module in mm
real P = 1 / m; // Diametral pitch (teeth per unit diameter)
real rb = rp * cos(radians(phi)); // Base circle radius in mm (convert degrees to radians)
real a = 1 * m; // Addendum in mm (standard full depth)
real ra = rp + a; // Addendum circle radius in mm
real d = 1.25 * m; // Dedendum in mm (standard full depth)
real rd = rp - d; // Dedendum circle radius in mm
real p = 2 * pi * rp / numTeeth; // Circular pitch in mm (≈ 37.68 mm/tooth)
real tp = p / 2; // Half pitch (tooth half-thickness at pitch circle)

write("Pitch radius: " + string(rp) + " mm");
write("Base circle radius: " + string(rb) + " mm");
write("Number of teeth: " + string(numTeeth));
write("Addendum circle radius: " + string(ra) + " mm");
write("Dedendum circle radius: " + string(rd) + " mm");
write("Circular pitch: " + string(p) + " mm");
write("Target half-thickness (tp): " + string(tp) + " mm");
// Setup canvas
path boundary = square((0, 0), 400mm);
draw(boundary, dashed+gray);

pair center = (200mm, 200mm);
dot("$O$", center, S);

// Base circle (for involute profile)
path baseCircle = circle(center, rb * 1mm);
draw(baseCircle, dashed+red);

// Reference central line passing via center (vertical)
pair ptR = center + 4*rb*1mm*dir(100);
path lineCenter_R = center--ptR;
draw(lineCenter_R, 1pt+black);
dot("$R$", ptR, N);

// Pitch circle (defines tooth profile reference)
path pitchCircle = circle(center, rp * 1mm);
draw(pitchCircle, dashed+blue);

// measuring thickness of tooth at pitch circle
pair[] ptP1 = pathIntersection(pitchCircle, lineCenter_R);
dot("$P_1$", ptP1[0], SE);

// Calculate angle from center to P1
real angle_P1 = atan2(ptP1[0].y - center.y, ptP1[0].x - center.x);

// Arc length tp/2 corresponds to angle: angle = arc_length / radius
real theta_half_tooth = (tp / 2) / rp; // Angle in radians for half tooth thickness

// P is at angle_P1 + theta_half_tooth (clockwise from P1, which is to the right)
real angle_P = angle_P1 + theta_half_tooth;

// Position P on the pitch circle
pair ptP = center + rp * 1mm * (cos(angle_P), sin(angle_P));
dot("$P$", ptP, SW);

// pitch point reference line - now passes through P
pair ptP_ref = center + 4*rb*1mm*dir(degrees(angle_P));
path lineCenter_P = center--ptP_ref;
draw(lineCenter_P, 1pt+black+dashed);
dot("$P_{ref}$", ptP_ref, N);

// Tangent to base circle on left, passing via P (now using correct P position)
pair ptT_left = tangentPointToCircle(center, rb * 1mm, ptP, "left");
dot("$T_p$", ptT_left, E);

// Extend line from T through P
pair dir_TP = unit(ptP - ptT_left);
pair ptExtended = ptP + 50mm * dir_TP;
draw(ptT_left--ptExtended, black+0.5pt);

// line from T to O
path lineT_O = ptT_left--center;
draw(lineT_O, 0.5pt+green);

// addendum circle (for visual reference)
path addendumCircle = circle(center, ra * 1mm);
draw(addendumCircle, dashed+orange);

// dendendum circle (for visual reference)
path dedendumCircle = circle(center, rd * 1mm); 
draw(dedendumCircle, dashed+cyan);

// intersection of line T-O with addendum circle
pair[] intersectionsAddendum = pathIntersection(addendumCircle, lineCenter_R);   
pair ptAddendum = (intersectionsAddendum.length > 1) ? intersectionsAddendum[1] : intersectionsAddendum[0];
dot("$A$", ptAddendum, NE);

real arc_length = tp / 2; // By construction, arc should equal tp/2
write("Arc length from P1 to P: " + string(arc_length) + " mm");

// Draw involute curve from base circle through P to addendum circle using proper involute parametric equations
drawInvoluteCurve(center, rb, ra, tp, rp, radians(phi), ptP);