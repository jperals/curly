/**
 * Non crossing inertias
 * By Joan Perals
 * Using the Tablet library by Andres Colubri. 
 */
 
import codeanticode.tablet.*;
import java.util.Date;

float lineWeight;
int newThreadEvery = 3,
    iteration = 0;
ArrayList<LineThread> threads;

Tablet tablet;

void setup() {
  size(1200, 800);
 
  tablet = new Tablet(this);
  threads = new ArrayList<LineThread>();
  
  background(0);
  stroke(255);
  smooth();
}

void draw() {
  // Instead of mousePressed, one can use the Tablet.isMovement() method, which
  // returns true when changes not only in position but also in pressure or tilt
  // are detected in the tablet. 
  if (mousePressed && tablet.isMovement()) {
    lineWeight = max(5 * tablet.getPressure(), lineWeight*4/5); // Prevent stroke lineWeight from dropping abruptly
    strokeWeight(lineWeight);
    
    // Aside from tablet.getPressure(), which should be available on all pens, 
    // pen may support:
    //tablet.getTiltX(), tablet.getTiltY() MOST PENS
    //tablet.getSidePressure() - AIRBRUSH PEN
    //tablet.getRotation() - ART or PAINTING PEN    
    
    // The tablet getPen methods can be used to retrieve the pen current and 
    // saved position (requires calling tablet.saveState() at the end of 
    // draw())...
    //line(tablet.getSavedPenX(), tablet.getSavedPenY(), tablet.getPenX(), tablet.getPenY());
    
    // ...but it is equivalent to simply use Processing's built-in mouse 
    // variables.
    line(pmouseX, pmouseY, mouseX, mouseY);
    //ellipse(mouseX - 10, mouseY - 10, 20, 20);
    
    // Create a new thread if it's time to
    iteration += 1;
    if(iteration > newThreadEvery) {
      iteration = 0;
      float angle = atan2(mouseY - pmouseY, mouseX - pmouseX);
      threads.add(new LineThread(mouseX, mouseY, angle, lineWeight));
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
    case 'r':
      threads = new ArrayList<LineThread>();
      background(0);
      break;
    case 's':
      Date date = new Date();
      String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd.kk.mm.ss").format(date.getTime());
      saveFrame("screenshots/screenshot-" + formattedDate + "-######.png");
  }
}
