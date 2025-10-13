// Minimal config.asy to satisfy includes for animation examples
import graph; // bring in basic axis and label helpers if available

// Define pens explicitly to avoid relying on environment-specific names
pen BigCircle = pen(rgb(0,0,1)); // blue
pen littleCircle = pen(rgb(0,0.5,0)); // deep green
pen curve = pen(rgb(1,0,0)); // red

void usersetting() {
  // Placeholder for user settings used by examples.
  defaultpen(linewidth(0.8));
  labelmargin = 2;
}

// Provide a simple axes include replacement that doesn't rely on enums
void include_axes(pair origin=(0,0), real len=5) {
  // Draw simple axes with arrows
  draw(origin + (-len,0) -- origin + (len,0), Arrow(6));
  draw(origin + (0,-len) -- origin + (0,len), Arrow(6));
  label("x", origin + (len, -0.25));
  label("y", origin + (-0.25, len));
}
