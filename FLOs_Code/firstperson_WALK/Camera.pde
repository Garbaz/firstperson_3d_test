import java.awt.Robot;
class Camera {
  Robot robby;
  public PVector pos = new PVector(0, 0, 0);
  public PVector dir = new PVector(0, 0, 0);
  private float beta = PI; //HORIZONTALY
  private float alpha = 0; //VERTICALALY
  float view_mouse_sensitivity = 0.002;

  float move;

  float fov = radians(60);
  float defaultFov = radians(60);
  float closeClipping = 1;
  float farClipping = 100000;


  Camera(PVector cameraPos_, PVector cameraDir_) {
    pos = cameraPos_;
    dir = cameraDir_;
    dir.setMag(1);

    cameraSetup();
  }
  Camera() {
    cameraSetup();
  }
  void cameraSetup() {
    noCursor();
    perspective(fov, float(width)/float(height), closeClipping, farClipping);
    try {
      robby = new Robot();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    robby.mouseMove(width/2, height/2);


    mouseX = width/2;
    mouseY = height/2;
  }
  void applyCamera() {
    camera(pos.x, pos.y, pos.z, pos.x + dir.x, pos.y + dir.y, pos.z + dir.z, 0, -1, 0);
  }

  void firstPerson() {
    firstPersonRotate();
    //perspective(PI/2, width/height, ((height/2.0) / tan(PI*60.0/360.0))/10000.0, ((height/2.0) / tan(PI*60.0/360.0))*100.0);   
    //perspective();
    applyCamera(); 
    // frustum(cameraPos.x, cameraPos.x+width, cameraPos.y+height, cameraPos.y, cameraPos.z, cameraPos.z+10000);
  }

  void hudBegin() {
    pushMatrix();
    camera();
    hint(DISABLE_DEPTH_TEST);
    perspective(defaultFov, float(width)/float(height), closeClipping, farClipping);
    noLights();
  }

  void hudEnd() {
    hint(ENABLE_DEPTH_TEST);
    perspective(fov, float(width)/float(height), closeClipping, farClipping);
    popMatrix();
  }
  void firstPersonRotate() {
    if (focused) {
      float mouseDeltaX = mouseX - width/2;
      float mouseDeltaY = mouseY - height/2;
      robby.mouseMove(width/2, height/2);

      alpha += - view_mouse_sensitivity * mouseDeltaY;
      beta  += + view_mouse_sensitivity * mouseDeltaX;
      beta %= TWO_PI;
      alpha = constrain(alpha, radians(-80), radians(80));
    }
    dir.set(sin(beta)*cos(alpha), sin(alpha), cos(beta)*cos(alpha)).setMag(1);
  }
}
