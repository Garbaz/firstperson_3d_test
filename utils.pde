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
