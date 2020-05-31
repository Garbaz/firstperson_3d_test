Player player;

int deltaTime;
int lastTime;


int roomsize = 10000;
int bps = 20; // boxes per side

float testPos;

ArrayList<Platform> platforms = new ArrayList<Platform>();

void setup() {
  fullScreen(P3D);
  player = new Player(new PVector(0, 0, 0));
  //for (int i=0; i < 100; i++) {
  //  platforms.add(new Platform(new PVector(random(-roomsize/2, roomsize/2), random(0, 200), random(-roomsize/2, roomsize/2)), random(50, 100)));
  //}
  platforms.add(new Platform(new PVector (0, 0, 0), 100));
  //noFill();



  println("START");
  lastTime = millis();
}

void draw() {
  deltaTime = millis()-lastTime;
  lastTime = millis();


  background(#F0F0F0);
  directionalLight(128, 128, 128, 1, 1, -1);
  ambientLight(64, 64, 64);
  //ambientLight(255, 255, 255);
  pushMatrix();
  generateLevel();
  player.update();
  player.show();

  //3D STUFF
  pushMatrix();
  fill(255);
  translate(0, 5000, 0);
  box(10000);
  popMatrix();
  for (Platform p : platforms) {
    p.show();
  }

 // randomSeed(1234);

  //for (int i = 0; i < bps; i++) {
  //  for (int j = 0; j < bps; j++) {
  //    fill(random(0, 255), random(0, 255), random(0, 255));
  //    pushMatrix();
  //    translate(i*roomsize/bps-roomsize/2, 50, j*roomsize/bps-roomsize/2);
  //    box(50, 100, 50);
  //    popMatrix();
  //  }
  //}

  popMatrix();


  //UI STUFF
  player.camera.hudBegin();
  fill(0);
  text("FPS: " + frameRate, 100, 100);
  text("CamPos: " + player.camera.pos.x + " | " +  player.camera.pos.y + " | " +  player.camera.pos.z, 100, 200);
  text("PlayerPos: " + player.pos.x + " | " +  player.pos.y + " | " +  player.pos.z, 100, 300);
  text("PlayerPosOldDIff: " + (player.posOld.x - player.pos.x) + " | " +  (player.posOld.y - player.pos.y)  + " | " + (player.posOld.z - player.pos.z), 100, 350);

  text("PlayerPosXZ: " + player.posXZ.x + " | " +  player.posXZ.y, 100, 320);

  text("CamDir:" + player.camera.dir.x + " | " +  player.camera.dir.y + " | " +  player.camera.dir.z, 100, 400);
  text("Vel: " + player.vel.x + " | " +  player.vel.y + " | " +  player.vel.z, 100, 500);
  text("VelMag: " + round(player.vel.mag()*100)/100.0, 100, 600);
  text("VelXZMag: " + round(player.velXZ.mag()*100)/100.0, 100, 700);
  text("KeyDir: " + player.keyDir.x + " | " +  player.keyDir.y, 100, 800);
  text("OnGround: " + player.onGround, 100, 900);
  text("Platforms: " + platforms.size(), 100, 1000);
  // text( player.frontDir.x + " | " +  player.frontDir.y, 100, 600);




  player.camera.hudEnd();
}


void vertex(PVector pos) {
  vertex(pos.x, pos.y, pos.z);
}

void addPlatform() {
  testPos += 200;
  platforms.add(new Platform(new PVector(testPos, random(0, 50), random(-100, 100)), random(50, 100)));
}
void generateLevel() {
  while (player.pos.x + 1000 > testPos) {
    addPlatform();
  }
  for (int i=0; i < platforms.size(); i++) {
    if (player.pos.x - 1000 > platforms.get(i).pos.x) {
      platforms.remove(i);
      i--;
    }
  }
}

//PShape box(float x1, float y1, float z1, float x2, float y2, float z2) {
//  return box(new PVector(x1, y1, z1), new PVector(x2, y2, z2));
//}
//PShape box(PVector pos, PVector pos2) {
//  PShape box = createShape(GROUP);
//  box.addChild(rect(pos, new PVector(pos2.x, pos2.y, 0)));
//  box.addChild(rect(pos, new PVector(pos2.x, 0, pos2.z)));
//  box.addChild(rect(pos, new PVector(0, pos2.y, pos2.z)));

//  box.addChild(rect(pos2, new PVector(pos.x, pos.y, 0)));
//  box.addChild(rect(pos2, new PVector(pos.x, 0, pos.z)));
//  box.addChild(rect(pos2, new PVector(0, pos.y, pos.z)));
//  return box;
//}

//PShape rect(PVector pos, PVector pos2) {
//  PShape rect = new PShape();
//  rect.beginShape(QUADS);
//  rect.vertex(pos.x, pos.y, pos.z);
//  rect.vertex(pos2.x, pos.y, pos2.z);
//  rect.vertex(pos2.x, pos2.y, pos2.z);
//  rect.vertex(pos.x, pos2.y, pos.z);
//  rect.endShape(CLOSE);
//  return rect;
//}
