class Player {
  Camera camera;

  PVector pos;
  PVector posOld;
  PVector posXZ;
  PVector headPos;
  PVector frontDir;
  PVector rightDir;
  PVector keyDir;
  PVector moveDir;
  PVector vel;
  PVector velXZ;
  boolean keyForward, keyBackward, keyLeft, keyRight, keySpace;

  boolean onGround = true;

  float MAX_SPEED = 250.0/1000;
  int HEAD_HEIGHT = 64;
  int FOOT_SIZE_RADIUS = 16;
  float STOP_SPEED = 10.0/1000;
  float FRICTION = -8.0/1000;
  float ACCELARATION = 1000.0/sq(1000);
  float GRAVITY = 448.0/sq(1000);
  float JUMP_SPEED = 224.0/1000;
  float MAX_STRAFE_SPEED = 30.0/1000;
  float AIR_ACCELARATION = 1000.0/sq(1000);

  Player(PVector pos_) {
    pos = pos_;
    frontDir = new PVector(0, 0);
    rightDir = PVector.fromAngle(frontDir.heading()+radians(90));
    keyDir = new PVector(0, 0);
    moveDir = new PVector(0, 0);
    vel = new PVector(0, 0, 0);
    velXZ = new PVector(0, 0);
    headPos = pos.copy();
    posXZ = new PVector(pos.x, pos.z);
    headPos.y += HEAD_HEIGHT;
    camera = new Camera(headPos, new PVector(frontDir.x, 0, frontDir.y));
  }
  void update() {
    camera.firstPersonRotate();
    frontDir.set(camera.dir.x, camera.dir.z);
    posOld = pos.copy();
    move();
    posXZ.set(pos.x, pos.z);
    headPos.set(pos);
    headPos.y += HEAD_HEIGHT;
  }
  void show() {
    camera.applyCamera();
  }
  void move() {
    keyDir.set(int(keyForward)-int(keyBackward), int(keyLeft)-int(keyRight)).normalize();
    keyDir.rotate(frontDir.heading());
    moveDir = keyDir.copy();
    posOld = pos.copy();
    if (onGround) {
      if (keySpace) {
        jump();
      } else {
        moveOnGround();
      }
    }
    if (!onGround) {
      moveInAir();
      gravity();
    }

    vel.x = velXZ.x;
    vel.z = velXZ.y;

    pos.add(vel.copy().mult(deltaTime));
    collision();
  }

  void moveOnGround() {
    moveDir.setMag(ACCELARATION * deltaTime);
    //   vel.x += moveDir.x;
    //   vel.z += moveDir.y;
    velXZ.add(moveDir);
    if (keyDir.x+keyDir.y == 0) {
      velXZ.add(velXZ.copy().mult(FRICTION * deltaTime));
    }
    velXZ.limit(MAX_SPEED);
    if (velXZ.mag() < STOP_SPEED) {
      velXZ.setMag(0);
    }
  }
  void jump() {
    onGround = false;
    vel.y += JUMP_SPEED;
  }
  void moveInAir() {
    if (PVector.dot(keyDir, velXZ) < MAX_STRAFE_SPEED) {
      moveDir.setMag(AIR_ACCELARATION * deltaTime);
      velXZ.add(moveDir);
    }
  }

  void gravity() {
    vel.y -= GRAVITY * deltaTime;
  }
  void collision() {
    boolean collided = false;
    for (int i=0; i < platforms.size(); i++) {
      Platform p = platforms.get(i);
      if (PVector.dist(posXZ, p.posXZ) <= p.radius + FOOT_SIZE_RADIUS) {
        collided = true;
        if (pos.y <= p.pos.y && posOld.y > p.pos.y) {
          println("AAAAA");
          vel.y = 0;
          onGround = true;
          pos.y = p.pos.y;
        }
      }
    }
    if (pos.y <= 0) {
      collided = true;
      vel.y = 0;
      onGround = true;
      pos.y = 0;
    } 
    if (!collided) {
      println("BBBBB");
      onGround = false;
    }
  }



  void keyStart() {
    if (keyCode == UP || key == 'w') {
      keyForward = true;
    } else if (keyCode == DOWN || key == 's') {
      keyBackward = true;
    } else if (keyCode == LEFT || key == 'a') {
      keyLeft = true;
    } else if (keyCode == RIGHT || key == 'd') {
      keyRight = true;
    } else if (key == ' ') {
      keySpace = true;
      println("AAA");
    }
  }
  void keyStop() {
    if (keyCode == UP || key == 'w') {
      keyForward = false;
    } else if (keyCode == DOWN || key == 's') {
      keyBackward = false;
    } else if (keyCode == LEFT || key == 'a') {
      keyLeft = false;
    } else if (keyCode == RIGHT || key == 'd') {
      keyRight = false;
    } else if (key == ' ') {
      keySpace = false;
    }
  }
}

void keyPressed() {
  player.keyStart();
}

void keyReleased() {
  player.keyStop();
}
