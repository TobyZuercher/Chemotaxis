class Food
{
  float foodX, foodY;
  float value, d;
  boolean isAlive;
  int col;
  Food()
  {
    foodX = (int)(Math.random()* 10001 - 5000);
    foodY = (int)(Math.random()* 10001 - 5000);
    
    isAlive = true;
    value = (float)(Math.random() * 450) + (Math.abs(foodX)/2) + (Math.abs(foodY)/2);
    d = 2*(sqrt(value/PI));
    col = (int)(Math.random() * 361);
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
      
      
    int[] pos = spawnZone(-5000 - (int)xTotal - (int)outX, -width/2, width/2, 5000 - (int)xTotal - (int)outX, -5000 - (int)yTotal - (int)outY, -height/2, 5000 - (int)yTotal - (int)outY);
    
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
    fill(col, 360, 360);
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
  float runX, runY, yMoved, xMoved;
  float value, d;
  boolean isAlive;
  int col;
  float angle;
 
  Runner()
  {
    runX = (int)(Math.random()* 10001 - 5000);
    runY = (int)(Math.random()* 10001 - 5000);
    
    xMoved = runX;
    yMoved = runY;
    
    isAlive = true;
    value = (float)(Math.random() * 900 + 400) + (Math.abs(runX)/2) + (Math.abs(runY)/2);
    d = 2*(sqrt(value/PI));
    col = (int)(Math.random() * 361);
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
      
      
    int[] pos = spawnZone(-5000 - (int)xTotal - (int)outX, -width/2, width/2, 5000 - (int)xTotal - (int)outX, -5000 - (int)yTotal - (int)outY, -height/2, 5000 - (int)yTotal - (int)outY);
    
    runX = pos[0];
    runY = pos[1];
    
    if(isAlive == false)
      {
         value += (float)(Math.random() * 450 + 300) + (Math.abs(runX)/2) + (Math.abs(runY)/2);
         isAlive = true;
         d = 2*(sqrt(value/PI));
      }
  }
  
  void run()
  {
    angle = atan2(runY, runX);
    float moveX = 0;
    float moveY = 0;
    if(runX < width/2 + 100 && runX > -width/2 - 100 && runY < height/2 + 100 && runY > -height/2 - 100)  //run away if within sightrange + 100
    {
      moveX = (float)(Math.random()* 2 + 1)*cos(angle);
      moveY = (float)(Math.random()* 2 + 1)*sin(angle);
  
      if(moveY + yMoved > 5000)
        moveY = 0;
      if(moveY + yMoved < -5000)
        moveY = 0;
      if(moveX + xMoved > 5000)
        moveX = 0;
      if(moveX + xMoved < -5000)
        moveX = 0;
      
      yMoved += moveY;
      xMoved += moveX;
      
      runX += moveX;
      runY += moveY;
    }
  }
  
  void show()
  {
    fill(col, 360, 360);
    if(isAlive == true)
      ellipse(runX, runY, d, d);
  }
  
  void kill()
  {
    isAlive = false;
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
    fill(((d - 25)%360), 360, 360);
    ellipse(0, 0, d, d);
  }
}

class Grid
{
  float xg;
  float yg;
  Grid(float xPos, float yPos)
  {
    xg = xPos;
    yg = yPos;
  }
  
  void drawLinesLR()
  {
    noStroke();
    if(yTotal > 5000)
      yg = 5000;
    if(yTotal < -5000)
      yg = -5000;
    rect(xg -5000, yg, 10000, 1);
    //line(x - 5000, y, x + 5000, y);
  }
  
  void drawLinesUD()
  {
    noStroke();
    if(xTotal > 5000)
      xg = 5000;
    if(xTotal < -5000)
      xg = -5000;
    rect(xg, yg -5000, 1, 10000);
    //line(x, y - 5000, x, y + 5000);
  }
}

Food [] orb;
Runner [] enemy;
Cell agar = new Cell();
Grid [] lr, ud;

void setup()
{
  colorMode(HSB);
  orb = new Food[1562];
  enemy = new Runner[390];
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
  for(int i = 0; i < enemy.length; i++)
    enemy[i] = new Runner();
    
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
  fill(150);
  for(int i = 0; i < lr.length; i++)
  {
    if(lr[i].yg > height/2 && !(yTotal - 200 > (5000 - height/2))) lr[i].yg -= height;
    if(lr[i].yg < -height/2 && !(yTotal + 200 < (-5000 + height/2))) lr[i].yg += height;
    lr[i].drawLinesLR();
    if(ud[i].xg > width/2 && !(xTotal - 200 > (5000 - width/2))) ud[i].xg -= width;
    if(ud[i].xg < -width/2 && !(xTotal + 200 < (-5000 + width/2))) ud[i].xg += width;
    ud[i].drawLinesUD();
  }
  fill(255);
  stroke(0, 0, 0, 255);
  for(int i = 0; i < orb.length; i++)
  {
    orb[i].show();
  }
  for(int i = 0; i < enemy.length; i++)
  {
    enemy[i].run();
    enemy[i].show();
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
      if(Math.abs(orb[x].foodX) <= (agar.d/2) * cos(radians(i)) - (orb[x].d/8) && Math.abs(orb[x].foodY) <= (agar.d/2) * sin(radians(i)) - (orb[x].d/8) && agar.area > (orb[x].value)*1.05)
      {
        agar.grow(orb[x].value/5);
        orb[x].kill();
        orb[x].regen();
      }
    }
  }
  
  for(int x = 0; x < enemy.length; x++)
  {
    for(int i = 0; i < 90; i++)
    {
      if(Math.abs(enemy[x].runX) <= (agar.d/2) * cos(radians(i)) - (enemy[x].d/8) && Math.abs(enemy[x].runY) <= (agar.d/2) * sin(radians(i)) - (enemy[x].d/8) && agar.area > (enemy[x].value)*1.05)
      {
        agar.grow(enemy[x].value/3);
        enemy[x].kill();
        enemy[x].regen();
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
  float angle = 0;
  if(!(mouseX == 0))
    angle = atan2(mouseY-height/2, mouseX-width/2);
    
    xOffset = 4*-cos(angle);
    yOffset = 4*-sin(angle);
  
  if(yOffset + yTotal > 5000)
    yOffset = 5000 - yTotal;
  if(yOffset + yTotal < -5000)
    yOffset = -5000 - yTotal;
  if(xOffset + xTotal > 5000)
    xOffset = 5000 - xTotal;
  if(xOffset + xTotal < -5000)
    xOffset = -5000 - xTotal;
  
  xTotal += xOffset;
  yTotal += yOffset;
  
  for(int i = 0; i < orb.length; i++)
  {
     orb[i].foodX += xOffset;
     orb[i].foodY += yOffset;
  }
  for(int i = 0; i < enemy.length; i++)
  {
     enemy[i].runX += xOffset;
     enemy[i].runY += yOffset;
  }
  for(int i = 0; i < lr.length; i++)
  {
     lr[i].xg += xOffset;
     ud[i].xg += xOffset;
     lr[i].yg += yOffset;
     ud[i].yg += yOffset;
  }
  
}

int[] spawnZone(int minX, int max2X, int min2X, int maxX, int min1Y, int max1Y, int max2Y)
{
  int[] zone = new int[2];
  
  zone[0] = (int)(Math.random()* (maxX-minX) + minX);
  
  int randGen = (int)(Math.random()* (max2Y-min1Y) + min1Y);
  
  if(zone[0] > max2X && zone[0] < min2X)
  {
    if(randGen > max1Y)
      randGen += height;
  }
  zone[1] = randGen;
  
  return zone;
}

//make Runner work properly, eat and disappear
//make lines work in github
