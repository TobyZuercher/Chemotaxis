class Food
{
  float foodX, foodY;
  float value, d;
  boolean isAlive;
  Food()
  {
    foodX = (int)(Math.random()* 10001 - 5000);
    foodY = (int)(Math.random()* 10001 - 5000);
    
    isAlive = true;
    value = (float)(Math.random() * 450) + (Math.abs(foodX)/2) + (Math.abs(foodY)/2);
    d = 2*(sqrt(value/PI));
  }
 
  void regen()
  {
    float outX = 0;
    float outY = 0;
    
    if(xTotal > 5000 - width/2)
      outX = xTotal - (5000 - width/2);
    if(xTotal < -5000 + width/2)
      outX = xTotal + (5000 + width/2);
      
    if(yTotal > 5000 - height/2)
      outY = yTotal - (5000 - height/2);
    if(yTotal < -5000 + height/2)
      outY = yTotal + (5000 + height/2);
      
      
    int[] pos = spawnZone(-5000 - (int)xTotal - (int)outX, -width/2, width/2, 5000 - (int)xTotal - (int)outX, -5000 - (int)yTotal - (int)outY, -height/2, height/2, 5000 - (int)yTotal - (int)outY);
    
    foodX = pos[0];
    foodY = pos[1];
    
    if(isAlive == false)
      {
         value += (float)(Math.random() * 450 + 300) + (Math.abs(foodX)/2) + (Math.abs(foodY)/2);
         isAlive = true;
         d = 2*(sqrt(value/PI));
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
    if(yTotal > 5000)
      y = 5000;
    if(yTotal < -5000)
      y = -5000;
    line(x - 5000, y, x + 5000, y);
  }
  
  void drawLinesUD()
  {
    if(xTotal > 5000)
      x = 5000;
    if(xTotal < -5000)
      x = -5000;
    line(x, y - 5000, x, y + 5000);
  }
}

Food [] orb;
Cell agar = new Cell();
Grid [] lr, ud;
void setup()
{
  colorMode(RGB, 255, 255, 255, 255);
  orb = new Food[1562];
  lr = new Grid[height/160 - 1];
  ud = new Grid[width/160 - 1];
  fill(0);
  for(int i = 0; i < lr.length; i++)
  {
    lr[i] = new Grid(0, -height/2 + i*200);
    lr[i].drawLinesLR();
    ud[i] = new Grid(-width/2 + i*200, 0);
    ud[i].drawLinesUD();
  } 
  fill(255);
  for(int i = 0; i < orb.length; i++)
    orb[i] = new Food();
    
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
    if(lr[i].y > height/2 && !(yTotal - 200 > (5000 - height/2))) lr[i].y -= height;
    if(lr[i].y < -height/2 && !(yTotal + 200 < (-5000 + height/2))) lr[i].y += height;
    lr[i].drawLinesLR();
    if(ud[i].x > width/2 && !(xTotal - 200 > (5000 - width/2))) ud[i].x -= width;
    if(ud[i].x < -width/2 && !(xTotal + 200 < (-5000 + width/2))) ud[i].x += width;
    ud[i].drawLinesUD();
  }
  stroke(0, 0, 0, 255);
  for(int i = 0; i < orb.length; i++)
  {
    orb[i].show();
  }
  agarEat();
  agar.show();
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

float xTotal = 0;
float yTotal = 0;
void moveScreen()
{
  float xOffset = 0;
  float yOffset = 0;
  if(isUp == true)
  {
    if(yTotal > 4996 && yTotal < 5000)
      yOffset = 5000 - yTotal;
    else if (!(yTotal >= 5000))
    {
      if(isRight == true || isLeft == true)
        yOffset += 2 * sqrt(2);
      else yOffset += 4;
    }
  }
  if(isDown == true)
  {
    if(yTotal < -4996 && yTotal > -5000)
      yOffset = -5000 - yTotal;
    else if (!(yTotal <= -5000))
    {
      if(isRight == true || isLeft == true)
        yOffset -= 2 * sqrt(2);
      else yOffset -= 4;
    }
  }
  if(isRight == true)
  {
    if(xTotal < -4996 && xTotal > -5000)
      xOffset = -5000 - xTotal;
    else if (!(xTotal <= -5000))
    {
      if(isUp == true || isDown == true)
        xOffset -= 2 * sqrt(2);
      else xOffset -= 4;
    }
  }
  if(isLeft == true)
  {
    if(xTotal > 4996 && xTotal < 5000)
      xOffset = 5000 - xTotal;
    else if (!(xTotal >= 5000))
    {
      if(isUp == true || isDown == true)
        xOffset += 2 * sqrt(2);
      else xOffset += 4;
    }
  }
  
  xTotal += xOffset;
  yTotal += yOffset;
  
  for(int i = 0; i < orb.length; i++)
  {
     orb[i].foodX += xOffset;
     orb[i].foodY += yOffset;
  }
  for(int i = 0; i < lr.length; i++)
  {
     lr[i].x += xOffset;
     ud[i].x += xOffset;
     lr[i].y += yOffset;
     ud[i].y += yOffset;
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

int[] spawnZone(int minX, int max2X, int min2X, int maxX, int min1Y, int max1Y, int min2Y, int max2Y)
{
  int[] zone = new int[2];
  
  zone[0] = (int)(Math.random()* (maxX-minX) + minX);
  
  int[] randArrayY = new int[(max1Y-min1Y) + (max2Y-min2Y) + 2];
  int num = 0;
  if(zone[0] > max2X && zone[0] < min2X)
  {
    for(int i = min1Y; i <= max1Y; i++)
    {
      randArrayY[num] = i;
      num++;
    }
    for(int i = min2Y; i <= max2Y; i++)
    {
      randArrayY[num] = i;
      num++;
    }
    zone[1] = randArrayY[(int)(Math.random() * randArrayY.length)];
  }
  else zone[1] = (int)(Math.random()* (max2Y-min1Y) + min1Y);
  
  return zone;
}

//make Runner work properly, eat and disappear
