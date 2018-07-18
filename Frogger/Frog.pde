class Frog {

  //Prevent lag of loading image midgame
  PImage img;
  PImage rightFrog;
  PImage leftFrog;
  PImage upFrog;
  PImage downFrog;
  PVector position;
  PVector size;
  int score = 0;
  float maxYPosition;
  PVector spawnPosition;

  public Frog(int x, int y, int scale) {
    upFrog = loadImage("UpFrog.png");
    leftFrog = loadImage("LeftFrog.png");
    downFrog = loadImage("DownFrog.png");
    rightFrog = loadImage("RightFrog.png");
    img = upFrog;
    position = new PVector(x, y);
    spawnPosition = position.copy();
    size = new PVector(scale, scale);
    maxYPosition = position.y;
  }

  public void moveUp() {
    img = upFrog;
    position.y += size.x;

    if (position.y > maxYPosition) {
      maxYPosition = position.y;
      score += 10;
    }
  }

  public void moveLeft() {
    img = leftFrog;
    position.x -= size.x;
  }

  public void moveRight() {
    img = rightFrog;
    position.x += size.x;
  }

  public void moveDown() {
    img = downFrog;
    position.y -= size.x;
  }

  public void reset() {
    score = 0;
    position = spawnPosition.copy();
    img = upFrog;
  }

  public void draw() {
    textSize(50);
    text("" + score, 0, 0, 100, 50);
    imageMode(CENTER);
    pushMatrix();
    scale(1, -1);
    translate(0, -height);
    image(img, position.x, position.y, size.x, size.y);
    popMatrix();
  }
}