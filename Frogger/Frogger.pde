Population population;
float mutationRate = 0.1f;
boolean genetic = true;
boolean playerControlled = false;
int ticksPerUpdate = 5;
Frog playerFrog;

void setup() {
  size(650, 800);
  background(51);
  loadAllImages();
  population = new Population(100);
  playerFrog = population.frogs[0];
}

void draw() {
  background(51);
  if (!playerControlled) {
    if (population.isAlive()) {
      population.updateAlive();
    }
    else {
     population.calculateFitness();
     population.naturalSelection();
    }
  } else {
    playerFrog.road.update();
    playerFrog.road.show();
    if (playerFrog.alive) {
      playerFrog.update();
      playerFrog.show();
    } else {
      playerFrog.reset();
    }
  }
}

void keyPressed() {
  if (playerControlled) {
    switch(key) {
    case 'w':
      playerFrog.moveUp();
      break;
    case 'a':
      playerFrog.moveLeft();
      break;
    case 's':
      playerFrog.moveDown();
      break;
    case 'd':
      playerFrog.moveRight();
      break;
    }
  }
}