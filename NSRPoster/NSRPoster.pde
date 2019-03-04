import peasy.*;
PeasyCam cam;


int[][] pixelGrid = { {1, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0},
                      {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 3, 0, 0, 5, 0, 5},
                      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 4, 0, 0, 0, 1, 1},
                      {0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1} };

public void settings() {
  size(1100, 850, P3D);
  smooth(2);
}

public void setup() {
  
  cam = new PeasyCam(this, 2000);
  camState = cam.getState();
  
  colorMode(HSB);
  ortho();
  
  noStroke();

  cam.rotateX(-0.82440263);
  cam.rotateY(0.6328603);
  cam.rotateZ(-0.50827336);
  

}

// Draw scene
public void draw(){
  // Draw over current scene with black
  background(150,30,245);
  
  //pushMatrix();
  //fill(255,255,0);
  //translate(0,0,200);
  //rect(0,0,600/ pixelGrid[0].length, 600/ pixelGrid[0].length);
  //fill(255,0,0);
  //ellipse(0,0,100,100);
  //popMatrix();
  
  directionalLight(150,120,90, 0,0,-1);//black light
  
  //directionalLight(255,0,255, 0,-1,0); //white lgiht
  pointLight(35,120,145,300,4000,100);
  pointLight(190,70,135,0,4000,-1500);
 
  directionalLight(150,80,50, -1,0,0); //side shadow
  
  pointLight(250, 160, 70, 600, 0, 200);//pink top
  pointLight(154, 110, 210, 800,200,0);//bluer bottom
  
  basicGrid(pixelGrid, 600);
    
  //fill(203,8,200);
  //sphere(2200);
  //noLoop();
}

//recieves the CV grid of colors
void basicGrid(int[][] grid, int totalSize){
  int w = int(totalSize/ grid[0].length);
  int h = w;
  
  for(int row = 0; row < grid.length; row ++){
    int y = int(row*h);
    for(int col = 0; col < grid[row].length; col++){
      int x = int(col*w);
      if (grid[row][col] > 0){
        pushMatrix();
        //int howTallBuilding = int(800-dist(x,y,0,0));
        //stroke(0,0,0,10);
        //strokeWeight(4);
        int howTallBuilding = 50;
        translate(x,y, howTallBuilding*0.5);
        fill(grid[row][col]*50, 255, 255);
        box(w, h, howTallBuilding); // maybe we can have box come from ground downward?
        popMatrix();
        
        pushMatrix();
          strokeWeight(1);
          translate(x,y, -100);
          fill(255,0,255);
          box(w, h, 200);
        popMatrix();
      }else if(noise(x/100, y/100) > 0.6){
        pushMatrix();
          strokeWeight(1);
          float howTall = constrain(noise(x/100, y/100) * 600 + 300, 200,800);
          translate(x,y, -400);
          fill(255,0,255);
          box(w, h, howTall);
        popMatrix();
      }
    }
  }
  
}
CameraState camState;

public void keyReleased() {
  if (key == '1'){camState = cam.getState();   println(cam.getRotations());}
  if (key == '2') cam.setState(camState, 1000);
}
