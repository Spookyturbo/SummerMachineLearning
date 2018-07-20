class Road {
  public int rowHeight = 50;
  ArrayList<Car[]> rows;
  public Frog frog;

  //Used for creating copies without creating more cars
  public Road(ArrayList<Car[]> rows) {
    this.rows = rows;
  }

  public Road(int rows, int carsPerRow) {
    frog = new Frog(rowHeight);
    frog.setRoad(this);

    initializeCars(rows, carsPerRow);
  }

  void initializeCars(int rows, int carsPerRow) {
    this.rows = new ArrayList<Car[]>();

    float distanceBetweenCars = width / carsPerRow;
    boolean directionRight = false;

    for (int i = 0; i < rows; i++) {
      Car[] cars = new Car[carsPerRow];
      //randomizing the positions of the cars
      float initialX = random(0, width);
      float carY = rowHeight * (i + 1);
      directionRight = !directionRight;
      for (int j = 0; j < carsPerRow; j++) {
        //Evenly spaces out the cars and ensure position is on screen
        float carX = initialX + j * distanceBetweenCars;
        carX = wrap(carX, 0, width);
        cars[j] = new Car(carX, carY, rowHeight, directionRight);
      }
      this.rows.add(cars);
    }
  }

  public void show() {
    rectMode(CORNER);
    fill(255, 0, 0);
    textSize(32);
    text(frog.score, 0, 32);

    for (Car[] cars : rows) {
      for (Car car : cars) {
        car.draw();
      }
    }

    frog.draw();
  }

  public void update() {
    for (Car[] cars : rows) {
      for (Car car : cars) {
        car.update();
      }
    }

    //Hit a car or reached the end
    if (checkCollisions(frog.position, frog.size) || frog.position.y >= rowHeight * (rows.size() + 1)) {
      endGame();
    }
  }

  public void updateAI() {
    frog.look();
    frog.think();
    update();
  }

  boolean checkCollisions(PVector position, PVector size) {
    for (Car[] cars : rows) {
      for (Car car : cars) {
        if (car.checkCollision(position, size)) {
          return true;
        }
      }
    }
    return false;
  }

  void endGame() {
    frog.setAlive(false);
  }

  void resetGame() {
    frog.reset();
    initializeCars(rows.size(), rows.get(0).length);
  }

  float wrap(float v, float min, float max) {
    if (v > max) {
      return min + (v - max);
    } else if (v < min) {
      return max - (min - v);
    }

    return v;
  }

  public Frog getFrog() {
    return frog;
  }
  
  public Road copy() {
      Road road = new Road(rows);
      return road;
  }
}