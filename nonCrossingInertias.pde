/**
 * Basic Drawing
 * by Andres Colubri. 
 * 
 * This program shows how to access position and pressure from the pen tablet.
 */
 
import codeanticode.tablet.*;
float weight;

Tablet tablet;

void setup() {
  size(1200, 800);
 
  tablet = new Tablet(this); 
  
  background(0);
  stroke(255);
}

void draw() {
  // Instead of mousePressed, one can use the Tablet.isMovement() method, which
  // returns true when changes not only in position but also in pressure or tilt
  // are detected in the tablet. 
  if (mousePressed && tablet.isMovement()) {
    weight = max(20 * tablet.getPressure(), weight*4/5); // Prevent stroke weight from dropping abruptly
    strokeWeight(weight);
    
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
  }
  
  // The current values (pressure, tilt, etc.) can be saved using the saveState() method
  // and latter retrieved with getSavedxxx() methods:
  //tablet.saveState();
  //tablet.getSavedPressure();
}
