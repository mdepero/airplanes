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

public class AirplaneGame extends PApplet {




String GAME_TITLE = "The Airplane Game";
String AUTHOR = "Matt DePero";


String GAME_OVER = "GAME OVER";
String START_MENU_INSTRUCTIONS_1 = "Choose One Player or Two Player to Start";
String START_MENU_INSTRUCTIONS_2 = "Press Any Other Button to QUIT";
String IN_GAME_INSTRUCTIONS = "Start Button To Quit";


int FPS = 45;

int PLANE_LENGTH = 90;
int PLANE_WIDTH = 60;
int PLANE_THICKNESS = 9;
float WING_PROPORTION = .3f;
int DEFAULT_PLANE_X = 810;
int DEFAULT_PLANE_Y = 540;
int DEFAULT_PLAYER_HEALTHLEVEL = 10;
int DEFAULT_ENEMY_HEALTHLEVEL = 2;
int COOL_DOWN_TIME = 10;
int COOL_DOWN_TIME_ENEMY = 100;

int PLAYER_ONE_BEZEL_COLOR = 0xff0000FF;
int PLAYER_TWO_BEZEL_COLOR = 0xffFF0000;
int PLAYER_BEZEL_THICKNESS = 8;

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

String cloudImageFileName = "cloud.png";



// PImage PLANE_IMAGE;
PImage CLOUD_IMAGE;



PFont BIG_FONT;
PFont SMALL_FONT;
// String fontFileName = "atarifull.ttf";
int fontColor = color(0,0,0,120);
int bigFontSize = 80;
int smallFontSize = 28;


// Game Objects
int NUM_OF_PLAYERS = 1;

int score = 0;

Plane p1;
Plane p2;

ArrayList<Cloud> clouds;
ArrayList<Bullet> bullets;
ArrayList<Plane> allPlanes;


int gameStatus = GameStatus.StartMenu;

int winner = 0;


public void setup(){
  
  // fps
  frameRate(FPS);
  
  CLOUD_IMAGE = loadImage(cloudImageFileName);
  
  BIG_FONT = createFont("Atari Font Full Version", bigFontSize);
  
  SMALL_FONT = createFont("Atari Font Full Version", smallFontSize);
  
  clouds = new ArrayList<Cloud>();
  bullets = new ArrayList<Bullet>();
  allPlanes = new ArrayList<Plane>();
  
  
 
}


public void draw(){
  drawBackground();
  
  switch(gameStatus){
    
   case GameStatus.StartMenu:
    
     clearGame();
     drawStartMenu();
     break;
      
   case GameStatus.InGame:
   
     updateBullets();
     updatePlanes();
     
     break;
     
   case GameStatus.GameOver:
   
     clearGame();
     drawGameOverMenu();
     break;
    
  }
  
  
}

public void keyPressed(){
  
  if(gameStatus == GameStatus.InGame){
  
    if(key == Buttons.PLAYER_1_JOYSTICK_RIGHT){
      p1.startRightTurn();
    }
    
    if(key == Buttons.PLAYER_1_JOYSTICK_LEFT){
      p1.startLeftTurn();
    }
    
    if(key == Buttons.PLAYER_1_BUTTON_1){
      p1.shooting = true;
    }
    
    if(NUM_OF_PLAYERS == 2){
    
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
    
    if(Buttons.isStartButton(key)){
      gameStatus = GameStatus.StartMenu;
    }
    
  }else if(gameStatus == GameStatus.StartMenu){
    
    if(key == Buttons.PLAYER_1_START){
      startGame(1);
    }
    if(key == Buttons.PLAYER_2_START){
      startGame(2);
    }
    if(Buttons.isAnyButton(key)){
      exit();
    }
    
  }else if(gameStatus == GameStatus.GameOver){
    if(Buttons.isStartButton(key)){
      gameStatus = GameStatus.StartMenu;
    }
    
  }
  
}

public void keyReleased(){
  
  if(gameStatus == GameStatus.InGame){
  
    if(key == Buttons.PLAYER_1_JOYSTICK_RIGHT || key == Buttons.PLAYER_1_JOYSTICK_LEFT){
      p1.endTurn();
    }
    
    if(key == Buttons.PLAYER_1_BUTTON_1){
      p1.shooting = false;
    }
    
    if(NUM_OF_PLAYERS == 2){
    
      if(key == Buttons.PLAYER_2_JOYSTICK_RIGHT || key == Buttons.PLAYER_2_JOYSTICK_LEFT){
        p2.endTurn();
      }
      
      if(key == Buttons.PLAYER_2_BUTTON_1){
        p2.shooting = false;
      }
      
    }
  
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
      
      // After removing that plane, check if it triggered an end game
      
      
      if(allPlanes.size() == 1 && NUM_OF_PLAYERS != 2 && allPlanes.contains(p1)){
        // Single player game and all enemies cleared, next level
        score += 100;
        
        nextLevel();
      }
      
      if(NUM_OF_PLAYERS != 2 && !allPlanes.contains(p1)){
        // single player game who just lost
        
        gameStatus = GameStatus.GameOver;
      }
      
      if(allPlanes.size() <= 1 && NUM_OF_PLAYERS == 2){
        // Two player game, someone won
        if(allPlanes.contains(p1)){
          winner = 1;
        }
        if(allPlanes.contains(p2)){
          winner = 2;
        }
        gameStatus = GameStatus.GameOver;
      }
      
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
  
  if(gameStatus == GameStatus.InGame && NUM_OF_PLAYERS != 2){
    
    textAlign(LEFT, BOTTOM);
    fill(fontColor);
    
    textFont(SMALL_FONT);
    text("Score: "+score,10,height - 10);
    
  }
  
  if(gameStatus == GameStatus.InGame){
    
    textAlign(RIGHT, BOTTOM);
    fill(fontColor);
    
    textFont(SMALL_FONT);
    text(IN_GAME_INSTRUCTIONS,width - 10,height - 10);
    
  }
  
}


public void startGame(int numOfPlayers){
  
  clearGame();
  
  score = 0;
  
  winner = 0;
  
  NUM_OF_PLAYERS = numOfPlayers;
  
  p1 = new Plane(0, 1);
  allPlanes.add(p1);
  
  if(NUM_OF_PLAYERS == 2){
    p2 = new Plane(PI, 2);
    allPlanes.add(p2);
  }else{
    
    allPlanes.add(new Plane(3*PI/2));
  }
  
  gameStatus = GameStatus.InGame;
  
  
}


public void nextLevel(){
  
  for(int i = 0;i < (score/100)+1;i++){
    
    switch(i % 4){
      case 0:
        allPlanes.add(new Plane(0,0,(float)(Math.random()*(height*.8f)+(.1f*height))));
        break;
      case 1:
        allPlanes.add(new Plane(PI,width,(float)(Math.random()*(height*.8f)+(.1f*height))));
        break;
      case 2:
        allPlanes.add(new Plane((3*PI)/2,(float)(Math.random()*(width*.8f)+(.1f*width)),0));
        break;
      case 3:
        allPlanes.add(new Plane(PI/2,(float)(Math.random()*(width*.8f)+(.1f*width)),height));
        break;
    }
    
  }
  
}


public void drawStartMenu(){
  
  textAlign(CENTER, CENTER);
  fill(fontColor);
  
  textFont(BIG_FONT);
  text(GAME_TITLE,width/2,100);
  
  textFont(SMALL_FONT);
  text("By: Matt DePero",(2*width)/3,120 + bigFontSize);
  
  text(START_MENU_INSTRUCTIONS_1,width/2,height-60-smallFontSize);
  text(START_MENU_INSTRUCTIONS_2,width/2,height-50);
  
}



public void clearGame(){
  // if any display objects remove, get rid of them
  
  if(allPlanes.size() > 0 || bullets.size() > 0){
    
    for(int i = allPlanes.size() - 1; i>=0; i--){
      allPlanes.remove(i);
    }
    
    for(int i = bullets.size() - 1; i>=0; i--){
      bullets.remove(i);
    }
    
  }
  
}
    
    
    
public void drawGameOverMenu(){
  
  textAlign(CENTER, CENTER);
  fill(fontColor);
  
  textFont(BIG_FONT);
  text(GAME_TITLE,width/2,100);
  
  text(GAME_OVER,width/2,height/2 - (bigFontSize/2) - 10);
  
  if(NUM_OF_PLAYERS == 2){
    
    if(winner == 1){
      text("Player One Wins!",width/2,height/2 + (bigFontSize/2) + 10);
    }else{
      text("Player Two Wins!",width/2,height/2 + (bigFontSize/2) + 10);
    }
    
  }else{
    text("Score: " + score,width/2,height/2 + (bigFontSize/2) + 10);
  }
  
  textFont(SMALL_FONT);
  text("By: " + AUTHOR,(2*width)/3,120 + bigFontSize);
  
  text("Press Either Start Button",width/2,height-60-smallFontSize);
  text("To Return to Menu",width/2,height-50);
  
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
  
  int player;
  
  Bullet (float startX, float startY, float startDirection, int ifPlayer){
    
    x = startX;
    y = startY;
    direction = startDirection;
    
    speed = BASE_BULLET_SPEED;
    
    player = ifPlayer;
    
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
    
    if(x+(speed*2)>displayWidth || x-(speed*2) < 0 || y+(speed*2)>displayHeight || y-(speed*2)<0){
      return true;
    }else{
      return false;
    }
    
  }
  
  
  public float getXLine(){
    
    return x + cos(direction)*speed*2;
    
  }
  
  public float getYLine(){
    
    return y + sin(direction)*speed*2;
    
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
  
  boolean shooting;
  int coolDown = 0;
  int coolDownTime;
  
  int player;
  
  String name;
  
  Plane(float startX,float startY,float startDirection,float startSpeed, int ifPlayer){
    x = startX;
    y = startY;
    direction = startDirection;
    speed = startSpeed;
    if(ifPlayer == 1 || ifPlayer == 2){
      healthLevel = DEFAULT_PLAYER_HEALTHLEVEL;
      shooting = false;
      coolDownTime = COOL_DOWN_TIME;
    }else{
      healthLevel = DEFAULT_ENEMY_HEALTHLEVEL;
      shooting = true;
      coolDownTime = COOL_DOWN_TIME_ENEMY;
      coolDown = (int)(Math.random()*COOL_DOWN_TIME_ENEMY);
    }
    
    player = ifPlayer;
    
    
  }
  
  Plane(){
    
    this(DEFAULT_PLANE_X,DEFAULT_PLANE_Y,0,BASE_SPEED, 0);
    
  }
  
  Plane(float startDirection, int ifPlayer){
    
    this(DEFAULT_PLANE_X,DEFAULT_PLANE_Y, startDirection ,BASE_SPEED, ifPlayer);
    
  }
  
  Plane(float startDirection){
    
    this(DEFAULT_PLANE_X,DEFAULT_PLANE_Y, startDirection ,BASE_SPEED, 0);
    
  }
  
  Plane(float startDirection, float startx, float starty){
    
    this(startx, starty, startDirection ,BASE_SPEED, 0);
    
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
      
      coolDown = coolDownTime;
      
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
    
    
    
    // set plane health colors
    if(player == 1 || player == 2){
      
      // Draw player bezels
      if( player == 1 ){
        stroke(PLAYER_ONE_BEZEL_COLOR);
        strokeWeight(PLANE_THICKNESS + PLAYER_BEZEL_THICKNESS);
        line(0,0,-PLANE_LENGTH,0);
        line(-WING_PROPORTION*PLANE_LENGTH,PLANE_WIDTH,-WING_PROPORTION*PLANE_LENGTH,-PLANE_WIDTH);
      }
      if( player == 2 ){
        stroke(PLAYER_TWO_BEZEL_COLOR);
        strokeWeight(PLANE_THICKNESS + PLAYER_BEZEL_THICKNESS);
        line(0,0,-PLANE_LENGTH,0);
        line(-WING_PROPORTION*PLANE_LENGTH,PLANE_WIDTH,-WING_PROPORTION*PLANE_LENGTH,-PLANE_WIDTH);
        
      }
      
      
      stroke((int)(255*((DEFAULT_PLAYER_HEALTHLEVEL*1.0f-healthLevel)/DEFAULT_PLAYER_HEALTHLEVEL)),
      (int)(255*(healthLevel*1.0f/DEFAULT_PLAYER_HEALTHLEVEL)), 0);
    }else{
      stroke((int)(255*((DEFAULT_PLAYER_HEALTHLEVEL*1.0f-healthLevel)/DEFAULT_PLAYER_HEALTHLEVEL)),
     (int)(255*(healthLevel*1.0f/DEFAULT_ENEMY_HEALTHLEVEL)) ,0);
    }
     
     
    strokeWeight(PLANE_THICKNESS);
    line(0,0,-PLANE_LENGTH,0);
    line(-WING_PROPORTION*PLANE_LENGTH,PLANE_WIDTH,-WING_PROPORTION*PLANE_LENGTH,-PLANE_WIDTH);
    popMatrix();
    
  }
  
  public void shoot(){
    
    bullets.add(new Bullet(x+1,y+1,direction, player));
    
  }
  
  
  public boolean checkHits(){
    
    
    
    for(int i = bullets.size()-1;i >= 0;i--){
      
      Bullet b = bullets.get(i);
      
      if(  (    
          Line2D.linesIntersect(b.x,b.y,b.getXLine(),b.getYLine(),x,y,getXLine(),getYLine()) ||
          Line2D.linesIntersect(b.x,b.y,b.getXLine(),b.getYLine(),getWing1X(),getWing1Y(),getWing2X(),getWing2Y())   
            )
            &&  b.player != player){
              
           
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
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "AirplaneGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
