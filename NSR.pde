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
float gridWidth;
int gridX;
int gridY;
float gridGutter;
float cellWidth; //individual square size


boolean shifted; //is the shift key pressed?

int[][] pixelGrid = { {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
IntDict markerBuildings;

ArrayList<PImage> places = new ArrayList<PImage>();                       
String state = "testing"; 

// On the Raspberry Pi GPIO 4 is physical pin 7 on the header
// see setup.png in the sketch folder for wiring details

void setup(){
  //fullScreen();
  size(720,480);
  background(0);
  loadPlaceImages();
  // INPUT_PULLUP enables the built-in pull-up resistor for this pin
  // left alone, the pin will read as HIGH
  // connected to ground (via e.g. a button or switch) it will read LOW
  //GPIO.pinMode(4, GPIO.INPUT_PULLUP);
  
  setupMarkerDict();
  
  gridWidth = 0.9*width;
  gridX = 0;
  gridY = 0;
  gridGutter = 0.01*width;
  cellWidth = int((gridWidth - (pixelGrid[0].length-1)*(gridGutter))/ pixelGrid[0].length);
}
void keypressed(){
  println("keys");
  if (key == CODED){
    switch(keyCode){
      case DOWN:
        gridY += 1;
        if (shifted){
          //keystone down or scale down
        }
        break;
      case UP:
        gridY -= 1;
        if (shifted){
          //keystone up or scale up
        }
        break;
      case LEFT:
        println("coded");
        gridX -= 1;
        if (shifted){
          //keystone
        }
        break;
      case RIGHT:
        gridX += 1;
        if (shifted){
          //keystone
        }
        break;
      case ENTER:
        state = "testing";
        break;
      case (SHIFT):
        shifted = true;
      default:
        break;
        
    }
  }
}
void keyReleased(){
  if (key == CODED){
    switch(keyCode){
      case DOWN:
        gridY += 1;
        break;
      case (SHIFT):
        shifted = false;
      default:
        break;
    }
  }
}
void loadPlaceImages(){
  PImage pittsburgh = loadImage("data/pittsburgh.jpg");
  places.add(pittsburgh);
}
void setupMarkerDict(){
  markerBuildings = new IntDict();
  markerBuildings.set("pin", 100);
  markerBuildings.set("somethingCenter", 1);
  markerBuildings.set("communityCenter", 2);
  markerBuildings.set("", 3);
  markerBuildings.set("", 4);
  markerBuildings.set("", 5);
  markerBuildings.set("", 6);
  markerBuildings.set("", 7);
  markerBuildings.set("", 8);
  markerBuildings.set("", 9);
  markerBuildings.set("", 10);
  markerBuildings.set("", 11);
  markerBuildings.set("", 12);
  markerBuildings.set("", 13);
  markerBuildings.set("", 14);
  markerBuildings.set("", 15);
  markerBuildings.set("", 16);
  markerBuildings.set("", 17);
  markerBuildings.set("", 18);
  markerBuildings.set("", 19);
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
    case "testing":
      testingGrid(gridX, gridY, gridWidth, gridGutter);
    default:
    
  }
}
void restart(){
  state = "start";
}
void mapIt(){
  image(places.get(0), 0, 0, width, height);
  //Check for pin
  int[] coordinates = locateIt(pixelGrid, "pin");
  if( coordinates[0] > 0 ){ //aka, if it exists, then run ripples
    ripplesEffect(coordinates[0], coordinates[1]);
  }
}
int[] locateIt(int[][] grid, String dictKey){
  int[] xy = {-10,-10};//fake placeholder negative values
  int dictValue = markerBuildings.get(dictKey);
  for( int row = 0; row < grid.length; row++ ){
    for( int col = 0; col < grid[row].length; col ++){
      if (grid[row][col] == dictValue){
        xy = rowcolToXY(row, col);
        return (xy);
      }
    }
  }
  return null;
}
int[] rowcolToXY(int row, int col){//returns the center point of that cell
  int x = int(gridX + col*cellWidth + col*gridGutter*width + cellWidth/2);
  int y = int(gridY + row*cellWidth + row*gridGutter*width + cellWidth/2);
  int[] answer = {x,y};
  return answer;
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
//sets up squares and tests the projector for placement
void testingGrid(int startX, int startY, float pWide, float pGutter){
  pushMatrix();
  translate(startX, startY);
  for(int row = 0; row < pixelGrid.length; row ++){
    int y = int(row*cellWidth + row*pGutter);
    for(int col = 0; col < pixelGrid[row].length; col++){
      int x = int(col*cellWidth + col*pGutter);
        fill(255);
        stroke(0);
        rect(x, y, cellWidth, cellWidth);
      }
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
void ripplesEffect(int x, int y){
  //RIPPLE 
  if(frameCount%5 == 0){
    Ripple anotherone = new Ripple(x, y);
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
  int x;
  int y;
  int size = 1;
  float increase = width/25; 
  int strokeC=255;
  boolean keep = true;
  Ripple(int xx, int yy){
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
    pushMatrix();
    noStroke();
    fill(255,0,0,strokeC);
    ellipse(x,y,size,size);
    popMatrix();
  }
}
