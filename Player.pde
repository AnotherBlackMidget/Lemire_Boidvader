class Player extends GraphicObject 
{
  float topSpeed = 5;
  float topSteer = 0.05;
  
  float mass = 100;
  
  float theta = 15;
  float r = 10; // Rayon du boid
  
  PVector steer;

  PVector zeroVector = new PVector(0, 0);
  

  boolean dead = false;

  
  Player () 
  {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0,0);
    acceleration = new PVector();
    fillColor = color (70,130,180);
  }

  
  void checkEdges() 
  {
    if (location.x < 0) 
    {
      location.x = width - r;
    } 
    else if (location.x + r> width) 
    {
      location.x = 0;
    }
    
    if (location.y < 0) 
    {
      location.y = height - r;
    }
    else if (location.y + r> height) 
    {
      location.y = 0;
    }
  }

  void update(float deltaTime) 
  {
    keys();
    checkEdges();

    velocity.add (acceleration);
    velocity.limit(topSpeed);

    //theta = velocity.heading() + radians(90);

    location.add (velocity);

    acceleration.mult (0);      
  }
  
//======================================================================================================

void keys()
{
 if (keyPressed)
    {
      switch(key)
      {
        case 'w':
        player.applyForce(new PVector((15*cos(radians(player.theta))),(15*sin(radians(player.theta)))));
        break;
        
        case 'a':
        theta -= 5;
        break;
        
        case 'd':
        theta += 5;
        break;
      }
    } 
}
  
//======================================================================================================
  
  void display() 
  {
    noStroke();
    fill (fillColor);
    
    pushMatrix();
    translate(location.x, location.y);
    rotate (radians(theta+90));
    
    beginShape(TRIANGLES);
      vertex(0, -r * 2);
      vertex(-r, r * 2);
      vertex(r, r * 2);
    
    endShape();
    
    popMatrix();
  }
  
//======================================================================================================
  
  void applyForce (PVector force) 
  {
    PVector f;
    
    if (mass != 1)
    {
      f = PVector.div (force, mass);
    }  
    else
    {
      f = force;
    }
   
    this.acceleration.add(f);    
  }
  
//======================================================================================================
  
}
