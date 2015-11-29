PImage enemy;
PImage bg1;
PImage bg2;
PImage fighter;
PImage hp;
PImage treasure;
PImage end1,end2,start1,start2;
PImage bullet;
int enemyCount = 8;
int bg1X,bg2X;
int hpX;
int treasureX,treasureY;
int fighterX,fighterY;
int fighterSpeed=5;
int enemyChangeLine;
int score;
PFont scoreWord;

final int GAME_START=0,WAVE1=1,WAVE2=2,WAVE3=3,GAME_LOSE=4;
int gameState=GAME_START;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
int[] bulletX = new int[5];
int[] bulletY = new int[5];
boolean[] bulletShoot = new boolean[5];

int bulletNum = 0;
boolean [] bulletNumLimit = new boolean[5];

void setup () {
  size(640, 480) ;
  enemy = loadImage("img/enemy.png");
   bg1 = loadImage("img/bg1.png");
   bg2 = loadImage("img/bg2.png");
   fighter = loadImage("img/fighter.png");
   hp = loadImage("img/hp.png");
   treasure = loadImage("img/treasure.png");
   start1 = loadImage("img/start1.png");
   start2 = loadImage("img/start2.png");
   end1 = loadImage("img/end1.png");
   end2 = loadImage("img/end2.png");
   bullet = loadImage("img/shoot.png");
   
   bg1X = 640;
   bg2X = 0;
  
   hpX = 40;
  
   treasureX = floor(random(0,470));
   treasureY = floor(random(60,420));
   
   fighterX = 550;
   fighterY = 240;
   
   enemyChangeLine = enemyX[0]-800;
   
   addEnemy(0);
   
   for (int i =0; i < bulletNumLimit.length ; i ++){
    bulletNumLimit[i] = false;
   }
   
   scoreWord = createFont("Arial",24);
}

