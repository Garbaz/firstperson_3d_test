final PVector VEC_UP = new PVector(0, 1, 0);
final PVector VEC_DOWN = new PVector(0, -1, 0);


PVector VEC() { // Because typing "new PVector" all the time gets old fast
  return new PVector();
}

PVector VEC(float x, float y) { // Because typing "new PVector" all the time gets old fast
  return new PVector(x, y);
}

PVector VEC(float x, float y, float z) { // Because typing "new PVector" all the time gets old fast
  return new PVector(x, y, z);
}

/**
 out = out + scalar * in
 For example: out = position, in = velocity, scalar = deltaTime
 */
void vecAddMult(PVector out, PVector in, float scalar) {
  out.add(scalar*in.x, scalar*in.y, scalar*in.z);
}

int sign(float x) {
  if (x < 0) return -1;
  if (x > 0) return 1;
  return 0;
}

int sign(int x) {
  if (x < 0) return -1;
  if (x > 0) return 1;
  return 0;
}

// Calculates intersection of a line going from bl to bl+l and a triangle with the corners bp, bp+p1, bp+p2.
// Returns the intersection point if the line and triangle intersect and null if they don't.
PVector intersect_line_triangle(PVector bl, PVector l, PVector bp, PVector p1, PVector p2) {
  PVector b = PVector.sub(bl, bp);
  
  //Solution to the equation `b = u*p1 + v*p2 - t*l` (or `bl + t*l = bp + u*p1 + v*p2`) from Maxima. 
  float u=-((b.x)*((l.z)*(p2.y)-(l.y)*(p2.z))+(l.x)*((b.y)*(p2.z)-(b.z)*(p2.y))+((b.z)*(l.y)-(b.y)*(l.z))*(p2.x))/((l.x)*((p1.z)*(p2.y)-(p1.y)*(p2.z))+(p1.x)*((l.y)*(p2.z)-(l.z)*(p2.y))+((l.z)*(p1.y)-(l.y)*(p1.z))*(p2.x)); 
  float v=((b.x)*((l.z)*(p1.y)-(l.y)*(p1.z))+(l.x)*((b.y)*(p1.z)-(b.z)*(p1.y))+((b.z)*(l.y)-(b.y)*(l.z))*(p1.x))/((l.x)*((p1.z)*(p2.y)-(p1.y)*(p2.z))+(p1.x)*((l.y)*(p2.z)-(l.z)*(p2.y))+((l.z)*(p1.y)-(l.y)*(p1.z))*(p2.x));
  float t=-((b.x)*((p1.z)*(p2.y)-(p1.y)*(p2.z))+(p1.x)*((b.y)*(p2.z)-(b.z)*(p2.y))+((b.z)*(p1.y)-(b.y)*(p1.z))*(p2.x))/((l.x)*((p1.z)*(p2.y)-(p1.y)*(p2.z))+(p1.x)*((l.y)*(p2.z)-(l.z)*(p2.y))+((l.z)*(p1.y)-(l.y)*(p1.z))*(p2.x));
  
  //Check that the solution actually is on the line and on the triangle
  if (0 <= t && t <= 1 && 0 <= u && 0 <= v && u+v <= 1) {
    PVector solution = l;
    solution.mult(t);
    solution.add(bl);
    return solution;
  } else {
    return null;
  }
}
