class Laser extends GraphicObject
{
  float topSpeed;
  float mass;
  float size;
  float theta;
  
  int canonX, canonY;
   
//======================================================================================================   
  
  Laser (PVector loc, PVector vel, float thet) 
  {
    location = loc;
    velocity = vel;
    theta = thet;
    acceleration = new PVector (0 , 0);
    
    topSpeed = 100;
    
    mass = 20;
    size = 40;
  }

//======================================================================================================  
  
  void update (float deltaTime) 
  {
    velocity.add (acceleration);
    location.add (velocity);

    acceleration.mult (0);
  }
  
//======================================================================================================  
  
  void display ()
  {
    pushMatrix();
    translate(location.x, location.y);
    rotate (radians(theta));

    noStroke();
    fill (255, 0, 0, 255);
    ellipse (0, 0, 50, 5); // Dimension à l'échelle de la masse

    popMatrix();
    
  }
  
//======================================================================================================  
  
  boolean checkEdges() 
  {
    if (location.x > width + 50) 
    {
      return true;
    } 
    else if (location.x < -50) 
    {
      return true;
    }
    else if (location.y > height +50) 
    {
      return true;
    }
    else if(location.y < -50)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
//======================================================================================================  
 
  void applyForce (PVector force) 
  {
    PVector f = PVector.div (force, mass);
   
    this.acceleration.add(f);
  }
  
//======================================================================================================

}
