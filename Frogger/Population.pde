class Population {

  Road road;
  Frog[] frogs;
  Frog bestFrog;

  public Population(int populationSize) {
    road = new Road(height/50 - 2, 2);
    frogs = new Frog[populationSize];

    for (int i = 0; i < populationSize; i++) {
      frogs[i] = new Frog(road);
    }

    //Initiliazed to any frog
    bestFrog = frogs[0];
  }

  public void updateAlive() {
    road.update();
    for (Frog frog : frogs) {
      if (frog.alive) {
        frog.updateAI();
        frog.show();
      }
    }

    road.show();
    if (bestFrog.alive) {
      bestFrog.show();
    }
  }

  public void calculateFitness() {
    for (Frog frog : frogs) {
      frog.calculateFitness();
    }
  }

  public boolean isAlive() {
    for (Frog frog : frogs) {
      if (frog.alive) {
        return true;
      }
    }
    return false;
  }


  public Frog[] getFrogs() {
    return frogs;
  }
}