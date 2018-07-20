class Frog {
  Road road;

  //Score Reqs
  int score = 0;
  float maxYPosition;

  //Ai Reqs
  NeuralNet brain;
  float[] vision = new float[4]; //up, right, down, left
  boolean alive = true;
  float fitness;

  //Loading the frog
  PImage img;
  PImage rightFrog;
  PImage leftFrog;
  PImage upFrog;
  PImage downFrog;

  //Transform information
  PVector position;
  PVector size;

  //Reset Information
  PVector spawnPosition;

  public Frog(Road road) {
    this.road = road;
    brain = new NeuralNet(4, 10, 5);

    upFrog = loadImage("UpFrog.png");
    leftFrog = loadImage("LeftFrog.png");
    downFrog = loadImage("DownFrog.png");
    rightFrog = loadImage("RightFrog.png");
    img = upFrog;

    spawnPosition = new PVector((width / 2) - (road.rowHeight / 2), 0);
    this.position = spawnPosition.copy();
    size = new PVector(road.rowHeight, road.rowHeight);

    //For determining if visiting a new row for the first time
    maxYPosition = position.y;
  }

  public void update() {
    if (road.checkCollisions(position, size) || position.y > road.rowHeight * road.rows.size()) {
      alive = false;
    }
  }

  public void updateAI() {
    look();
    think();
    update();
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

  //only checks for collision when simulating the movements up, right, down, and left
  public void look() {
    PVector tmpPosition = position.copy();
    tmpPosition.y += size.y;
    vision[0] = (road.checkCollisions(tmpPosition, size)) ? 1 : 0;
    tmpPosition = position.copy();
    tmpPosition.x += size.x;
    vision[1] = (road.checkCollisions(tmpPosition, size)) ? 1 : 0;
    tmpPosition = position.copy();
    tmpPosition.y -= size.y;
    vision[2] = (road.checkCollisions(tmpPosition, size)) ? 1 : 0;
    tmpPosition = position.copy();
    tmpPosition.x -= size.x;
    vision[3] = (road.checkCollisions(tmpPosition, size)) ? 1 : 0;
  }

  long previousTime = 0;
  public void think() {
    //Makes it not able to move as fast as it wants
    if (millis() - previousTime > 50) {
      previousTime = millis();
      float[] inputs = getInputs();

      //up, right, down, left
      float[] desiredOutputs = new float[5];
      desiredOutputs[0] = (inputs[0] == 0) ? 1 : 0;
      desiredOutputs[1] = (inputs[3] == 1) ? 1 : 0;
      desiredOutputs[2] = 0;
      desiredOutputs[3] = (inputs[1] == 1) ? 1 : 0;
      desiredOutputs[4] = (inputs[0] == 1 && inputs[1] == 0 && inputs[3] == 0) ? 1 : 0;
      brain.train(inputs, desiredOutputs);
      float[] outputs = brain.output(inputs);
      int greatestIndex = 0;
      for (int i = 0; i < outputs.length; i++) {
        if (outputs[i] > outputs[greatestIndex]) {
          greatestIndex = i;
        }
      }

      switch(greatestIndex) {
      case 0:
        moveUp();
        break;
      case 1:
        moveRight();
        break;
      case 2:
        moveDown();
        break;
      case 3:
        moveLeft();
        break;
      case 4:
        //do nothing
        break;
      }
    }
  }

  public float[] getInputs() {
    look(); 
    return vision;
  }

  public void show() {
    fill(255, 255, 255);
    textSize(32);
    text(score, 0, 32);
    imageMode(CORNER);
    pushMatrix();
    scale(1, -1);
    translate(0, -height);
    image(img, position.x, position.y, size.x, size.y);
    popMatrix();
  }

  public void calculateFitness() {
    fitness = score;
  }

  public void setAlive(boolean value) {
    alive = value;
  }

  public void reset() {
    score = 0;
    fitness = 0;
    maxYPosition = spawnPosition.y;
    position = spawnPosition.copy();
    img = upFrog;
    alive = true;
  }
}