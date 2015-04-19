


float TURN_RADIUS = .1;
float BASE_SPEED = 5;

int FPS = 30;

int BASE_IMAGE_WIDTH = 40;


color BG_COLOR = color(13,210,224);

float CLOUD_SPEED = 2;
int CLOUD_WIDTH = 120;
int CLOUD_HEIGHT = 60;
float CLOUD_PROBABILITY = .06;

float BASE_BULLET_SPEED = 8;
float BULLET_THICKNESS = 4;

PImage PLANE_IMAGE;
PImage CLOUD_IMAGE;

Plane p1 = new Plane();

ArrayList<Cloud> clouds;
ArrayList<Bullet> bullets;


void setup(){
  
  // fps
  frameRate(FPS);
  
  PLANE_IMAGE = loadImage("plane.png");
  CLOUD_IMAGE = loadImage("cloud.png");
  
  clouds = new ArrayList<Cloud>();
  bullets = new ArrayList<Bullet>();
  
 
}


void draw(){
  drawBackground();
  
  updateBullets();
  
  p1.draw();
  
  p1.move();
  
  
}

void keyPressed(){
  
  if(key == 'd'){
    p1.startRightTurn();
  }
  
  if(key == 'a'){
    p1.startLeftTurn();
  }
  
  if(key == 'r'){
    p1.shoot();
  }
  
}

void keyReleased(){
  
  if(key == 'd'){
    p1.endRightTurn();
  }
  
  if(key == 'a'){
    p1.endLeftTurn();
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
  
  int level;
  float x;
  float y;
  float direction;
  float deltaDirection = 0;
  float speed;
  
  Plane(float startX,float startY,float startDirection){
    x = startX;
    y = startY;
    direction = startDirection;
    speed = BASE_SPEED;
    
  }
  
  Plane(){
    this(displayWidth/2.0,displayHeight/2.0,0);
    
  }
  
  void move(){
    direction += deltaDirection;
    x += cos(direction)*speed;
    y += sin(direction)*speed;
    
  }
  
  void draw(){
    
    imageMode(CENTER);
    // pushMatrix() and popMatrix() are called inside the class' display() method. 
    // This way, every object is rendered with its own independent translation and rotation
    pushMatrix(); 
    translate(x,y);
    rotate(direction);
    image(PLANE_IMAGE, 0, 0, BASE_IMAGE_WIDTH,BASE_IMAGE_WIDTH);
    popMatrix();
    
  }
  
  void shoot(){
    
    bullets.add(new Bullet(x+cos(direction)*BASE_IMAGE_WIDTH,y+sin(direction)*BASE_IMAGE_WIDTH,direction));
    
  }
  
  void startLeftTurn(){
    
    if(deltaDirection != -TURN_RADIUS){
      
      deltaDirection -= TURN_RADIUS;
      
    }
    
  }
  
  void startRightTurn(){
    
    if(deltaDirection != TURN_RADIUS){
    
      deltaDirection += TURN_RADIUS;
      
    }
    
  }
  
  void endLeftTurn(){
    
    if(deltaDirection == -TURN_RADIUS){
    
      deltaDirection += TURN_RADIUS;
      
    }
    
  }
  
  void endRightTurn(){
    
    if(deltaDirection == TURN_RADIUS){
    
      deltaDirection -= TURN_RADIUS;
      
    }
    
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
    line(x,y,x+cos(direction)*speed,y+sin(direction)*speed);
    
  }
  
  boolean isOffScreen(){
    
    if(x+speed>displayWidth || x-speed < 0 || y+speed>displayHeight || y-speed<0){
      return true;
    }else{
      return false;
    }
    
  }
  
  
  
}// end Bullet class


class Cloud {
  
  float x;
  float y;
  
  Cloud(float newX){
    x = newX;
    y = -20;
    
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
