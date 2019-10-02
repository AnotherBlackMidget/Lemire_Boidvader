int currentTime;
int previousTime;
int deltaTime;

ArrayList<Mover> flock;
int flockSize = 50;

ArrayList<Laser> magazine;
int nbLasers = 5;

ArrayList<Explosion> kaboom;

Player player;

boolean debug;
boolean debounce;
boolean hit;
boolean gameOver;
boolean gameWon;
PVector temPo;
int cooldown;
int points = 0;

int quart;
PVector spawn;

void setup () {
  fullScreen(P2D);
  currentTime = millis();
  previousTime = millis();
  
  debug = false;
  debounce = false;
  hit = false;
  gameOver = false;
  gameWon = false;
  cooldown = 100;
  
  
  flock = new ArrayList<Mover>();
  magazine = new ArrayList<Laser>();
  kaboom = new ArrayList<Explosion>();
  
  quart = (int) random(1,4);
  switch(quart)
  {
    case 1:
    spawn = new PVector(random(0, width/8), random(0, height/8));
    break;
    
    case 2:
    spawn = new PVector(random(width-width/8, width), random(0, height/8));
    break;
    
    case 3:
    spawn = new PVector(random(0, width/8), random(height-height/8, height));
    break;
    
    case 4:
    spawn = new PVector(random(width-width/8, width), random(height-height/8, height));
    break;
  }
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(spawn.x, spawn.y), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(255,255,255);
    flock.add(m);
    println(spawn);
  }
  
  
  player = new Player();
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  display();  
}

/***
  The calculations should go here
*/
void update(int delta)
{
  cooldown += delta;
  if (keyPressed)
  {
    if (key == ' ' && magazine.size() < 5 && cooldown>100 && gameOver==false)
    {         
      Laser l = new Laser(new PVector(player.location.x, player.location.y), new PVector((15*cos(radians(player.theta))),(15*sin(radians(player.theta)))), player.theta);
      magazine.add(l);
      cooldown = 0;
    }
  }
  
  for (Laser l : magazine) 
  {
    l.update(delta);
    if(l.checkEdges())
    {
      magazine.remove(l);
      break;
    }
  }
  
  if(gameOver==false)
  {
    player.update(delta);
  }
  
  for (Mover m : flock) 
  {
    m.flock(flock);
    m.update(delta);
  }
  
  for (Explosion e : kaboom) 
  {
    if(e.timer > 0)
    {
      e.update(delta);
    }
    else
    {
      kaboom.remove(e);
      break;
    }
  }
  
  hit = false;
  for (Laser l : magazine) 
  {
    for (Mover m : flock) 
    {
      if(PVector.dist(m.location, l.location) < 20)
      {
        hit = true;
        temPo = m.location;
      }
      
      if(hit == true)
      {
        flock.remove(m);
        points += 10;
        break;
      }
    }
    
    if(hit == true)
    {
      magazine.remove(l);
      
      Explosion e = new Explosion(temPo);
      kaboom.add(e);
      
      break;
    }
  }
  
  for (Mover m : flock) 
  {
    if(PVector.dist(m.location, player.location) < 20 && gameOver==false)
    {
      gameOver=true;
      Explosion e = new Explosion(new PVector(player.location.x, player.location.y));
      kaboom.add(e);
    }
  }
  
  if(flock.size() == 0)
  {
    gameWon = true;
  }
  
  
}

/***
  The rendering should go here
*/
void display () 
{
  background(0);
  
  if(gameOver==false)
  {
    player.display();
  }
  
  for (Laser l : magazine) 
  {
    l.display();
  }
  
  for (Mover m : flock) 
  {
    m.display();
  }
  
  for (Explosion e : kaboom) 
  {
    e.display();
  }
  
  if(gameOver==true)
  {
    fill(255,0,0,255);
    textSize(200);
    textAlign(CENTER,BOTTOM);
    text("YOU LOSE!", width/2, height/2);
    textSize(50);
    textAlign(CENTER,TOP);
    text("PRESS R TO PLAY AGAIN", width/2, height/2);
  }
  
  if(gameWon==true)
  {
    fill(0,255,0,255);
    textSize(200);
    textAlign(CENTER,BOTTOM);
    text("YOU WIN!", width/2, height/2);
    textSize(50);
    textAlign(CENTER,TOP);
    text("PRESS R TO PLAY AGAIN", width/2, height/2);
  }
  
  fill(255,255,0,255);
  textAlign(LEFT,TOP);
  textSize(50);
  text(points, 0, 0);
}

void keyPressed() 
{
  switch (key) 
  {
    case 'r':
        if(gameOver==true || gameWon==true)
        {
          if(gameOver==true) points = 0;
          setup();
        }
      break;
  }
}

void keyReleased()
{
  
}
