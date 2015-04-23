
import java.awt.geom.Line2D;

int FPS = 45;


int PLANE_LENGTH = 90;
int PLANE_WIDTH = 60;
int PLANE_THICKNESS = 9;
float WING_PROPORTION = .3;
int DEFAULT_PLANE_X = 810;
int DEFAULT_PLANE_Y = 540;
int DEFAULT_PLAYER_HEALTHLEVEL = 10;
int DEFAULT_ENEMY_HEALTHLEVEL = 5;
int COOL_DOWN_TIME = 15;

float TURN_RADIUS = .05;
float BASE_SPEED = 5;




float BASE_BULLET_SPEED = 12;
float BULLET_THICKNESS = 4;
color BULLET_COLOR = color(0);


color BG_COLOR = color(13,210,224);

float CLOUD_SPEED = 2;
int CLOUD_WIDTH = 120;
int CLOUD_HEIGHT = 60;
float CLOUD_PROBABILITY = .06;



// PImage PLANE_IMAGE;
PImage CLOUD_IMAGE;




// Game Objects

Plane p1;
Plane p2;

ArrayList<Cloud> clouds;
ArrayList<Bullet> bullets;
ArrayList<Plane> allPlanes;


void setup(){
  
  // fps
  frameRate(FPS);
  
  // PLANE_IMAGE = loadImage("plane.png");
  CLOUD_IMAGE = loadImage("cloud.png");
  
  clouds = new ArrayList<Cloud>();
  bullets = new ArrayList<Bullet>();
  allPlanes = new ArrayList<Plane>();
  
  
  // ************************************EVENTUALLY SHOULD BE INITIALIZED WITH A "START GAME" METHOD WITH FIRST PLAYER BUTTON START OR TWO PLAYER BUTTON START DEPENDING
  p1 = new Plane();
  p2 = new Plane();
  
  allPlanes.add(p1);
  allPlanes.add(p2);
  
  allPlanes.add(new Plane(PI/2));
  allPlanes.add(new Plane(3*PI/2));
  
 
}


void draw(){
  drawBackground();
  
  updateBullets();
  
  updatePlanes();
  
  
}

void keyPressed(){
  
  if(key == 'd'){
    p1.startRightTurn();
  }
  
  if(key == 'a'){
    p1.startLeftTurn();
  }
  
  if(key == 'r'){
    p1.shooting = true;
  }
  
  if(key == ';'){
    p2.startRightTurn();
  }
  
  if(key == 'k'){
    p2.startLeftTurn();
  }
  
  if(key == 'u'){
    p2.shooting = true;;
  }
  
}

void keyReleased(){
  
  if(key == 'd'){
    p1.endTurn();
  }
  
  if(key == 'a'){
    p1.endTurn();
  }
  
  if(key == 'k'){
    p2.endTurn();
  }
  
  if(key == ';'){
    p2.endTurn();
  }
  
  if(key == 'r'){
    p1.shooting = false;
  }
  if(key == 'u'){
    p2.shooting = false;
  }
 
  
}


void updateBullets(){
  
  for(int i = (bullets.size()-1);i>=0;i--){
    
    bullets.get(i).move();
    
    bullets.get(i).draw();
    
    if(bullets.get(i).isOffScreen()){
      
      bullets.remove(i);
      
    }
    
  }
  
}


void updatePlanes(){
  
  for(int i = allPlanes.size()-1;i >= 0;i--){
    
    allPlanes.get(i).update();
  
    if(allPlanes.get(i).checkHits() ){
      
      allPlanes.remove(i);
      
      return;
      
    }
    
  }
  
  
}


void drawBackground(){
  background(BG_COLOR);
  
  if(Math.random()<CLOUD_PROBABILITY){
    clouds.add(new Cloud((float)(Math.random()*displayWidth)));
  }
  
  for(int i=(clouds.size()-1);i>=0;i--){
    clouds.get(i).move();
    
    if(clouds.get(i).y > displayHeight + CLOUD_HEIGHT){
        clouds.remove(i);
    }
  
    clouds.get(i).draw();
    
  }
  
}

















/*
 * Required by processing to make the sketch fullscreen
 */
public int sketchWidth() {
  return displayWidth;
}

/*
 * Required by processing to make the sketch fullscreen
 */
public int sketchHeight() {
  return displayHeight;
}

/*
 * Required by processing to make the sketch fullscreen
 */
public boolean sketchFullScreen() {
  return true;
}
