class Car {

  PImage img;
  PVector position;
  PVector size;
  float maxPosition;
  float minPosition;
  float speed = 1;
  boolean directionRight = false;

  public Car(float x, float y, int h, boolean directionRight) {
    if (directionRight) {
      img = loadImage("Car.png");
    } else {
      img = loadImage("CarReversed.png");
    }
    position = new PVector(x, y);
    this.directionRight = directionRight;
    //1.475 = ratio of w/h for original image
    float w = 1.475f * h;
    size = new PVector(w, h);
    maxPosition = size.x + width;
    minPosition = -size.x;
  }

  public void draw() {
    imageMode(CORNER);
    pushMatrix();
    scale(1, -1);
    translate(0, -height);
    image(img, position.x, position.y, size.x, size.y);
    popMatrix();
  }

  public void update() {
    position.x += (directionRight) ? speed : speed * -1;
    wrapPosition(position.x, minPosition, maxPosition);
  }

  void wrapPosition(float w, float minPosition, float maxPosition) {
    //Topleft corner of car is given position, so subtract the width of the car
    if (w > maxPosition - size.x) {
      position.x = minPosition;
    } else if (w < minPosition) {
      position.x = maxPosition - size.x;
    }
  }

  //Uses the Axis Aligned Bounding Box collision detection method
  boolean checkCollision(PVector position, PVector size) {
    float carLeftEdge = this.position.x;
    float carRightEdge = this.position.x + this.size.x;
    float carTop = this.position.y;
    float carBottom = this.position.y + this.size.y;
    float objectLeftEdge = position.x;
    float objectRightEdge = position.x + size.x;
    float objectTop = position.y;
    float objectBottom = position.y + size.y;


    if (carLeftEdge < objectRightEdge && carRightEdge > objectLeftEdge && carTop < objectBottom && carBottom > objectTop) {
      return true;
    }

    return false;
  }

  boolean contains(PVector point) {
    return point.x > position.x && point.x < position.x + size.x && point.y > position.y && point.y < position.y + size.y;
  }
}