import java.awt.Robot;

Robot robby;

final float PLAYER_HEIGHT = 100;
final float PLAYER_GROUND_MAX_SPEED = 250;
final float PLAYER_GROUND_ACCELERATION = 3000;
final float PLAYER_GROUND_DECELERATE = 1500;
final float PLAYER_STRAFE_MAX_SPEED = 100;
final float PLAYER_AIR_ACCELERATION = 2000;
final float JUMP_SPEED = 300;
final float GRAVITY = 490;

PVector player_pos = VEC(0, 0, 0);
PVector player_move_vel = VEC(0, 0, 0);
PVector player_vel = VEC(0, 0, 0);

int input_move_right = 0;
int input_move_forward = 0;

boolean player_on_ground = true;

float view_angle_horizontally = 0;
float view_angle_vertically = 0;

float view_mouse_sensitivity = 0.0015;

final float FIELD_OF_VIEW = radians(68);
final float DEFAULT_FIELD_OF_VIEW = radians(60);
final float DRAW_DISTANCE = 10000;
final float CLOSE_CLIPPING_DISTANCE = 10;


void setup() {
  //size(640, 480, P3D);
  fullScreen(P3D);
  noCursor();

  frameRate(100);
  try {
    robby = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  //robby.mouseMove(width/2, height/2);
  mouseX = width/2;
  mouseY = height/2;

  textAlign(LEFT, TOP);

  perspective(FIELD_OF_VIEW, float(width)/float(height), CLOSE_CLIPPING_DISTANCE, DRAW_DISTANCE);
}

void draw() {
  float dt = deltatime();

  background(#7eccfc);
  //translate(width/2, height/2, 0);

  if (focused) {
    float mouseDeltaX = mouseX - width/2;
    float mouseDeltaY = mouseY - height/2;
    robby.mouseMove(width/2, height/2);

    view_angle_horizontally += view_mouse_sensitivity * mouseDeltaX;
    view_angle_vertically   -= view_mouse_sensitivity * mouseDeltaY;

    view_angle_horizontally %= TWO_PI;
    view_angle_vertically = constrain(view_angle_vertically, radians(-89), radians(89));
  }

  PVector forward_dir, right_dir, camera_dir, camera_pos;


  forward_dir = VEC(sin(view_angle_horizontally), 0, cos(view_angle_horizontally));
  right_dir = VEC(forward_dir.z, 0, -forward_dir.x);

  camera_dir = VEC(cos(view_angle_vertically) * forward_dir.x, sin(view_angle_vertically), cos(view_angle_vertically) * forward_dir.z);
  camera_pos = VEC(player_pos.x, player_pos.y+PLAYER_HEIGHT, player_pos.z);
  camera(camera_pos.x, camera_pos.y, camera_pos.z, player_pos.x+camera_dir.x, player_pos.y+camera_dir.y+PLAYER_HEIGHT, player_pos.z+camera_dir.z, 0, -1, 0);

  float player_vel_forward = player_vel.dot(forward_dir);
  float player_vel_right = player_vel.dot(right_dir);

  if (player_on_ground) {
    if (player_vel.mag() > dt*PLAYER_GROUND_DECELERATE) {
      player_vel.setMag(player_vel.mag() - dt*PLAYER_GROUND_DECELERATE);
    } else {
      player_vel.set(0, 0, 0);
    }
    vecAddMult(player_vel, forward_dir, dt * PLAYER_GROUND_ACCELERATION * input_move_forward);
    vecAddMult(player_vel, right_dir, dt * PLAYER_GROUND_ACCELERATION * input_move_right);

    if (player_vel.mag() > PLAYER_GROUND_MAX_SPEED) {
      player_vel.setMag(PLAYER_GROUND_MAX_SPEED);
    }
  } else { // IN AIR
    if (player_vel_forward * sign(input_move_forward) < PLAYER_STRAFE_MAX_SPEED) {
      vecAddMult(player_vel, forward_dir, dt * PLAYER_AIR_ACCELERATION * input_move_forward);
    }
    if (player_vel_right * sign(input_move_right) < PLAYER_STRAFE_MAX_SPEED) {
      vecAddMult(player_vel, right_dir, dt * PLAYER_AIR_ACCELERATION * input_move_right);
    }
  }
  //player_move_vel.set(0, 0, 0);
  //vecAddMult(player_move_vel, forward_dir, player_input_move_forward);
  //vecAddMult(player_move_vel, VEC(forward_dir.z, 0, -forward_dir.x), player_input_move_right);
  //vecAddMult(player_pos, player_move_vel, dt * PLAYER_SPEED);
  vecAddMult(player_vel, VEC_DOWN, GRAVITY * dt);

  vecAddMult(player_pos, player_vel, dt);
  if (player_pos.y < 0) {
    player_pos.y = 0;
    player_vel.y = 0;
    player_on_ground = true;
  } else {
    player_on_ground = false;
  }

  if (key_jump && player_on_ground) {
    player_vel.y = JUMP_SPEED;
    player_on_ground = false;
  }

  PVector bp = VEC(10, 50, 100);
  PVector p1 = VEC(0, 150, 30);
  PVector p2 = VEC(0, 120, -70);

  PVector bl = camera_pos;
  PVector l = PVector.mult(camera_dir, 10000);

  PVector inters = intersect_line_triangle(bl, l, bp, p1, p2);
  if (inters != null) {
    boxAt(inters.x, inters.y, inters.z, 5, 5, 5);
    fill(#ff0000);
  } else {
    fill(#ffffff);
  }
  beginShape(TRIANGLES);
  vertex(bp.x, bp.y, bp.z);
  vertex(bp.x+p1.x, bp.y+p1.y, bp.z+p1.z);
  vertex(bp.x+p2.x, bp.y+p2.y, bp.z+p2.z);
  endShape();


  randomSeed(1234);
  for (int x = -4500; x <= 4500; x+=1000) {
    for (int z = -4500; z <= 4500; z+=1000) {
      fill(random(0, 255), random(0, 255), random(0, 255));
      boxAtFloor(x+int(random(-50, 50)), z+int(random(-50, 50)), 25, 250, 25);
    }
  }
  //fill(#A71E1E);
  //boxAtFloor(0, 400, 70, 50, 70);
  //fill(#78EEFC);
  //boxAtFloor(400, 0, 50, 100, 220);
  //fill(#53AD47);
  //boxAtFloor(-400, 0, 100, 150, 100);
  //fill(#FFA805);
  //boxAtFloor(0, -400, 100, 200, 100);

  fill(#ffffff);
  boxAtFloor(0, 0, 10000, 700, 10000);

  hudBegin();
  pushStyle();
  fill(0);
  text("on_ground: "+player_on_ground, 100, 100);
  text("vel_mag: "+int(player_vel.mag()), 100, 120);
  text("vel_xz_mag: "+int(sqrt(player_vel.x*player_vel.x + player_vel.z*player_vel.z)), 100, 140);
  text("vel: ("+int(player_vel.x)+", "+int(player_vel.y)+","+int(player_vel.z)+")", 100, 160);

  fill(0, 0, 0, 128);
  text(frameRate, 0, 0);

  final int CROSSHAIR_SIZE = 20;
  final int CROSSHAIR_GAP = 10;
  int a = (CROSSHAIR_SIZE/2+CROSSHAIR_GAP);
  int b = CROSSHAIR_GAP/2;
  line(width/2-a, height/2, width/2-b, height/2);
  line(width/2+a, height/2, width/2+b, height/2);
  line(width/2, height/2-a, width/2, height/2-b);
  line(width/2, height/2+a, width/2, height/2+b);
  popStyle();
  hudEnd();
}

void hudBegin() {
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
  perspective(DEFAULT_FIELD_OF_VIEW, float(width)/float(height), CLOSE_CLIPPING_DISTANCE, DRAW_DISTANCE);
}

void hudEnd() {
  hint(ENABLE_DEPTH_TEST);
  perspective(FIELD_OF_VIEW, float(width)/float(height), CLOSE_CLIPPING_DISTANCE, DRAW_DISTANCE);
  popMatrix();
}

void boxAt(float x, float y, float z, float w, float h, float d) {
  pushMatrix();
  translate(x, y, z);
  box(w, h, d);
  popMatrix();
}

void boxAtFloor(float x, float z, float w, float h, float d) {
  boxAt(x, h/2, z, w, h, d);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
}

boolean key_left  = false;
boolean key_right = false;
boolean key_up    = false;
boolean key_down  = false;
boolean key_jump = false;
void keyPressed(KeyEvent e) {
  if (!e.isAutoRepeat()) {
    char e_key = e.getKey();
    int e_keyCode = e.getKeyCode();
    if (e_keyCode == LEFT || e_key == 'a') {
      key_left = true;
    } else if (e_keyCode == RIGHT || e_key == 'd') {
      key_right = true;
    } else if (e_keyCode == UP || e_key == 'w') {
      key_up = true;
    } else if (e_keyCode == DOWN || e_key == 's') {
      key_down = true;
    } else if (e_key == ' ') {
      key_jump = true;
    }
    update_player_move();
  }
}
void keyReleased() {
  if (keyCode == LEFT || key == 'a') {
    key_left = false;
  } else if (keyCode == RIGHT || key == 'd') {
    key_right = false;
  } else if (keyCode == UP || key == 'w') {
    key_up = false;
  } else if (keyCode == DOWN || key == 's') {
    key_down = false;
  } else if (key == ' ') {
    key_jump = false;
  }

  update_player_move();
}


void update_player_move() {
  input_move_forward = int(key_up)-int(key_down);
  input_move_right = int(key_right)-int(key_left);
}

void mousePressed() {
  if (mouseButton == LEFT) {
  }
}


int lastTime = 0;
float deltatime() {
  int deltaTime = millis() - lastTime;
  lastTime += deltaTime;
  return deltaTime/1000.0;
}
