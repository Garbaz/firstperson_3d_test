class Platform {
  PVector pos;
  PVector posXZ;
  float radius;  

  Platform(PVector pos_, float radius_) {
    pos = pos_;
    posXZ = new PVector(pos.x, pos.z);
    radius = radius_;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(PI/2);
    circle(0, 0, 2*radius);
    popMatrix();
  }
}
