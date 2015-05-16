public class LineThread {
  ArrayList<PVector> points;
  PVector nextToLastPoint, lastPoint;
  float lineWeight, initialLineWeight;
  float angle, angularSpeed = 0;
  float speed = 1;
  boolean forked = false, deadEnd = false;
  color threadColor, initialColor;
  public LineThread(int x, int y, float angle, float lineWeight, color threadColor) {
    this.angle = angle;
    this.lineWeight = lineWeight;
    initialLineWeight = lineWeight;
    this.threadColor = threadColor;
    initialColor = threadColor;
    points = new ArrayList<PVector>();
    addPoint(new PVector(x, y));
  }
  public void draw() {
    if(nextToLastPoint != null && !deadEnd) {
      pushMatrix();
      strokeWeight(lineWeight);
      stroke(threadColor);
      line(nextToLastPoint.x, nextToLastPoint.y, lastPoint.x, lastPoint.y);
      popMatrix();
    }
  }
  public void update() {
    if(deadEnd) {
      return;
    }
    angularSpeed += random(-0.001, 0.001);
    angle += angularSpeed;
    float x = lastPoint.x, y = lastPoint.y;
    while((int)x == (int)lastPoint.x && (int)y == (int)lastPoint.y) {
      x += speed*cos(angle);
      y += speed*sin(angle);
    }
    color pixelColor = get((int)x, (int)y);
    //println("pixelColor: " + pixelColor);
    //println("initialColor: " + initialColor);
    //println("mainThreadColor: " + mainThreadColor);
    boolean pixelEmpty = x < 0 || x > width-1 ||y < 0 || y > height-1 || !usedPixels[(int)x][(int)y];
    if(pixelEmpty) {
      addPoint(new PVector(x, y));
      lineWeight = max(lineWeight - 1, 1);
      threadColor = color(red(threadColor)+random(-1, 1), green(threadColor)+random(-1, 1), blue(threadColor)+random(-1, 1));
    }
    else {
      if(usedPixels[(int)x][(int)y]) {
        deadEnd = true;
      }
    }
  }
  private void addPoint(PVector point) {
    points.add(point);
    if(point.x >= 0 && point.x < width && point.y >= 0 && point.y < height) { 
      usedPixels[(int)(point.x)][(int)(point.y)] = true;
    }
    nextToLastPoint = lastPoint;
    lastPoint = point;
  }
  
}
