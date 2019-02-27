//import processing.io.*;
import processing.pdf.*;
import processing.serial.*;
import java.util.Map;
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
HashMap<String,Integer> markerBuildings = new HashMap<String,Integer>();
markerBuildings.put("pin", 1);
markerBuildings.put("communityCenter", 2);
markerBuildings.put("", 3);
markerBuildings.put("", 4);
markerBuildings.put("", 5);
markerBuildings.put("", 6);
markerBuildings.put("", 7);
markerBuildings.put("", 8);
markerBuildings.put("", 9);
markerBuildings.put("", 10);
markerBuildings.put("", 11);
markerBuildings.put("", 12);
markerBuildings.put("", 13);
markerBuildings.put("", 14);
markerBuildings.put("", 15);
markerBuildings.put("", 16);
markerBuildings.put("", 17);
markerBuildings.put("", 17);
markerBuildings.put("", 17);
ArrayList<PImage> places = new ArrayList<PImage>();                       
String state = "start"; 

// On the Raspberry Pi GPIO 4 is physical pin 7 on the header
// see setup.png in the sketch folder for wiring details

void setup(){
  fullScreen();
  background(0);
  loadPlaceImages();
  // INPUT_PULLUP enables the built-in pull-up resistor for this pin
  // left alone, the pin will read as HIGH
  // connected to ground (via e.g. a button or switch) it will read LOW
  //GPIO.pinMode(4, GPIO.INPUT_PULLUP);
}
void loadPlaceImages(){
  PImage pittsburgh = loadImage("data/1.jpg");
  places.add(pittsburgh);
}
void checkButton(){
  //if (GPIO.digitalRead(4) == GPIO.LOW) {//PRINT POSTEEERRRR
    //button is pressed
  //}else if (GPIO.digitalRead(5) == GPIO.LOW){//RESET
    //restart();
  //}
}
void draw(){
  checkButton();
  switch(state){
    case "start":
      mapIt();
      break;
    default:
      
    
  }
}
void restart(){
  state = "start";
}
void mapIt(){
  image(places.get(1), 0, 0, width, height);
}
void generatePoster(){
  color from = color(94, 155, 255);
  color to = color(247, 177, 165);
  linearGradient(0,0,width,height, from , to);
  basicGrid(pixelGrid, 0.9, 0.95, 0.03);
  save("anIteration.jpg");
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

///////////////////////////////VISUAL/SOUND EFFECTS/////////////////////////////////////////////////////////////////////
ArrayList<Ripple> ripplings = new ArrayList<Ripple>();
void ripplesEffect(){
  //RIPPLE 
  if(frameCount%(random(2,20)) == 0){
    Ripple anotherone = new Ripple(mouseX, mouseY);
    ripplings.add(anotherone);
    
  }
  for (int i = 0; i < ripplings.size(); i++) {
    if(ripplings.get(i).keep){//if the ripple is still viable to grow, continue drawing it out
      ripplings.get(i).draw();
      ripplings.get(i).update();
    }else{
      ripplings.remove(i);
    }
  }
}
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
