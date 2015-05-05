
class Bullet{ 
 
  float x;
  float y;
  float direction;
  float speed;
  
  boolean player;
  
  Bullet (float startX, float startY, float startDirection, boolean ifPlayer){
    
    x = startX;
    y = startY;
    direction = startDirection;
    
    speed = BASE_BULLET_SPEED;
    
    player = ifPlayer;
    
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
    
    if(x+(speed*2)>displayWidth || x-(speed*2) < 0 || y+(speed*2)>displayHeight || y-(speed*2)<0){
      return true;
    }else{
      return false;
    }
    
  }
  
  
  float getXLine(){
    
    return x + cos(direction)*speed*2;
    
  }
  
  float getYLine(){
    
    return y + sin(direction)*speed*2;
    
  }
  
  
}
