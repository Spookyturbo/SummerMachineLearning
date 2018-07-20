public PImage upFrog;
public PImage leftFrog;
public PImage downFrog;
public PImage rightFrog;

public PImage car;
public PImage reversedCar;

void loadAllImages() {
  upFrog = loadImage("UpFrog.png");
  leftFrog = loadImage("LeftFrog.png");
  downFrog = loadImage("DownFrog.png");
  rightFrog = loadImage("RightFrog.png");
  
  car = loadImage("Car.png");
  reversedCar = loadImage("CarReversed.png");
}