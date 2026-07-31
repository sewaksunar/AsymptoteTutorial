// ============================================================================
// geometry_utils.asy
// General-purpose geometric utility functions for Asymptote
// ============================================================================

// General intersection function for ANY two paths
// Returns array of intersection points between path p and path q
// Usage: pair[] pts = pathIntersection(circle, line);
pair[] pathIntersection(path p, path q) {
  // intersections() returns array of real[][] pairs [t_on_p, t_on_q]
  real[][] params = intersections(p, q);
  
  pair[] points;
  
  // Convert parameter values to actual points
  for (int i = 0; i < params.length; ++i) {
    real t_p = params[i][0];
    real t_q = params[i][1];
    
    pair pt = point(p, t_p);  // Get point on path p at parameter t_p
    points.push(pt);
  }
  
  return points;
}

// Find tangent line from external point to circle
// Uses circle intersection method: tangent points are where circle (O,r)
// intersects with circle having OP as diameter (right angle at intersection)
// Usage: pair T = tangentPointToCircle(center, radius, externalPoint, "left");
pair tangentPointToCircle(pair O, real r, pair P, string side) {
  real d = length(P - O);
  pair dir_OP = unit(P - O);
  
  // Helper circle: diameter is OP, so center is midpoint, radius is d/2
  pair helper_center = O + d/2 * dir_OP;
  real helper_radius = d/2;
  
  // Using circle intersection formula
  // a² = r², b² = helper_radius², c = distance between centers
  real a_sq = r * r;
  real b_sq = helper_radius * helper_radius;
  real c = d/2;
  
  // Position along OP where perpendicular to tangent point intersects
  real x = (a_sq - b_sq + c*c) / (2*c);
  real h_sq = a_sq - x*x;
  
  if (h_sq < 0) h_sq = 0;  // safety check
  real h = sqrt(h_sq);
  
  // Two tangent points, perpendicular offset from OP direction
  pair perp = rotate(90) * dir_OP;
  pair T1 = O + x*dir_OP + h*perp;
  pair T2 = O + x*dir_OP - h*perp;
  
  return (side == "right") ? T1 : T2;
}

// ============================================================================
// ARC DISTANCE FUNCTIONS
// ============================================================================

// PRIMARY FUNCTION: Calculate arc length between two points on a circle
// Arc defined by: center O and two points P1, P2 on the circle
// Parameters: O = circle center, P1, P2 = points on circle circumference
// Returns: arc length (automatically calculates the radius and angle)
// Usage: real arc = arcLength(center, ptA, ptB);
real arcLength(pair O, pair P1, pair P2) {
  real r = length(P1 - O);
  
  // Vectors from center to each point
  pair v1 = P1 - O;
  pair v2 = P2 - O;
  
  // Calculate angle between vectors using dot product
  real cos_angle = dot(v1, v2) / (length(v1) * length(v2));
  
  // Clamp to [-1, 1] to avoid numerical errors in acos
  cos_angle = max(-1, min(1, cos_angle));
  
  real angle_rad = acos(cos_angle);
  return r * angle_rad;
}

// Alternative: Calculate arc length given radius and central angle
// Parameters: r = radius, angle_deg = central angle in degrees
// Returns: arc length
// Usage: real arc = arcLengthByAngle(5cm, 45);
real arcLengthByAngle(real r, real angle_deg) {
  real angle_rad = radians(angle_deg);
  return r * angle_rad;
}

// Legacy name (kept for compatibility)
real arcDistanceFromPoints(pair O, pair P1, pair P2) {
  return arcLength(O, P1, P2);
}

// Legacy name (kept for compatibility)
real arcDistance(real r, real angle_deg) {
  return arcLengthByAngle(r, angle_deg);
}

real inv(real t){
  return tan(t)-t;
}
// ===================
// r = teeth thickness  
// rp = radius of pitch circle
// tp = given (thickness of tooth at pitch circle)
// pphi = pressure angle pressure angle corresponding to the pitch circle radius rp
// shi = involute angle corresponding to point T
// ============

real thickness(real r, real tp, real rp, real pphi, real shi){
  real t = 2*r*(tp/(2*rp) + inv(pphi) - inv(shi));
  return t;
}