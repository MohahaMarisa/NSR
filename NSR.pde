import processing.io.*;
import processing.pdf.*;
/*
pixel grid is recieved from the CV analyzing the abstracte community
and finding the different colors
1. orange - connectivity
2. Yellow - Opportunity
3. Green- Sustainability
4. blue - planning
5. purple - Culture

RED IS THE PIIIINNNNN
*/
int[][] pixelGrid = { {0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 4, 0},
                      {0, 0, 0, 0, 0, 0, 5, 0},
                      {1, 1, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 3, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 1, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 3, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0},
                      {5, 0, 2, 3, 0, 0, 0, 0},
                      {5, 0, 0, 0, 0, 0, 4, 0} };
                      
String state = "start"; 
// On the Raspberry Pi GPIO 4 is physical pin 7 on the header
// see setup.png in the sketch folder for wiring details
void setup(){
  size(425,550);
  background(0);
  frameRate(1);
  // INPUT_PULLUP enables the built-in pull-up resistor for this pin
  // left alone, the pin will read as HIGH
  // connected to ground (via e.g. a button or switch) it will read LOW
  GPIO.pinMode(4, GPIO.INPUT_PULLUP);
  noLoop(); //REMOVE THIS LATEERRR
}
void checkButton(){
  if (GPIO.digitalRead(4) == GPIO.LOW) {//PRINT POSTEEERRRR
    //button is pressed
  }/*else if (GPIO.digitalRead(5) == GPIO.LOW){//RESET
    restart();
  }*/
}
void draw(){
  checkButton();
  color from = color(94, 155, 255);
  color to = color(247, 177, 165);
  linearGradient(0,0,width,height, from , to);
  basicGrid(pixelGrid, 0.9, 0.95, 0.03);
  save("anIteration.jpg");
}
void restart(){
  state = "start";
}
void linearGradient(int x, int y, int w, int h, color from, color to){
  pushMatrix();
  translate(x,y);
  for (int i = 0; i < h; i++ ){
    float amt = float(i)/float(h);
    color interpolated = lerpColor(from, to, amt);
    stroke(interpolated);
    line(0, i, w, i);
  }
  popMatrix();
}
//recieves the CV grid of colors, as well as the % width, height, and guttter size
void basicGrid(int[][] grid, float pWide, float pHeight, float pGutter){
  int h = int((height*pHeight - (grid.length-1)*width*pGutter)/ grid.length);
  int w = int((width*pWide - (grid[0].length-1)*(width*pGutter))/ grid[0].length);
  
  for(int row = 0; row < grid.length; row ++){
    int y = int((height - pHeight*height)/2 + row*h + row*pGutter*width);
    for(int col = 0; col < grid[row].length; col++){
      int x = int((width - pWide*width)/2 + col*w + col*pGutter*width);
      noFill();
      if (grid[row][col] > 0){
        int howTallBuilding = int(random(10,80));
        pushMatrix();
        translate(3*howTallBuilding, 3*howTallBuilding);
        for(int i = 0; i < howTallBuilding; i++){
          translate(-3,-3);
          rect(x, y, w, h);
        }
        popMatrix();
        fill(255);
        rect(x, y, w, h);
      }
      
    }
  }
  
}

//VISUALLLLSLSSSS AAAGGGGGHHHH
///////////////////////////////VISUAL/SOUND EFFECTS/////////////////////////////////////////////////////////////////////
void addNewEffects(){//add new ripples and tallies to the array of both
  Ripple anotherKnock = new Ripple(mouseX, mouseY);
  rippleknocks.add(anotherKnock);
  volume=1;
  int howManySoFar = knockTimes.size();
  Tally anotherTally = new Tally(howManySoFar);
  tallycount.add(anotherTally);
}
void reset(){
  bg = color(random(10,245), random(10,245),random(10,240));
  //clear the float lists for the next round
  knockTimes.clear(); knockIntervals.clear();//clears the current floatLists of knock times and intervals
}
void visualEffects(){
  //RIPPLE 
  for (int i = 0; i < rippleknocks.size(); i++) {
    if(rippleknocks.get(i).keep){//if the ripple is still viable to grow, continue drawing it out
      rippleknocks.get(i).draw();
      rippleknocks.get(i).update();
    }else{
      rippleknocks.remove(i);
    }
  }
  for (int i = 0; i < tallycount.size(); i++) {
    tallycount.get(i).draw();
  }
}
void audio(){
  soundEffect.pan(map(mouseX,0,width,-1,1));//x position determines what side the osund comes out from
  soundEffect.freq(map(mouseY,0,height,300,80));//y position determines pitch
  soundEffect.amp(volume);
  volume=volume/1.2;
}
class Tally{
  float x=35;
  float y=35;
  float size = 6;
  boolean currentKnockIteration = true;
  int opacity;
  int maxSpacing=width/4;
  int maxSpread; //max spread is determiend by the first pattern input
  //color thisbg;
  color filling = color(255);
  Tally(int howMany){
    if (howMany == 1){
      x=35;
    }else{
      float timing = knockIntervals.get(howMany-2);
      float spacing = map(timing, 0,5000,0,maxSpacing);
      x=tallycount.get(totalknocking-2).x+spacing;
    }
    //x=;
  }
  void draw(){
    if(currentKnockIteration){
        opacity = 255;
        //thisbg = bg;
    }else{opacity=40; filling = 0;}
    fill(filling, opacity);
    ellipse(x,y,size,size);
  }
}
//------visual effects_--------------------------------------------------------
class Ripple{
  float x;
  float y;
  int size=1;
  float increase = width/25; 
  int strokeC=255;
  boolean keep = true;
  Ripple(float xx, float yy){
    x=xx;
    y=yy;
  }
  void update() {
    increase-=width/2222.22;
    size+=increase;
    strokeC-=5;
    if (strokeC<=0){
      keep = false;
    }
  }
  void draw(){
    noStroke();
    fill(255,strokeC);
    ellipse(x,y,size,size);
  }
}
