class Road {
  int rowHeight = 50;
  ArrayList<Car[]> rows;
  Frog frog;


  public Road(ArrayList<Car[]> rows) {
    this.rows = rows;
  }

  public Road(int rows, int carsPerRow, Frog frog) {
    this.frog = frog;
    this.rows = new ArrayList<Car[]>();
    initializeCars(rows, carsPerRow);
    frog.setRoad(this);
  }

  void initializeCars(int rows, int carsPerRow) {
    this.rows.clear();
    boolean directionRight = false;
    for (int i = 0; i < rows; i++) {
      Car[] cars = new Car[carsPerRow];
      float initialX = random(0, width);
      directionRight = !directionRight;
      for (int j = 0; j < carsPerRow; j++) {
        cars[j] = new Car(clamp(initialX + (((float)j / carsPerRow) * width), 0, width), rowHeight * (i + 1), rowHeight - 2, directionRight);
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
    if (checkCollisions(frog.position, frog.size) || frog.position.y >= rowHeight * (rows.size() + 1)) {
      resetGame();
    }
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

  float clamp(float v, float min, float max) {
    if (v > max) {
      return min + (v - max);
    } else if (v < min) {
      return max - (min - v);
    }

    return v;
  }
}