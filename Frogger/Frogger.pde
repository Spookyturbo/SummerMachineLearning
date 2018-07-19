Road road;
NeuralNet brain = new NeuralNet(4, 10, 4);
boolean playerControlled = false;
Frog playerFrog;

void setup() {
  size(600, 800);
  background(51);
  road = new Road(height/50 - 2, 2);
  playerFrog = road.getFrog();
}

void draw() {
  background(51);
  if (!playerControlled) {
    road.updateAI();
  } else {
    road.update();
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