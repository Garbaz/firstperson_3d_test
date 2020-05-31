import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_3dtest extends PApplet {


PVector camera_pos = new PVector();

public void setup() {
  
}

public void draw() {
  background(0xff7eccfc);
  translate(width/2, height/2);

  float camera_angle = millis()/500.0f;
  float camera_distance = 200;
  float camera_height = -100;
  camera_pos.set(camera_distance*sin(camera_angle),camera_distance*cos(camera_angle),camera_height);
  camera(camera_pos.x, camera_pos.y, camera_pos.z,  0, 0, 0,  0, 0, 1);
  
  box(100, 100, 100);
}
// PVector VEC(float x, float y) { // Because typing "new PVector" all the time gets old fast
//   return new PVector(x, y);
// }
  public void settings() {  size(640, 480, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_3dtest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
