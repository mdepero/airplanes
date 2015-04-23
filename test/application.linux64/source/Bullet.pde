
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
  
  
}
