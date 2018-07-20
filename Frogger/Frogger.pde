//Road road;
Population population;
boolean playerControlled = true;
Frog playerFrog;

void setup() {
  size(600, 800);
  background(51);
  population = new Population(40);
  //road = new Road(height/50 - 2, 2);
  playerFrog = population.frogs[0];
}

void draw() {
  background(51);
  if (!playerControlled) {
    if (population.isAlive()) {
      population.updateAlive();
    }
  } else {
    if (playerFrog.alive) {
      playerFrog.road.update();
      playerFrog.road.show();
    }
    else {
       playerFrog.road.resetGame(); 
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