class Food
{
  int foodX, foodY;
  float value;
  boolean isAlive;
  Food()
  {
    foodX = (int)(Math.random()* 1600 - 800);
    while(Math.abs(foodX) < 100)
      foodX = (int)(Math.random()* 1600 - 800);
    foodY = (int)(Math.random()* 1600 - 800);
    while(Math.abs(foodY) < 100)
      foodY = (int)(Math.random()* 1600 - 800);
    isAlive = true;
    value = (float)(Math.random() * 400 - 150);
  }
 
  void regen()
  {
    //if isAlive = false make value increase :)
    isAlive = true;
    foodX = (int)(Math.random()* 1600 - 800);
    while(Math.abs(foodX) < 100)
      foodX = (int)(Math.random()* 1600 - 800);
    foodY = (int)(Math.random()* 1600 - 800);
    while(Math.abs(foodY) < 100)
      foodY = (int)(Math.random()* 1600 - 800);
  }
 
  void show()
  {
    if(isAlive == true)
      ellipse(foodX, foodY, 2*(sqrt(value/PI)), 2*(sqrt(value/PI)));
  }
}

class Runner
{
  int runX, runY;
  boolean isAlive;
  Runner()
  {
    runX = (int)(Math.random()*401 + 50);
    runY = (int)(Math.random()*401 + 50);
  }
 
  void run()
  {
    //make run away from character
  }
}

class Cell
{
  float area, d;
  Cell()
  {
    area = 500;
    d = 2*(sqrt(area/PI));
  }
 
  void grow(float amount)
  {
    area += amount;
  }
 
  void show()
  {
    ellipse(0, 0, d, d);
  }
}

Food [] orb;
Cell agar = new Cell();
void setup()
{
  orb = new Food[40];
  for(int i = 0; i < orb.length; i++)
  {
    orb[i] = new Food();
    for(int x = 0; x < i; x++)
    {
      if(Math.abs(orb[i].foodX - orb[x].foodX) <= 10)
      {
        orb[i].regen();
        x = 0;
      }
      if(Math.abs(orb[i].foodY - orb[x].foodY) <= 10)
      {
        orb[i].regen();
        x = 0;
      }
    }
  }
  size(800, 800);
  translate(width/2, height/2);
  agar.show();
}

boolean isUp, isDown, isLeft, isRight;

void draw()
{
  background(200);
  translate(width/2, height/2);
  moveScreen();
  for(int i = 0; i < orb.length; i++)
  {
    orb[i].show();
  }
  //agar.grow(1000);
  agar.show();
}

void agarEat()
{
  for(int x = 0; x < orb.length; x++)
  {
    for(int i = 0; i < 360; i++)
    {
      if(Math.abs(orb[x].foodX) <= agar.d*cos(radians(i)) && Math.abs(orb[x].foodY) <= agar.d*sin(radians(i)))
      {
        agar.grow(orb[x].value);
        orb[x].isAlive = false;
      }
    }
  }
}

void moveScreen()
{
  if(isUp == true)
    for(int i = 0; i < orb.length; i++)
    {
      orb[i].foodY += 1;
    }
  if(isDown == true)
    for(int i = 0; i < orb.length; i++)
    {
      orb[i].foodY -= 1;
    }
  if(isRight == true)
    for(int i = 0; i < orb.length; i++)
    {
      orb[i].foodX -= 1;
    }
  if(isLeft == true)
    for(int i = 0; i < orb.length; i++)
    {
      orb[i].foodX += 1;
    }
    for(int i = 0; i < orb.length; i++)
    {
      if(orb[i].foodY < -800)
        orb[i].foodY = 800;
      if(orb[i].foodY > 800)
        orb[i].foodY = -800;
      if(orb[i].foodX < -800)
        orb[i].foodX = 800;
      if(orb[i].foodX > 800)
        orb[i].foodX = -800;
    }
}

void keyPressed()
{
  moveDir(key, true);
}

void keyReleased()
{
  moveDir(key, false);
}

boolean moveDir(char c, boolean b)
{
  switch(c) {
    case ' ':
      agar.grow(1000);
      return b;
     
    case 'W':
      return isUp = b;
    case 'w':
      return isUp = b;
     
    case 'A':
      return isLeft = b;
    case 'a':
      return isLeft = b;
     
    case 'S':
      return isDown = b;
    case 's':
      return isDown = b;
     
    case 'D':
      return isRight = b;
    case 'd':
      return isRight = b;
     
    default: return b;
  }
}

//make character that follows mouse, but not precisely (moves towards it)
//make both Runner and Food work properly, eat and disappear
//make character have "area" variable, where it's diameter is sqrt(area/pi)
