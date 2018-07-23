Population population;
float mutationRate = 0.1f;
boolean genetic = false;
boolean playerControlled = false;
boolean showBest = true;
int framesPerSecond = 100;
int maxFrames = 300;
int loopsPerFrame = 1;
int ticksPerUpdate = 5;
Frog playerFrog;

void setup() {
  size(550, 600);
  background(51);
  loadAllImages();
  population = new Population(1);
  playerFrog = population.frogs[0];
  frameRate(framesPerSecond);
}
int y = 0;
void draw() {
  background(51);
  for (int i = 0; i < loopsPerFrame; i++) {
    if (!playerControlled) {
      if (population.isAlive()) {
        population.updateAlive();
      } else {
        if (genetic) {
          population.calculateFitness();
          population.naturalSelection();
        } else {
          population.resetFrogs();
        }
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

  switch(key) {
  case ' ':
    showBest = !showBest;
    break;
  case 'p':
    playerControlled = !playerControlled;
    break;
  case '+':
    if (framesPerSecond < maxFrames) {
      framesPerSecond += 10;
      frameRate(framesPerSecond);
    } else {
      loopsPerFrame++;
    }
    println("Frames: " + framesPerSecond + " Loops: " + loopsPerFrame);
    break;
  case '-':
    if (loopsPerFrame > 1) {
      loopsPerFrame--;
    } else {
      framesPerSecond -= 10;
      frameRate(framesPerSecond);
    }
    println("Frames: " + framesPerSecond + " Loops: " + loopsPerFrame);
    break;
  }
}