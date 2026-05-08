settings.outformat = "pdf";
import fontsize;
import geometry;
include "../Grears/Involutometry/geometry_utils.asy";

// ============= CORE MATHEMATICAL FUNCTIONS =============

real involute(real alpha_rad) {
  return tan(alpha_rad) - alpha_rad;
}

real pressureAngleAtRadius(real rb, real r) {
  return (r < rb) ? 0 : acos(rb / r);
}

real toothThicknessAtRadius(real r, real tp, real rp, real phi_rad, real rb) {
  real psi = pressureAngleAtRadius(rb, r);
  return 2 * r * (tp / (2 * rp) + involute(phi_rad) - involute(psi));
}

// ============= HELPER FUNCTIONS FOR DRAWING =============

pair pointOnCircle(pair center, real radius, real angle) {
  return center + radius * 1mm * (cos(angle), sin(angle));
}

void drawCircle(pair center, real radius, string label, pen style, real angle_label = 100) {
  draw(circle(center, radius * 1mm), style);
  if (label != "") dot(label, center + 1.2 * radius * 1mm * dir(angle_label), N);
}

void drawLine(pair p1, pair p2, pen style, string label = "", real label_angle = 0) {
  draw(p1--p2, style);
  if (label != "") dot(label, p1 + 0.6 * (p2 - p1), dir(label_angle));
}

// ============= MAIN GEAR PROFILE FUNCTION WITH ROTATION =============

void drawGear(pair center, real rb, real ra, real tp, real rp, real phi_rad, 
              pair ptP, pair ptP1, int numTeeth, real rd, real rotationAngle = 0, int num_points = 100) {
  
  real tooth_angle = 360 / numTeeth;
  real r_end = (rb < rd) ? rd : ra;
  
  path gear_profile;
  
  for (int tooth_num = 0; tooth_num < numTeeth; ++tooth_num) {
    real rotation = tooth_num * tooth_angle + rotationAngle * 180 / pi;
    pair rotated_P = rotate(rotation, center) * ptP;
    pair rotated_P1 = rotate(rotation, center) * ptP1;
    
    real angle_P1 = atan2(rotated_P1.y - center.y, rotated_P1.x - center.x);
    
    // Calculate base circle angles
    real half_angle_base = toothThicknessAtRadius(rb, tp, rp, phi_rad, rb) / (2 * rb);
    real angle_left_base = angle_P1 - half_angle_base;
    real angle_right_base = angle_P1 + half_angle_base;
    real angle_next_left = angle_P1 + radians(tooth_angle) - half_angle_base;
    
    // Initialize profile on first tooth
    if (tooth_num == 0) {
      gear_profile = pointOnCircle(center, rb, angle_left_base);
    }
    
    // Left involute: from rb to r_end
    for (int i = 0; i <= num_points; ++i) {
      real r = rb + (r_end - rb) * i / num_points;
      real psi = acos(rb / r);
      real half_angle = toothThicknessAtRadius(r, tp, rp, phi_rad, rb) / (2 * r);
      gear_profile = gear_profile--pointOnCircle(center, r, angle_P1 - half_angle);
    }
    
    // Addendum arc (top)
    real psi_end = acos(rb / r_end);
    real half_angle_end = toothThicknessAtRadius(r_end, tp, rp, phi_rad, rb) / (2 * r_end);
    path top_arc = arc(center, r_end * 1mm, degrees(angle_P1 - half_angle_end), degrees(angle_P1 + half_angle_end));
    gear_profile = gear_profile--top_arc;
    
    // Right involute reversed: from r_end to rb
    for (int i = num_points; i >= 0; --i) {
      real r = rb + (r_end - rb) * i / num_points;
      real psi = acos(rb / r);
      real half_angle = toothThicknessAtRadius(r, tp, rp, phi_rad, rb) / (2 * r);
      gear_profile = gear_profile--pointOnCircle(center, r, angle_P1 + half_angle);
    }
    
    // Dedendum connections: to dedendum and arc to next tooth
    gear_profile = gear_profile--pointOnCircle(center, rd, angle_right_base);
    path bottom_arc = arc(center, rd * 1mm, degrees(angle_right_base), degrees(angle_next_left));
    gear_profile = gear_profile--bottom_arc;
  }
  
  gear_profile = gear_profile--cycle;
  fill(gear_profile, lightgray + opacity(0.5));
  draw(gear_profile, black + 1.5pt);
}

// ============= FRAME 15 ANIMATION =============

int numTeeth = 22;
real phi = 20, rp = 132;
real m = 2 * rp / numTeeth;
real rb = rp * cos(radians(phi));
real ra = rp + 1 * m;
real rd = rp - 1.25 * m;
real p = 2 * pi * rp / numTeeth;
real tp = p / 2;

pair center = (200mm, 200mm);
pair center2 = center + 2 * rp * 1mm * (1, 0);

// Animation rotation
real frameAngle = 3.9269908169872414;

// Reference points for meshing
pair ptP = center + rp * 1mm * (1, 0);
pair ptP1 = center + rp * 1mm * (cos(tp / rp), sin(tp / rp));
pair ptP_gear2 = ptP;
real angle_P1_gear2 = atan2(ptP_gear2.y - center2.y, ptP_gear2.x - center2.x) - (tp / 2) / rp;
pair ptP1_gear2 = pointOnCircle(center2, rp, angle_P1_gear2);

// Draw both gears with rotation
drawGear(center, rb, ra, tp, rp, radians(phi), ptP, ptP1, numTeeth, rd, frameAngle);
drawGear(center2, rb, ra, tp, rp, radians(phi), ptP_gear2, ptP1_gear2, numTeeth, rd, -frameAngle);

// Reference circles
drawCircle(center, rb, "", dashed + red, 100);
drawCircle(center, rp, "", dashed + blue, 100);
drawCircle(center, ra, "", dashed + orange, 100);
drawCircle(center, rd, "", dashed + cyan, 100);

drawCircle(center2, rb, "", dashed + red, 100);
drawCircle(center2, rp, "", dashed + blue, 100);
drawCircle(center2, ra, "", dashed + orange, 100);
drawCircle(center2, rd, "", dashed + cyan, 100);

// Mark centers and meshing point
dot("$O_1$", center, S);
dot("$O_2$", center2, S);
dot("$P$", ptP, N);
draw(center--center2, 0.5pt + gray + dashed);
