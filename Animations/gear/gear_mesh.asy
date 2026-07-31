settings.outformat = "pdf";
settings.render = -1;

// ============= GEOMETRY UTILITY FUNCTIONS =============

pair[] pathIntersection(path p, path q) {
  real[][] params = intersections(p, q);
  pair[] points;
  for (int i = 0; i < params.length; ++i) {
    real t_p = params[i][0];
    pair pt = point(p, t_p);
    points.push(pt);
  }
  return points;
}

pair tangentPointToCircle(pair O, real r, pair P, string side) {
  real d = length(P - O);
  pair dir_OP = unit(P - O);
  pair helper_center = O + d/2 * dir_OP;
  real helper_radius = d/2;
  real a_sq = r * r;
  real b_sq = helper_radius * helper_radius;
  real c = d/2;
  real x = (a_sq - b_sq + c*c) / (2*c);
  real h_sq = a_sq - x*x;
  if (h_sq < 0) h_sq = 0;
  real h = sqrt(h_sq);
  pair T1 = O + (x*dir_OP + h*rotate(90, O)*dir_OP);
  pair T2 = O + (x*dir_OP - h*rotate(90, O)*dir_OP);
  return (side == "left") ? T1 : T2;
}

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

// ============= MAIN GEAR PROFILE FUNCTION WITH ROTATION =============

void drawGear(pair center, real rb, real ra, real tp, real rp, real phi_rad, 
              pair ptP, pair ptP1, int numTeeth, real rd, real rotationAngle = 0, int num_points = 100) {
  
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
    
    // Dedendum connections: to dedendum and arc to next tooth
    gear_profile = gear_profile--pointOnCircle(center, rd, angle_right_base);
    path bottom_arc = arc(center, rd * 1mm, degrees(angle_right_base), degrees(angle_next_left));
    gear_profile = gear_profile--bottom_arc;
  }
  
  gear_profile = gear_profile--cycle;
  fill(gear_profile, lightgray + opacity(0.5));
  draw(gear_profile, black + 1.5pt);
}

// ============= ANIMATION SETUP =============

int numTeeth = 22;
real phi = 20, rp = 132;
real m = 2 * rp / numTeeth;
real rb = rp * cos(radians(phi));
real ra = rp + 1 * m;
real rd = rp - 1.25 * m;
real p = 2 * pi * rp / numTeeth;
real tp = p / 2;

pair center = (200mm, 200mm);

// Initial P1 and P points (for static frame reference)
real angle_initial = 100 * pi / 180;
path pitchCircle = circle(center, rp * 1mm);
pair ptR_initial = center + 1.2 * rb * 1mm * dir(angle_initial);
pair[] ptP1_initial = pathIntersection(pitchCircle, center--ptR_initial);
pair ptP1 = ptP1_initial[0];
real angle_P1 = atan2(ptP1.y - center.y, ptP1.x - center.x);
real angle_P = angle_P1 + (tp / 2) / rp;
pair ptP = pointOnCircle(center, rp, angle_P);

// Direction to meshing point
real angle_to_P = atan2(ptP.y - center.y, ptP.x - center.x);
pair center2 = center + 2 * rp * 1mm * (cos(angle_to_P), sin(angle_to_P));
real angle_P1_gear2 = angle_to_P - (tp / 2) / rp;
pair ptP1_gear2 = pointOnCircle(center2, rp, angle_P1_gear2);

// ============= ANIMATION FRAMES =============

int numFrames = 36;  // 10 degree increments for smooth animation

for (int frame = 0; frame < numFrames; ++frame) {
  real angle_increment = 360.0 / numFrames * frame;
  
  // Create new frame
  newpage();
  
  path boundary = square((0, 0), 400mm);
  draw(boundary, dashed + gray);
  
  dot("$O_1$", center, SW);
  dot("$O_2$", center2, NE);
  
  // Draw reference circles (light)
  draw(circle(center, rb * 1mm), dashed + red + opacity(0.3));
  draw(circle(center, rp * 1mm), dashed + blue + opacity(0.3));
  draw(circle(center, ra * 1mm), dashed + orange + opacity(0.3));
  draw(circle(center, rd * 1mm), dashed + cyan + opacity(0.3));
  
  draw(circle(center2, rb * 1mm), dashed + red + opacity(0.3));
  draw(circle(center2, rp * 1mm), dashed + blue + opacity(0.3));
  draw(circle(center2, ra * 1mm), dashed + orange + opacity(0.3));
  draw(circle(center2, rd * 1mm), dashed + cyan + opacity(0.3));
  
  // Center line
  draw(center--center2, 0.5pt + gray + dashed);
  
  // Draw gears with rotation
  // Gear 1 rotates counterclockwise
  drawGear(center, rb, ra, tp, rp, radians(phi), ptP, ptP1, numTeeth, rd, angle_increment);
  
  // Gear 2 rotates clockwise (opposite direction)
  drawGear(center2, rb, ra, tp, rp, radians(phi), ptP, ptP1_gear2, numTeeth, rd, -angle_increment);
  
  // Mark meshing point
  dot("$P_{mesh}$", ptP, N);
  
  // Add frame label
  label("Frame: " + string(frame + 1) + "/" + string(numFrames), (200mm, 20mm), black);
}
