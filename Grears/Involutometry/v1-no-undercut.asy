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

// Function to draw involute curve using tooth thickness formula
// Left involute passes through P (left edge of tooth)
// Right involute passes through P1 (right edge = tooth center)
// P1 is the middle of tooth width (no separate reference line needed)
// t = 2r [tp/(2*rp) + inv(φ) - inv(ψ)]
void drawInvoluteCurve(pair center, real rb, real ra, real tp, real rp, real phi_rad, pair ptP, pair ptP1, int num_points = 100) {
  
  // Angle to P1 on pitch circle (tooth center)
  real angle_P1 = atan2(ptP1.y - center.y, ptP1.x - center.x);
  
  // Create two involute profiles (left and right sides of tooth)
  path involute_left, involute_right;
  
  for (int i = 0; i <= num_points; ++i) {
    // Sweep from base circle to addendum circle
    real r = rb + (ra - rb) * i / num_points;
    
    if (r >= rb) {
      // Calculate pressure angle ψ at radius r
      real psi = acos(rb / r);
      
      // Calculate tooth thickness at radius r using formula:
      // t = 2*r * [tp/(2*rp) + inv(φ) - inv(ψ)]
      real tooth_thickness = 2 * r * (tp / (2 * rp) + involute(phi_rad) - involute(psi));
      
      // Convert thickness to angle at this radius: half_angle = (t/2) / r
      real half_angle = tooth_thickness / (2 * r);
      
      // Tooth center is at angle_P1 (constant reference line along P1)
      // Left side passes through P at pitch circle
      real angle_left = angle_P1 - half_angle;
      real x_left = center.x + r * 1mm * cos(angle_left);
      real y_left = center.y + r * 1mm * sin(angle_left);
      involute_left = involute_left--(x_left, y_left);
      
      // Right side passes through P1 (tooth center)
      real angle_right = angle_P1 + half_angle;
      real x_right = center.x + r * 1mm * cos(angle_right);
      real y_right = center.y + r * 1mm * sin(angle_right);
      involute_right = involute_right--(x_right, y_right);
    }
  }
  
  // Draw both sides of the involute profile
  draw(involute_left, black+1.5pt);
  draw(involute_right, black+1.5pt);
}

// Function to replicate a tooth profile at all gear positions
// Takes one defined tooth profile and the reference line orientation
// Duplicates the tooth around the gear center at equal angular intervals
void replicateToothProfile(pair center, real rb, real ra, real tp, real rp, real phi_rad, 
                           pair ptP, pair ptP1, int numTeeth, int num_points = 100) {
  // Angular spacing between teeth (in degrees)
  real tooth_angle = 360 / numTeeth;
  
  // Draw each tooth at its angular position
  for (int tooth_num = 0; tooth_num < numTeeth; ++tooth_num) {
    // Rotation angle for this tooth
    real rotation_angle = tooth_num * tooth_angle;
    
    // Rotate center points to this tooth position
    pair rotated_ptP = rotate(rotation_angle, center) * ptP;
    pair rotated_ptP1 = rotate(rotation_angle, center) * ptP1;
    
    // Draw the involute profiles for this tooth
    real angle_P1 = atan2(rotated_ptP1.y - center.y, rotated_ptP1.x - center.x);
    
    path involute_left, involute_right;
    
    for (int i = 0; i <= num_points; ++i) {
      real r = rb + (ra - rb) * i / num_points;
      
      if (r >= rb) {
        real psi = acos(rb / r);
        real tooth_thickness = 2 * r * (tp / (2 * rp) + involute(phi_rad) - involute(psi));
        real half_angle = tooth_thickness / (2 * r);
        
        // Left involute
        real angle_left = angle_P1 - half_angle;
        real x_left = center.x + r * 1mm * cos(angle_left);
        real y_left = center.y + r * 1mm * sin(angle_left);
        involute_left = involute_left--(x_left, y_left);
        
        // Right involute
        real angle_right = angle_P1 + half_angle;
        real x_right = center.x + r * 1mm * cos(angle_right);
        real y_right = center.y + r * 1mm * sin(angle_right);
        involute_right = involute_right--(x_right, y_right);
      }
    }
    
    draw(involute_left, black+1.5pt);
    draw(involute_right, black+1.5pt);
  }
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
pair ptR = center + 1.2*rb*1mm*dir(100);
path lineCenter_R = center--ptR;
draw(lineCenter_R, 1pt+black+dashed);
dot("$R$", ptR, N);

// Pitch circle (defines tooth profile reference)
path pitchCircle = circle(center, rp * 1mm);
draw(pitchCircle, dashed+blue);

// measuring thickness of tooth at pitch circle
pair[] ptP1 = pathIntersection(pitchCircle, lineCenter_R);
dot("$P_1$", ptP1[0], NE);

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
pair ptP_ref = center + 1.2*rb*1mm*dir(degrees(angle_P));
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

// Draw involute curve from base circle through P (left) and P1 (right) to addendum circle using tooth thickness formula
// Option 1: Draw single tooth profile (for analysis)
// drawInvoluteCurve(center, rb, ra, tp, rp, radians(phi), ptP, ptP1[0]);

// Option 2: Draw all 22 teeth replicated around the gear
replicateToothProfile(center, rb, ra, tp, rp, radians(phi), ptP, ptP1[0], numTeeth);

