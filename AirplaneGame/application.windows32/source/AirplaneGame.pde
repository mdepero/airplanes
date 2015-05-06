
import java.awt.geom.Line2D;

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
float WING_PROPORTION = .3;
int DEFAULT_PLANE_X = 810;
int DEFAULT_PLANE_Y = 540;
int DEFAULT_PLAYER_HEALTHLEVEL = 10;
int DEFAULT_ENEMY_HEALTHLEVEL = 2;
int COOL_DOWN_TIME = 10;
int COOL_DOWN_TIME_ENEMY = 100;

color PLAYER_ONE_BEZEL_COLOR = #0000FF;
color PLAYER_TWO_BEZEL_COLOR = #FF0000;
int PLAYER_BEZEL_THICKNESS = 8;

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

String cloudImageFileName = "cloud.png";



// PImage PLANE_IMAGE;
PImage CLOUD_IMAGE;



PFont BIG_FONT;
PFont SMALL_FONT;
// String fontFileName = "atarifull.ttf";
color fontColor = color(0,0,0,120);
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


void setup(){
  
  // fps
  frameRate(FPS);
  
  CLOUD_IMAGE = loadImage(cloudImageFileName);
  
  BIG_FONT = createFont("Atari Font Full Version", bigFontSize);
  
  SMALL_FONT = createFont("Atari Font Full Version", smallFontSize);
  
  clouds = new ArrayList<Cloud>();
  bullets = new ArrayList<Bullet>();
  allPlanes = new ArrayList<Plane>();
  
  
 
}


void draw(){
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

void keyPressed(){
  
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

void keyReleased(){
  
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


void startGame(int numOfPlayers){
  
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


void nextLevel(){
  
  for(int i = 0;i < (score/100)+1;i++){
    
    switch(i % 4){
      case 0:
        allPlanes.add(new Plane(0,0,(float)(Math.random()*(height*.8)+(.1*height))));
        break;
      case 1:
        allPlanes.add(new Plane(PI,width,(float)(Math.random()*(height*.8)+(.1*height))));
        break;
      case 2:
        allPlanes.add(new Plane((3*PI)/2,(float)(Math.random()*(width*.8)+(.1*width)),0));
        break;
      case 3:
        allPlanes.add(new Plane(PI/2,(float)(Math.random()*(width*.8)+(.1*width)),height));
        break;
    }
    
  }
  
}


void drawStartMenu(){
  
  textAlign(CENTER, CENTER);
  fill(fontColor);
  
  textFont(BIG_FONT);
  text(GAME_TITLE,width/2,100);
  
  textFont(SMALL_FONT);
  text("By: Matt DePero",(2*width)/3,120 + bigFontSize);
  
  text(START_MENU_INSTRUCTIONS_1,width/2,height-60-smallFontSize);
  text(START_MENU_INSTRUCTIONS_2,width/2,height-50);
  
}



void clearGame(){
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
    
    
    
void drawGameOverMenu(){
  
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
