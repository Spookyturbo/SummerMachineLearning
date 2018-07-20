class Population {

  Road road;
  Frog[] frogs;
  Frog bestFrog;
  int generation = 0;

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
    displayGeneration();
    road.update();
    for (Frog frog : frogs) {
      if (frog.alive) {
        frog.updateAI();
        //frog.show();
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

  //Not going to change frogs, only change their brains and reset them
  public void naturalSelection() {
    bestFrog = getBestFrog();
    Frog[] newFrogs = new Frog[frogs.length];

    for (int i = 0; i < frogs.length; i++) {
      Frog newFrog = new Frog(road);
      if (i < frogs.length / 2) {
        newFrog.brain = selectFrog().brain.clone();
      } else {
        newFrog.brain = selectFrog().brain.crossover(selectFrog().brain);
      }
      newFrog.brain.mutate(mutationRate);
      newFrogs[i] = newFrog;
    }
    //ensure the best lives on
    newFrogs[0].brain = bestFrog.brain.clone();
    bestFrog = newFrogs[0];
    
    frogs = newFrogs;
    generation++;
  }

  Frog selectFrog() {
    ArrayList<Frog> selectionField = new ArrayList<Frog>();
    //Populate the selectionField proportionately to the frogs fitness so higher fitness frogs are more likely to be selected
    for (Frog frog : frogs) {
      for (int i = 0; i < frog.fitness; i++) {
        selectionField.add(frog);
      }
    }

    int index = (int) random(0, selectionField.size());
    return selectionField.get(index);
  }

  public boolean isAlive() {
    for (Frog frog : frogs) {
      if (frog.alive) {
        return true;
      }
    }
    return false;
  }

  public Frog getBestFrog() {
    int bestFrogIndex = 0;
    for (int i = 0; i < frogs.length; i++) {
      if (frogs[i].fitness > frogs[bestFrogIndex].fitness) {
        bestFrogIndex = i;
      }
    }

    return frogs[bestFrogIndex];
  }

  public Frog[] getFrogs() {
    return frogs;
  }

  void displayGeneration() {
    fill(255, 255, 255);
    textSize(32);
    text(generation, width - 32, 32);
  }
}