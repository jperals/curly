/**
 * Non crossing inertias
 * By Joan Perals
 * Using the Tablet library by Andres Colubri.
 * 
 * Draw and see what happens. Preferably with a drawing tablet.
 * See the "keyPressed" function below for options that you can trigger during execution.
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
PGraphics bg;
PGraphics overlay;
PGraphics pg;
PImage bgImage;
float overlayOpacity = 127;

Tablet tablet;

void setup() {
  size(1200, 800);
 
  tablet = new Tablet(this);
  threads = new ArrayList<LineThread>();
  usedPixels = new boolean[width][height];
  setMainThreadColor();
  
  overlay = createGraphics(width, height);
  pg = createGraphics(width, height);
  pg.beginDraw();  
  pg.stroke(mainThreadColor);
  pg.smooth();
  pg.endDraw();
  
  background(bgcolor);

}

void draw() {
  pg.beginDraw();
  if (mousePressed && tablet.isMovement()) {
    lineWeight = max(5 * tablet.getPressure(), lineWeight*4/5); // Prevent stroke lineWeight from dropping abruptly
    strokeWeight(lineWeight);
    
    if(drawMainThread) {
      pg.line(pmouseX, pmouseY, mouseX, mouseY);
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
    LineThread thread = threads.get(i);
    thread.update();
    thread.draw(pg);
  }
  
  pg.endDraw();
  
  if(bgImage != null) {
    image(bgImage, 0, 0);
    image(overlay, 0, 0);
  }
  image(pg, 0, 0);

}

void keyPressed() {
  switch(key) {
    case '1': // Color (1): golden yellow
      mainThreadColor = color(234, 159, 8);
      break;
    case '2': // Color (2): shiny purple
      mainThreadColor = color(162, 85, 135);
      break;
    case 'c': // Random (C)olor
      setMainThreadColor();
      break;
    case 'f': // Select an image (F)ile to  draw on top of
      selectInput("Select an image:", "imageSelected");
      break;
    case 'm': // Toggle draw (M)ain thread
      drawMainThread = !drawMainThread;
      break;
    case 'r': // (R)eset
      threads = new ArrayList<LineThread>();
      usedPixels = new boolean[width][height];
      pg.background(bgcolor);
      break;
    case 's': // (S)ave frame
      Date date = new Date();
      String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd.kk.mm.ss").format(date.getTime());
      saveFrame("screenshots/screenshot-" + formattedDate + "-######.png");
      break;
    case 'x': // Increase overlay opacity (make background image less visible)
      overlayOpacity = min(255, overlayOpacity + 20);
      setOverlay();
      break;
    case 'z': // Decrease overlay opacity (make background image more visible) 
      overlayOpacity = max(0, overlayOpacity - 20);
      setOverlay();
      break;
  }
}

void setMainThreadColor() {
  mainThreadColor = color(random(255), random(255), random(255));
}

void imageSelected(File file) {
  if (file == null) {
    println("No file was selected.");
  }
  else {
    String path = file.getAbsolutePath();
    bgImage = loadImage(path);
    setOverlay();
  }
}

void setOverlay() {
  overlay.beginDraw();
  overlay.background(bgcolor, overlayOpacity);
  overlay.endDraw();
}
