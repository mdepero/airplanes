
class Cloud{


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
  
  
}
