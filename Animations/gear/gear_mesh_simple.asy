// Animated Gear Mesh - Proper Multi-Page Animation
settings.outformat = "pdf";
settings.render = 0;  // Disable 3D rendering

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

// ============= HELPER FUNCTIONS =============

pair pointOnCircle(pair center, real radius, real angle) {
  return center + radius * 1mm * (cos(angle), sin(angle));
}

// ============= MAIN GEAR PROFILE WITH ROTATION =============

void drawGear(pair center, real rb, real ra, real tp, real rp, real phi_rad, 
              pair ptP, pair ptP1, int numTeeth, real rd, real rotationAngle = 0, int num_points = 40) {
  
  real tooth_angle = 360 / numTeeth;
  real r_end = (rb < rd) ? rd : ra;
  
  path gear_profile;
  
  for (int tooth_num = 0; tooth_num < numTeeth; ++tooth_num) {
    real rotation = tooth_num * tooth_angle + rotationAngle;
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
    
    // Dedendum connections
    gear_profile = gear_profile--pointOnCircle(center, rd, angle_right_base);
    path bottom_arc = arc(center, rd * 1mm, degrees(angle_right_base), degrees(angle_next_left));
    gear_profile = gear_profile--bottom_arc;
  }
  
  gear_profile = gear_profile--cycle;
  fill(gear_profile, lightgray + opacity(0.5));
  draw(gear_profile, black + 1.5pt);
}

// ============= MAIN ANIMATION SETUP =============

int numTeeth = 22;
real phi = 20, rp = 132;
real m = 2 * rp / numTeeth;
real rb = rp * cos(radians(phi));
real ra = rp + 1 * m;
real rd = rp - 1.25 * m;
real p = 2 * pi * rp / numTeeth;
real tp = p / 2;

pair center = (200mm, 200mm);

// Initial setup for gear geometry
real angle_initial = 100 * pi / 180;
pair ptP = pointOnCircle(center, rp, angle_initial + (tp / 2) / rp);
pair ptP1 = pointOnCircle(center, rp, angle_initial);

// Meshing point angle
real angle_to_P = atan2(ptP.y - center.y, ptP.x - center.x);
pair center2 = center + 2 * rp * 1mm * (cos(angle_to_P), sin(angle_to_P));
real angle_P1_gear2 = angle_to_P - (tp / 2) / rp;
pair ptP1_gear2 = pointOnCircle(center2, rp, angle_P1_gear2);

// ============= GENERATE ANIMATION FRAMES =============

int numFrames = 36;

for (int frame = 0; frame < numFrames; ++frame) {
  real angle_increment = 360.0 / numFrames * frame;
  
  // Draw frame boundary
  draw((0, 0)--(400mm, 0)--(400mm, 400mm)--(0, 400mm)--cycle, dashed + gray);
  
  // Draw gears with opposite rotations
  drawGear(center, rb, ra, tp, rp, radians(phi), ptP, ptP1, numTeeth, rd, angle_increment);
  drawGear(center2, rb, ra, tp, rp, radians(phi), ptP, ptP1_gear2, numTeeth, rd, -angle_increment);
  
  // Marks
  dot(center, 4pt + black);
  dot(center2, 4pt + black);
  draw(center--center2, 0.5pt + gray + dashed);
  dot(ptP, 4pt + red);
  
  label("Frame " + string(frame + 1) + "/" + string(numFrames), (20mm, 20mm), black);
}
