
import java.awt.geom.Line2D;

int FPS = 45;


int PLANE_LENGTH = 40;
int PLANE_WIDTH = 15;
int PLANE_THICKNESS = 9;
float WING_PROPORTION = .3;
int DEFAULT_PLANE_X = 810;
int DEFAULT_PLANE_Y = 540;
int DEFAULT_PLAYER_HEALTHLEVEL = 100;
int DEFAULT_ENEMY_HEALTHLEVEL = 5;

float TURN_RADIUS = .1;
float BASE_SPEED = 5;




float BASE_BULLET_SPEED = 8;
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
  
  
  // ************************************EVENTUALLY SHOULD BE INITIALIZED WITH FIRST PLAYER BUTTON START OR TWO PLAYER BUTTON START DEPENDING
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
  
  if(key == Buttons.PLAYER_1_JOYSTICK_UP){
    p1.startRightTurn();
  }
  
  if(key == 'a'){
    p1.startLeftTurn();
  }
  
  if(key == 'r'){
    p1.shoot();
  }
  
  if(key == ';'){
    p2.startRightTurn();
  }
  
  if(key == 'k'){
    p2.startLeftTurn();
  }
  
  if(key == 'u'){
    p2.shoot();
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



class Plane {
  
  int healthLevel;
  float x;
  float y;
  float direction;
  float deltaDirection = 0;
  float speed;
  
  String name;
  
  Plane(float startX,float startY,float startDirection,float startSpeed,int startHealth){
    x = startX;
    y = startY;
    direction = startDirection;
    speed = startSpeed;
    healthLevel = startHealth;
    
    
  }
  
  Plane(){
    
    this(DEFAULT_PLANE_X,DEFAULT_PLANE_Y,0,BASE_SPEED,DEFAULT_PLAYER_HEALTHLEVEL);
    
  }
  
  Plane(float startDirection){
    
    this(DEFAULT_PLANE_X,DEFAULT_PLANE_Y, startDirection ,BASE_SPEED,DEFAULT_ENEMEY_HEALTHLEVEL);
    
  }
  
  void update(){
    
    move();
    
    draw();
    
  }
  
  void move(){
    direction += deltaDirection;
    x += cos(direction)*speed;
    y += sin(direction)*speed;
    
    if(x < cos(direction)*PLANE_LENGTH && cos(direction)<0){
      
      x = width;
      
    }else if(x > width + cos(direction)*PLANE_LENGTH && cos(direction)>0){
      
      x = 0;
      
    }
    
    if(y < sin(direction)*PLANE_LENGTH  && sin(direction)<0){
      
      y = height;
      
    }else if(y + sin(direction + PI)*PLANE_LENGTH > height  && sin(direction)>0){
      
      y = 0;
      
    }
    
  }
  
  void draw(){
    
    // pushMatrix() and popMatrix() are called inside the class' display() method. 
    // This way, every object is rendered with its own independent translation and rotation
    pushMatrix(); 
    translate(x,y);
    rotate(direction);
    stroke((int)(255*((DEFAULT_PLAYER_HEALTHLEVEL*1.0-healthLevel)/DEFAULT_PLAYER_HEALTHLEVEL)),
     (int)(255*(healthLevel*1.0/DEFAULT_PLAYER_HEALTHLEVEL)) ,0);
    strokeWeight(PLANE_THICKNESS);
    line(0,0,-PLANE_LENGTH,0);
    line(-WING_PROPORTION*PLANE_LENGTH,PLANE_WIDTH,-WING_PROPORTION*PLANE_LENGTH,-PLANE_WIDTH);
    popMatrix();
    
  }
  
  void shoot(){
    
    bullets.add(new Bullet(x+1,y+1,direction));
    
  }
  
  
  boolean checkHits(){
    
    
    
    for(int i = bullets.size()-1;i >= 0;i--){
      
      Bullet b = bullets.get(i);
      
      if(Line2D.linesIntersect(b.x,b.y,b.getXLine(),b.getYLine(),x,y,getXLine(),getYLine()) ||
          Line2D.linesIntersect(b.x,b.y,b.getXLine(),b.getYLine(),
            getWing1X(),getWing1Y(),getWing2X(),getWing2Y())   ){
           
          healthLevel--;
          bullets.remove(i);
          
          if(healthLevel<0){
            return true;
          }
           
      }
      
    }
    
    return false;
  }
  
  /**
    * Loads of weird trig that I wrote out on paper and works so I'm not messing with it
    */
  float getXLine(){
    
    return x - cos(direction)*PLANE_LENGTH;
    
  }
  
  float getYLine(){
    
    return y - sin(direction)*PLANE_LENGTH;
    
  }
  // ----------------------------------------------------------------------------------
  float getWing1X(){
    return x - cos(direction)*PLANE_LENGTH*WING_PROPORTION + sin(direction)*PLANE_WIDTH;
    
  }
  float getWing1Y(){
    return y - sin(direction)*PLANE_LENGTH*WING_PROPORTION - cos(direction)*PLANE_WIDTH;
  }
  float getWing2X(){
    return x - cos(direction)*PLANE_LENGTH*WING_PROPORTION - sin(direction)*PLANE_WIDTH;
  }
  float getWing2Y(){
    return y - sin(direction)*PLANE_LENGTH*WING_PROPORTION + cos(direction)*PLANE_WIDTH;
  }
  
  void startLeftTurn(){
      
      deltaDirection = -TURN_RADIUS;
    
  }
  
  void startRightTurn(){
    
      deltaDirection = TURN_RADIUS;
      
    
  }
  
  void endTurn(){
    
    
      deltaDirection = 0;

    
  }
  
  
}// end plane class



class Bullet {
  
  float x;
  float y;
  float direction;
  float speed;
  
  Bullet (float startX, float startY, float startDirection){
    
    x = startX;
    y = startY;
    direction = startDirection;
    
    speed = BASE_BULLET_SPEED;
    
  }
  
  void move(){
    
    x += cos(direction)*speed;
    y += sin(direction)*speed;
    
  }
  
  void draw(){
    strokeWeight(BULLET_THICKNESS);
    stroke(BULLET_COLOR);
    line(x,y,x+cos(direction)*speed,y+sin(direction)*speed);
    
  }
  
  boolean isOffScreen(){
    
    if(x+speed>displayWidth || x-speed < 0 || y+speed>displayHeight || y-speed<0){
      return true;
    }else{
      return false;
    }
    
  }
  
  
  float getXLine(){
    
    return x + cos(direction)*speed;
    
  }
  
  float getYLine(){
    
    return y + sin(direction)*speed;
    
  }
  
  
  
}// end Bullet class


class Cloud {
  
  float x;
  float y;
  
  Cloud(float newX){
    x = newX;
    y = -CLOUD_HEIGHT;
    
  }
  
  void move(){
    
    y += CLOUD_SPEED;
    
  }
  
  void draw(){
    
    image(CLOUD_IMAGE, x, y, CLOUD_WIDTH,CLOUD_HEIGHT);
    
  }
  
  
  
  
}// end Cloud class




























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
