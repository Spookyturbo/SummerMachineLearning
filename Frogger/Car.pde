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
    }
    else {
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
    clampPosition(position.x, minPosition, maxPosition);
  }

  void clampPosition(float w, float minPosition, float maxPosition) {
    //Topleft corner of car is given position, so subtract the width of the car
    if (w > maxPosition - size.x) {
      position.x = minPosition;
    } else if (w < minPosition) {
      position.x = maxPosition - size.x;
    }
  }
}