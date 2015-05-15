public class LineThread {
  ArrayList<PVector> points;
  PVector nextToLastPoint, lastPoint;
  float lineWeight;
  float angle;
  float speed = 1;
  public LineThread(int x, int y, float angle, float lineWeight) {
    this.angle = angle;
    this.lineWeight = lineWeight;
    points = new ArrayList<PVector>();
    addPoint(new PVector(x, y));
  }
  public void draw() {
    if(nextToLastPoint != null) {
      pushMatrix();
      strokeWeight(lineWeight);
      line(nextToLastPoint.x, nextToLastPoint.y, lastPoint.x, lastPoint.y);
      popMatrix();
    }
  }
  public void update() {
    angle += random(-0.05, 0.05);
    PVector nextPoint = new PVector(lastPoint.x + speed*cos(angle), lastPoint.y + speed*sin(angle));
    addPoint(nextPoint);
    lineWeight = max(lineWeight - 1, 1);
  }
  private void addPoint(PVector point) {
    points.add(point);
    nextToLastPoint = lastPoint;
    lastPoint = point;
  }
  
}
