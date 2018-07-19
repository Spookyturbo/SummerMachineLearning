class Road {
  int rowHeight = 50;
  ArrayList<Car[]> rows;
  Frog frog;

  //Not utilized yet
  //public Road(ArrayList<Car[]> rows) {
  //  this.rows = rows;
  //}

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

  public void update() {
    for (Car[] cars : rows) {
      for (Car car : cars) {
        car.update();
        car.draw();
      }
    }

    frog.draw();

    if (checkCollisions(frog.position, frog.size) || frog.position.y >= rowHeight * (rows.size() + 1)) {
      resetGame();
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
}