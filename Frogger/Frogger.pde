Frog frog;
Road road;

void setup() {
  size(800, 800);
  background(51);
  frog = new Frog(width/2, 25, 50);
  road = new Road(height/50 - 2, 2, frog);
}

void draw() {
  background(51);
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