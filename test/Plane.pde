
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
  
  void update(){
    
    move();
    
    draw();
    
    updateShooting();
    
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
  
  void updateShooting(){
    
    if(shooting && coolDown == 0){
      
      shoot();
      
      coolDown = COOL_DOWN_TIME;
      
    }
    
    if(coolDown>0){
      coolDown--;
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
  
}
