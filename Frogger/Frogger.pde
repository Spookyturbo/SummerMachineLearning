Frog frog;
Road road;
NeuralNet brain = new NeuralNet(4, 10, 4);

void setup() {
  size(1920, 800);
  background(51);
  frog = new Frog(width/2 - 25, 0, 50);
  road = new Road(height/50 - 2, 5, frog);
}

long previousTime = 0;

void draw() {
  background(51);
  if (millis() - previousTime > 50) {
    previousTime = millis();
    float[] inputs = frog.getInputs();
    //up, right, down, left
    float[] desiredOutputs = new float[4];
    desiredOutputs[0] = (inputs[0] == 0) ? 1 : 0;
    desiredOutputs[1] = (inputs[3] == 1) ? 1 : 0;
    desiredOutputs[2] = 0;
    desiredOutputs[3] = (inputs[1] == 1) ? 1 : 0;
    brain.train(inputs, desiredOutputs);
    float[] outputs = brain.output(inputs);
    int greatestIndex = 0;
    for (int i = 0; i < outputs.length; i++) {
      if (outputs[i] > outputs[greatestIndex]) {
        greatestIndex = i;
      }
    }

    switch(greatestIndex) {
    case 0:
      frog.moveUp();
      break;
    case 1:
      frog.moveRight();
      break;
    case 2:
      frog.moveDown();
      break;
    case 3:
      frog.moveLeft();
      break;
    }
  }
  road.update();
  frog.draw();
}

void keyPressed() {
  switch(key) {
  case 'w':
    frog.moveUp();
    break;
  case 'a':
    frog.moveLeft();
    break;
  case 's':
    frog.moveDown();
    break;
  case 'd':
    frog.moveRight();
    break;
  }
}