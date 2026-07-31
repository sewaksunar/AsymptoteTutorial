import graph;

// Uncomment the following 2 lines to support pdf animations:
usepackage("animate");
settings.tex="pdflatex";

import animation;
import geometry;

size(0,600);

import fontsize;
defaultpen(fontsize(12pt)+1);
dotfactor=3;

// Gear parameters
int numTeeth = 22;
real phi = 20; // pressure angle in degrees
real rp = 132; // pitch radius in mm
real ra = rp + 12; // addendum radius
real rb = rp * cos(radians(phi)); // base radius
real rd = rp - 15; // dedendum radius
real tp = 2 * pi * rp / numTeeth; // tooth pitch

// Involute function
real involute(real alpha_rad) {
  return tan(alpha_rad) - alpha_rad;
}

// Draw a single gear tooth profile
path drawToothProfile(real centerX, real centerY, real toothIndex, real rotation) {
  path tooth = nullpath;
  
  // Pressure angle at pitch circle
  real alphap = acos(rb / rp) * 180 / pi;
  
  // Create involute curve for one side of tooth
  int numPoints = 50;
  for (int i = 0; i < numPoints; ++i) {
    real alpha = i * (alphap / (numPoints - 1)) * pi / 180;
    real angle_base = toothIndex * 2 * pi / numTeeth + rotation + alpha;
    real r = rb / cos(alpha);
    real x = centerX + r * cos(angle_base);
    real y = centerY + r * sin(angle_base);
    
    if (i == 0) {
      tooth = (x, y);
    } else {
      tooth = tooth -- (x, y);
    }
  }
  
  return tooth;
}

// Draw complete gear
void drawGear(real centerX, real centerY, real rotation) {
  draw(shift(centerX, centerY) * circle((0,0), rp), 0.5*black); // pitch circle
  
  // Draw each tooth
  for (int i = 0; i < numTeeth; ++i) {
    path tooth_pos = drawToothProfile(centerX, centerY, i, rotation);
    path tooth_neg = drawToothProfile(centerX, centerY, i, rotation + pi / numTeeth);
    
    draw(tooth_pos, black);
    draw(reflect((centerX, centerY), (centerX + 1, centerY)) * tooth_neg, black);
  }
  
  draw(shift(centerX, centerY) * circle((0,0), rb), 0.3*gray); // base circle
  draw(shift(centerX, centerY) * circle((0,0), ra), 0.3*gray); // addendum circle
  draw(shift(centerX, centerY) * circle((0,0), rd), 0.3*gray); // dedendum circle
}

// Animation setup
real gear1_x = 0;
real gear1_y = 0;
real gear2_x = 2 * rp;
real gear2_y = 0;

animation a;

int n = 24; // number of frames
real dt = 2 * pi / n; // angular increment per frame

for (int i = 0; i <= n; ++i) {
  save();
  
  real angle = i * dt;
  
  // Clear and redraw
  erase();
  
  // Draw background
  draw((-20, -180), (340, 180), white);
  
  // Draw gears
  drawGear(gear1_x, gear1_y, angle);
  drawGear(gear2_x, gear2_y, -angle); // opposite rotation for meshing
  
  // Draw centers
  dot((gear1_x, gear1_y), black);
  dot((gear2_x, gear2_y), black);
  
  a.add(); // Add currentpicture to animation
  
  restore();
}

erase();

// Merge the images into a gif animation.
a.movie(BBox(10pt),loops=0,delay=100);
