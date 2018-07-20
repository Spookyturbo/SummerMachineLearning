class Population {

  Frog[] frogs;
  Frog bestFrog;

  public Population(int populationSize) {
    frogs = new Frog[populationSize];
    
    Frog frog = new Road(height/50 - 2, 2).getFrog();
    frogs[0] = frog;
    for (int i = 1; i < populationSize; i++) {
      Road road = frog.road.copy();
      road.frog = new Frog(road.rowHeight);
      frogs[i] = frog;
    }

    //Initiliazed to any frog
    bestFrog = frogs[0];
  }

  public void updateAlive() {
    for (Frog frog : frogs) {
      frog.road.updateAI();
    }

    bestFrog.road.show();
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