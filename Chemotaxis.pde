class Food
{
  float foodX, foodY;
  float value, d;
  boolean isAlive;
  Food()
  {
    foodX = (float)(Math.random()* 1600 - 800);
    while(Math.abs(foodX) < 100)
      foodX = (float)(Math.random()* 1600 - 800);
    foodY = (float)(Math.random()* 1600 - 800);
    while(Math.abs(foodY) < 100)
      foodY = (float)(Math.random()* 1600 - 800);
    isAlive = true;
    value = (float)(Math.random() * 450) + (Math.abs(foodX)/2) + (Math.abs(foodY)/2);
    d = 2*(sqrt(value/PI));
  }
  
  void createGen()
  {
    foodX = (float)(Math.random()* 1600 - 800);
    while(Math.abs(foodX) < 100)
      foodX = (float)(Math.random()* 1600 - 800);
    foodY = (float)(Math.random()* 1600 - 800);
    while(Math.abs(foodY) < 100)
      foodY = (float)(Math.random()* 1600 - 800);
  }
 
  void regen()
  {
    int spawnRange = (int)(Math.random() * 4) + 1;
    if(isAlive == false)
      {
         value += (float)(Math.random() * 100);
         isAlive = true;
         d = 2*(sqrt(value/PI));
      }
    if(spawnRange == 1)
    {
      foodX = (float)(Math.random()* 400 - 800);
      foodY = (float)(Math.random()* 1200 - 800);
    }
    if(spawnRange == 2)
    {
      foodX = (float)(Math.random()* 1200 - 400);
      foodY = (float)(Math.random()* 400 - 800);
    }
    if(spawnRange == 3)
    {
      foodX = (float)(Math.random()* 400 + 400);
      foodY = (float)(Math.random()* 1200 - 400);
    }
    if(spawnRange == 4)
    {
      foodX = (float)(Math.random()* 1200 - 800);
      foodY = (float)(Math.random()* 400 + 400);
    }
  }
 
  void show()
  {
    if(isAlive == true)
      ellipse(foodX, foodY, d, d);
  }
  
  void kill()
  {
    isAlive = false;
  }
}

class Runner
{
  float runX, runY;
  boolean isAlive;
  Runner()
  {
    runX = (float)(Math.random()*401 + 50);
    runY = (float)(Math.random()*401 + 50);
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
    d = 2*(sqrt(area/PI));
  }
 
  void show()
  {
    ellipse(0, 0, d, d);
  }
}

class Grid
{
  float x;
  float y;
  Grid(float xPos, float yPos)
  {
    x = xPos;
    y = yPos;
  }
  
  void drawLinesLR()
  {
    line(-400, y, 400, y);
  }
  
  void drawLinesUD()
  {
    line(x, -400, x, 400);
  }
}

Food [] orb;
Cell agar = new Cell();
Grid [] lr, ud;
void setup()
{
  orb = new Food[80];
  lr = new Grid[5];
  ud = new Grid[5];
  fill(0);
  for(int i = 0; i < lr.length; i++)
  {
    lr[i] = new Grid(0, -400 + i*200);
    lr[i].drawLinesLR();
    ud[i] = new Grid(-400 + i*200, 0);
    ud[i].drawLinesUD();
  }
  fill(255);
  for(int i = 0; i < orb.length; i++)
  {
    orb[i] = new Food();
    for(int x = 0; x < i; x++)
    {
      if(Math.abs(orb[i].foodX - orb[x].foodX) <= 10)
      {
        orb[i].createGen();
        x = 0;
      }
      if(Math.abs(orb[i].foodY - orb[x].foodY) <= 10)
      {
        orb[i].createGen();
        x = 0;
      }
    }
  }
  size(800, 800);
  strokeWeight(2);
  translate(width/2, height/2);
  agar.show();
}

boolean isUp, isDown, isLeft, isRight;

void draw()
{
  background(200);
  translate(width/2, height/2);
  moveScreen();
  stroke(0, 0, 0, 100);
  for(int i = 0; i < lr.length; i++)
  {
    if(lr[i].y > 400) lr[i].y -= 800;
    if(lr[i].y < -400) lr[i].y += 800;
    lr[i].drawLinesLR();
    if(ud[i].x > 400) ud[i].x -= 800;
    if(ud[i].x < -400) ud[i].x += 800;
    ud[i].drawLinesUD();
  }
  stroke(0, 0, 0, 255);
  for(int i = 0; i < orb.length; i++)
  {
    orb[i].show();
  }
  agarEat();
  agar.show();
  //System.out.println(ate);
}

void agarEat()
{
  for(int x = 0; x < orb.length; x++)
  {
    for(int i = 0; i < 90; i++)
    {
      if(Math.abs(orb[x].foodX) <= (agar.d/2) * cos(radians(i)) - (orb[x].d/8) && Math.abs(orb[x].foodY) <= (agar.d/2) * sin(radians(i)) - (orb[x].d/8) && agar.area > (orb[x].value)*1.05) //make based off of size of orb, not radius of cell-- 
      {
        agar.grow(orb[x].value/5);
        orb[x].kill();
        orb[x].regen();
      }
    }
  }
}

void moveScreen()
{
  if(isUp == true)
  {
    for(int i = 0; i < orb.length; i++)
    {
      if(isRight == true || isLeft == true)
        orb[i].foodY += sqrt(2);
      else orb[i].foodY += 2;
    }
    for(int i = 0; i < lr.length; i++)
    {
      if(isRight == true || isLeft == true)
      {
        lr[i].y += sqrt(2);
        ud[i].y += sqrt(2);
      }
      else
      {
        lr[i].y += 2;
        ud[i].y += 2;
      }
    }
  }
  if(isDown == true)
  {
    for(int i = 0; i < orb.length; i++)
    {
      if(isRight == true || isLeft == true)
        orb[i].foodY -= sqrt(2);
      else orb[i].foodY -= 2;
    }
    for(int i = 0; i < lr.length; i++)
    {
      if(isRight == true || isLeft == true)
      {
        lr[i].y -= sqrt(2);
        ud[i].y -= sqrt(2);
      }
      else
      {
        lr[i].y -= 2;
        ud[i].y -= 2;
      }
    }
  }
  if(isRight == true)
  {
    for(int i = 0; i < orb.length; i++)
    {
      if(isUp == true || isDown == true)
        orb[i].foodX -= sqrt(2);
      else orb[i].foodX -= 2;
    }
    for(int i = 0; i < lr.length; i++)
    {
      if(isUp == true || isDown == true)
      {
        lr[i].x -= sqrt(2);
        ud[i].x -= sqrt(2);
      }
      else
      {
        lr[i].x -= 2;
        ud[i].x -= 2;
      }
    }
  }
  if(isLeft == true)
  {
    for(int i = 0; i < orb.length; i++)
    {
      if(isUp == true || isDown == true)
        orb[i].foodX += sqrt(2);
      else orb[i].foodX += 2;
    }
    for(int i = 0; i < lr.length; i++)
    {
      if(isUp == true || isDown == true)
      {
        lr[i].x += sqrt(2);
        ud[i].x += sqrt(2);
      }
      else
      {
        lr[i].x += 2;
        ud[i].x += 2;
      }
    }
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
      //agar.grow(1000);
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

//make Runner work properly, eat and disappear
