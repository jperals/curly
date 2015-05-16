/**
 * Non crossing inertias
 * By Joan Perals
 * Using the Tablet library by Andres Colubri. 
 */
 
import codeanticode.tablet.*;
import java.util.Date;

float lineWeight;
color bgcolor = 0, mainThreadColor;
int newThreadEvery = 2,
    iteration = 0;
ArrayList<LineThread> threads;
boolean[][] usedPixels;
boolean drawMainThread = true;

Tablet tablet;

void setup() {
  size(1200, 800);
 
  tablet = new Tablet(this);
  threads = new ArrayList<LineThread>();
  usedPixels = new boolean[width][height];
  setMainThreadColor();
  
  background(bgcolor);
  stroke(mainThreadColor);
  smooth();
}

void draw() {
  if (mousePressed && tablet.isMovement()) {
    lineWeight = max(5 * tablet.getPressure(), lineWeight*4/5); // Prevent stroke lineWeight from dropping abruptly
    strokeWeight(lineWeight);
    
    if(drawMainThread) {
      line(pmouseX, pmouseY, mouseX, mouseY);
      //ellipse(mouseX - 10, mouseY - 10, 20, 20);
    }
    
    // Create a new thread if it's time to
    iteration += 1;
    if(iteration >= newThreadEvery) {
      iteration = 0;
      float angle = atan2(mouseY - pmouseY, mouseX - pmouseX);
      threads.add(new LineThread(mouseX, mouseY, angle, lineWeight, mainThreadColor));
    }
    
  }

  // Let threads grow
  int nThreads = threads.size();
  for(int i = 0; i < nThreads; i++) {
    //println("i: " + i);
    LineThread thread = threads.get(i);
    thread.update();
    thread.draw();
  }
  
  // The current values (pressure, tilt, etc.) can be saved using the saveState() method
  // and latter retrieved with getSavedxxx() methods:
  //tablet.saveState();
  //tablet.getSavedPressure();
}

void keyPressed() {
  switch(key) {
    case '1':
      mainThreadColor = color(234, 159, 8);
      break;
    case '2':
      mainThreadColor = color(162, 85, 135);
      break;
    case 'c':
      setMainThreadColor();
      break;
    case 'm':
      drawMainThread = !drawMainThread;
    case 'r':
      threads = new ArrayList<LineThread>();
      usedPixels = new boolean[width][height];
      background(bgcolor);
      break;
    case 's':
      Date date = new Date();
      String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd.kk.mm.ss").format(date.getTime());
      saveFrame("screenshots/screenshot-" + formattedDate + "-######.png");
      break;
  }
}

void setMainThreadColor() {
  mainThreadColor = color(random(255), random(255), random(255));
}
