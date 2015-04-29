import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.geom.Line2D; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class test extends PApplet {




int FPS = 45;


int PLANE_LENGTH = 90;
int PLANE_WIDTH = 60;
int PLANE_THICKNESS = 9;
float WING_PROPORTION = .3f;
int DEFAULT_PLANE_X = 810;
int DEFAULT_PLANE_Y = 540;
int DEFAULT_PLAYER_HEALTHLEVEL = 10;
int DEFAULT_ENEMY_HEALTHLEVEL = 5;
int COOL_DOWN_TIME = 15;

float TURN_RADIUS = .05f;
float BASE_SPEED = 5;




float BASE_BULLET_SPEED = 12;
float BULLET_THICKNESS = 4;
int BULLET_COLOR = color(0);


int BG_COLOR = color(13,210,224);

float CLOUD_SPEED = 2;
int CLOUD_WIDTH = 120;
int CLOUD_HEIGHT = 60;
float CLOUD_PROBABILITY = .06f;



// PImage PLANE_IMAGE;
PImage CLOUD_IMAGE;




// Game Objects

Plane p1;
Plane p2;

ArrayList<Cloud> clouds;
ArrayList<Bullet> bullets;
ArrayList<Plane> allPlanes;


public void setup(){
  
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


public void draw(){
  drawBackground();
  
  updateBullets();
  
  updatePlanes();
  
  
}

public void keyPressed(){
  
  if(key == Buttons.PLAYER_1_JOYSTICK_RIGHT){
    p1.startRightTurn();
  }
  
  if(key == Buttons.PLAYER_1_JOYSTICK_LEFT){
    p1.startLeftTurn();
  }
  
  if(key == Buttons.PLAYER_1_BUTTON_1){
    p1.shooting = true;
  }
  
  if(key == Buttons.PLAYER_2_JOYSTICK_RIGHT){
    p2.startRightTurn();
  }
  
  if(key == Buttons.PLAYER_2_JOYSTICK_LEFT){
    p2.startLeftTurn();
  }
  
  if(key == Buttons.PLAYER_2_BUTTON_1){
    p2.shooting = true;
  }
  
}

public void keyReleased(){
  
  if(key == Buttons.PLAYER_1_JOYSTICK_RIGHT || key == Buttons.PLAYER_1_JOYSTICK_LEFT){
    p1.endTurn();
  }
  
  if(key == Buttons.PLAYER_2_JOYSTICK_RIGHT || key == Buttons.PLAYER_2_JOYSTICK_LEFT){
    p2.endTurn();
  }
  
  if(key == Buttons.PLAYER_1_BUTTON_1){
    p1.shooting = false;
  }
  if(key == Buttons.PLAYER_2_BUTTON_1){
    p2.shooting = false;
  }
 
  
}


public void updateBullets(){
  
  for(int i = (bullets.size()-1);i>=0;i--){
    
    bullets.get(i).move();
    
    bullets.get(i).draw();
    
    if(bullets.get(i).isOffScreen()){
      
      bullets.remove(i);
      
    }
    
  }
  
}


public void updatePlanes(){
  
  for(int i = allPlanes.size()-1;i >= 0;i--){
    
    allPlanes.get(i).update();
  
    if(allPlanes.get(i).checkHits() ){
      
      allPlanes.remove(i);
      
      return;
      
    }
    
  }
  
  
}


public void drawBackground(){
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

class Bullet{ 
 
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
  
  public void move(){
    
    x += cos(direction)*speed;
    y += sin(direction)*speed;
    
  }
  
  public void draw(){
    strokeWeight(BULLET_THICKNESS);
    stroke(BULLET_COLOR);
    line(x,y,x+cos(direction)*speed,y+sin(direction)*speed);
    
  }
  
  public boolean isOffScreen(){
    
    if(x+speed>displayWidth || x-speed < 0 || y+speed>displayHeight || y-speed<0){
      return true;
    }else{
      return false;
    }
    
  }
  
  
  public float getXLine(){
    
    return x + cos(direction)*speed;
    
  }
  
  public float getYLine(){
    
    return y + sin(direction)*speed;
    
  }
  
  
}

class Cloud{


  float x;
  float y;
  
  Cloud(float newX){
    x = newX;
    y = -CLOUD_HEIGHT;
    
  }
  
  public void move(){
    
    y += CLOUD_SPEED;
    
  }
  
  public void draw(){
    
    image(CLOUD_IMAGE, x, y, CLOUD_WIDTH,CLOUD_HEIGHT);
    
  }
  
  
}

class Plane{
  
  int healthLevel;
  float x;
  float y;
  float direction;
  float deltaDirection = 0;
  float speed;
  
  boolean shooting = false;
  int coolDown = 0;
  
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
    
    this(DEFAULT_PLANE_X,DEFAULT_PLANE_Y, startDirection ,BASE_SPEED,DEFAULT_PLAYER_HEALTHLEVEL);
    
  }
  
  public void update(){
    
    move();
    
    draw();
    
    updateShooting();
    
  }
  
  public void move(){
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
  
  public void updateShooting(){
    
    if(shooting && coolDown == 0){
      
      shoot();
      
      coolDown = COOL_DOWN_TIME;
      
    }
    
    if(coolDown>0){
      coolDown--;
    }
    
  }
  
  public void draw(){
    
    // pushMatrix() and popMatrix() are called inside the class' display() method. 
    // This way, every object is rendered with its own independent translation and rotation
    pushMatrix(); 
    translate(x,y);
    rotate(direction);
    stroke((int)(255*((DEFAULT_PLAYER_HEALTHLEVEL*1.0f-healthLevel)/DEFAULT_PLAYER_HEALTHLEVEL)),
     (int)(255*(healthLevel*1.0f/DEFAULT_PLAYER_HEALTHLEVEL)) ,0);
    strokeWeight(PLANE_THICKNESS);
    line(0,0,-PLANE_LENGTH,0);
    line(-WING_PROPORTION*PLANE_LENGTH,PLANE_WIDTH,-WING_PROPORTION*PLANE_LENGTH,-PLANE_WIDTH);
    popMatrix();
    
  }
  
  public void shoot(){
    
    bullets.add(new Bullet(x+1,y+1,direction));
    
  }
  
  
  public boolean checkHits(){
    
    
    
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
  public float getXLine(){
    
    return x - cos(direction)*PLANE_LENGTH;
    
  }
  
  public float getYLine(){
    
    return y - sin(direction)*PLANE_LENGTH;
    
  }
  // ----------------------------------------------------------------------------------
  public float getWing1X(){
    return x - cos(direction)*PLANE_LENGTH*WING_PROPORTION + sin(direction)*PLANE_WIDTH;
    
  }
  public float getWing1Y(){
    return y - sin(direction)*PLANE_LENGTH*WING_PROPORTION - cos(direction)*PLANE_WIDTH;
  }
  public float getWing2X(){
    return x - cos(direction)*PLANE_LENGTH*WING_PROPORTION - sin(direction)*PLANE_WIDTH;
  }
  public float getWing2Y(){
    return y - sin(direction)*PLANE_LENGTH*WING_PROPORTION + cos(direction)*PLANE_WIDTH;
  }
  
  public void startLeftTurn(){
      
      deltaDirection = -TURN_RADIUS;
    
  }
  
  public void startRightTurn(){
    
      deltaDirection = TURN_RADIUS;
      
    
  }
  
  public void endTurn(){
    
    
      deltaDirection = 0;

    
  }
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "test" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