void draw(){
  //background
  image(bg1,bg1X-640,0);
  image(bg2,bg2X-640,0);
  bg1X++;
  bg2X++;
  bg1X%=1280;
  bg2X%=1280;
  
   //fighter
  image(fighter,fighterX,fighterY);
  
  //enemy
  enemyChangeLine +=5;
  
  //hp
  fill(255,0,0);
  noStroke();
  rect(20,13,hpX,20,10);
  image(hp,10,10);
  
  //treasure hit
    image(treasure,treasureX,treasureY);
    if(isHit(fighterX, fighterY, fighter.width, fighter.height, treasureX, treasureY, treasure.width, treasure.height) == true){
          hpX += 20;
      treasureX=floor(random(0,470));
      treasureY=floor(random(60,420));
     }
  
  //enemy hit
  for (int i = 0; i < enemyCount; ++i) {
      if (enemyX[i] != -1 || enemyY[i] != -1) {
        if(isHit(fighterX, fighterY, fighter.width, fighter.height, enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
          hpX -= 40;
          enemyX[i] = -1;
          enemyY[i] = -1;
        }
      }
  }
  
  //bullet hit
     for (int i = 0; i < enemyCount; i++ ){
       for(int j =0; j<5; j++){
         if (enemyX[i] != -1 || enemyY[i] != -1) {
           if(bulletNumLimit[j] == true){
             if(isHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyX[i], enemyY[i], enemy.width, enemy.height) == true){
               enemyX[i] = -1;
               enemyY[i] = -1;
               bulletNumLimit[j] =false;
               scoreChange(20);
             }
           }
         }
       }
     }
     
   for (int i = 0; i < 5; i ++){
      if (bulletNumLimit[i] == true){
        image (bullet, bulletX[i], bulletY[i]);
         bulletX[i] -= 5;
      }
      if (bulletX[i] < - bullet.width){
        bulletNumLimit[i] = false;
      }
    }
      
  //score
  if (gameState == WAVE1 || gameState == WAVE2 || gameState == WAVE3){
    textFont(scoreWord,30);
    fill(255);
    text("score:" + score,20,460);
  }
  
   //hp boundary
   if(hpX > 200){
      hpX = 200;  
   }
   if(hpX <= 0){
      hpX = 0;
   }
   
    //move
  if(upPressed){
    fighterY -= fighterSpeed;
  }
  if(downPressed){
    fighterY += fighterSpeed;
  }
  if(leftPressed){
    fighterX -= fighterSpeed;
  }
  if(rightPressed){
    fighterX += fighterSpeed;
  }
  
  //boundary
  if(fighterX<0){
    fighterX=0;
  }
  if(fighterX>590){
    fighterX=590;
  }
  if(fighterY<0){
    fighterY=0;
  }
  if(fighterY>430){
    fighterY=430;
  }
 


 switch(gameState){
     case GAME_START:
      image(start2,0,0);
      if(mouseX>200 && mouseX<460 && mouseY>375 && mouseY<415)
        if(mousePressed){
          gameState = WAVE1;
        }else{
          image(start1,0,0);
        } 
    break;
    
     case WAVE1:
    for (int i = 0; i < enemyCount; ++i) {
      if (enemyX[i] != -1 || enemyY[i] != -1) {
        image(enemy, enemyX[i], enemyY[i]);
        enemyX[i]+=5;
      }
    }

     if(enemyChangeLine > width){
       gameState = WAVE2;
       addEnemy(1);
       enemyChangeLine = enemyX[0]-700;
     }
     if(hpX <= 0){
       gameState = GAME_LOSE;
     }
     break;    
     case WAVE2:
     
     for (int i = 0; i < enemyCount; ++i) {
      if (enemyX[i] != -1 || enemyY[i] != -1) {
        image(enemy, enemyX[i], enemyY[i]);
        enemyX[i]+=5;
      }
    } 
    
    
      if(enemyChangeLine > width){
       gameState = WAVE3;
       addEnemy(2);
       enemyChangeLine = enemyX[0]-700;
     }
     
     if(hpX <= 0){
       gameState = GAME_LOSE;
     }
     break;
     
     case WAVE3:   
     for (int i = 0; i < enemyCount; ++i) {
      if (enemyX[i] != -1 || enemyY[i] != -1) {
        image(enemy, enemyX[i], enemyY[i]);
        enemyX[i]+=5;
      }
    }
    
     if(enemyChangeLine > width){
       gameState = WAVE1;
       addEnemy(0);
       enemyChangeLine = enemyX[0]-750;
     }
     if(hpX <= 0){
       gameState = GAME_LOSE;
     }
     break;
     
     case GAME_LOSE:
     image(end2,0,0);
     if(mouseX>200 && mouseX<440 && mouseY>300 && mouseY<350)
      if(mousePressed){
        gameState = WAVE1;
        hpX = 40;
        fighterX = 550;
        fighterY = 240;
        treasureX = floor(random(0,470));
        treasureY = floor(random(60,420));  
        addEnemy(0);
        score = 0;
        enemyChangeLine = enemyX[0]-750;
      }else{
        image(end1,0,0);
      }
 }

}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{  
  for (int i = 0; i < enemyCount; ++i) {
    enemyX[i] = -1;
    enemyY[i] = -1;
  }
  switch (type) {
    case 0:
      addStraightEnemy();
      break;
    case 1:
      addSlopeEnemy();
      break;
    case 2:
      addDiamondEnemy();
      break;
  }
}

void addStraightEnemy()
{
  float t = random(height - enemy.height);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h;
  }
}
void addSlopeEnemy()
{
  float t = random(height - enemy.height * 5);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h + i * 40;
  }
}
void addDiamondEnemy()
{
  float t = random( enemy.height * 3 ,height - enemy.height * 3);
  int h = int(t);
  int x_axis = 1;
  for (int i = 0; i < 8; ++i) {
    if (i == 0 || i == 7) {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h;
      x_axis++;
    }
    else if (i == 1 || i == 5){
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 1 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 1 * 40;
      i++;
      x_axis++;
      
    }
    else {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 2 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 2 * 40;
      i++;
      x_axis++;
    }
  }
}

void scoreChange(int value){
  score += value;
}

boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh){
  if(ay + ah >= by && by + bh >= ay && ax + aw >= bx && bx + bh >= ax){
    return true;
  }else{
    return false;
  }
}

void keyPressed(){
  if(key == CODED){
    switch(keyCode){
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}
void keyReleased(){
  if(key == CODED){
    switch(keyCode){
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }

 if ( keyCode == ' '){
    if (gameState == WAVE1 || gameState == WAVE2 || gameState == WAVE3){
      if (bulletNumLimit[bulletNum] == false){
        bulletNumLimit[bulletNum] = true;
        bulletX[bulletNum] = fighterX - 15;
        bulletY[bulletNum] = fighterY + 10;
        bulletNum ++;
      }
      if ( bulletNum > 4 ) {
        bulletNum = 0;
      }
    }
   }
 }
