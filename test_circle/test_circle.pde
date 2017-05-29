int deg = 0;
int diff = 10;
int add = 1;
  float radius =100;
  int centx =250;
  int centy = 150;

void setup(){
  size (500,300);
  background(255);
  strokeWeight(5);
  smooth();

  stroke(0,30);
  noFill();
  ellipse(centx, centy, radius*2, radius*2);
}

void draw(){
    background(255);
stroke(20, 50, 70);
  float x, y;
  float lastx = -999;
  float lasty = -999;

  for (float ang = 0; ang <= 360; ang += diff){
    float rad = radians(ang);
    x = (radius * cos(rad));
    y = (radius * sin(rad));  
    
    pushMatrix();
    translate(centx, centy);
    rotate(deg*PI/180);
    point(x,y);
    popMatrix();
  }
  deg+=add;
}

void mousePressed(){
  add*=-1;
}