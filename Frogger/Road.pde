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
    if (checkCollisions() || frog.position.y > rowHeight * (rows.size() + 1)) {
      resetGame();
    }
  }

  boolean checkCollisions() {
    for (Car[] cars : rows) {
      for (Car car : cars) {
        float leftXBoundary = frog.position.x - frog.size.x / 2;
        float rightXBoundary = frog.position.x + frog.size.x / 2;
        if ((leftXBoundary >= car.position.x && leftXBoundary <= car.position.x + car.size.x) || (rightXBoundary >= car.position.x && rightXBoundary <= car.position.x + car.size.x)) {
          if (frog.position.y >= car.position.y && frog.position.y <= car.position.y + car.size.y) {
            return true;
          }
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