/*
  The backpropagation boolean at the top of this page set false to use the original method and set true to use the backpropagation
  If you use the backpropagation you can check where the train() method is being used in the Player file in the think() method
  If you enable both backpropagation and humanTraining, when you activate humanplayer mode by pressing p, once you die, the machine learns
  from your inputs but it does not work very well so I suggest leaving humanPlayer alone as false.
*/
Player humanPlayer;//the player which the user (you) controls
Population pop; 
int speed = 100; //Calls of draw() per second
int trainingSpeed = 1; //How many calls of updateAlive per draw call
float globalMutationRate = 0.1;
PFont font;
//boolean Values 
boolean showBest = true;//true if only show the best of the previous generation
boolean runBest = false; //true if replaying the best ever game
boolean humanPlaying = false; //true if the user is playing
boolean displayEnabled = true;
boolean backpropagation = true;
boolean humanTraining  = false;
ArrayList<float[]> trainingInputs = new ArrayList<float[]>();
ArrayList<float[]> trainingOutputs = new ArrayList<float[]>();

void setup() {//on startup
  size(1200, 675);

  humanPlayer = new Player();
  pop = new Population((backpropagation) ? 1 : 200);// create new population of size 200
  frameRate(speed);
  font = loadFont("AgencyFB-Reg-48.vlw");
}
//------------------------------------------------------------------------------------------------------------------------------------------
//Advances to the next generation as fast as possible, auto stops if has not reached next gen after 1 minute
void nextGeneration() {
  double startTime = millis();
  displayEnabled = false;

  while (!pop.done() && millis() - startTime < 60000) {
    pop.updateAlive();
  }

  if (!backpropagation) {
    pop.calculateFitness(); 
    pop.naturalSelection();
  }

  displayEnabled = true;
}
//------------------------------------------------------------------------------------------------------------------------------------------
//Collects training data and then trains a new network after a human played match
void humanTraining() {
  for (float[] input : trainingOutputs) {
    for (int i = 0; i < input.length; i++) {
      print(input[i]);
    }
    println();
  }
  Player player = new Player();
  for (int i = 0; i < 50; i++) {
    for (int j = 0; j < trainingInputs.size(); j++) {
      player.brain.train(trainingInputs.get(j), trainingOutputs.get(j));
    }
  }
  pop.players[0] = player;
}
//------------------------------------------------------------------------------------------------------------------------------------------
void draw() {
  background(0); //deep space background
  if (humanPlaying) {//if the user is controling the ship[
    if (!humanPlayer.dead) {//if the player isnt dead then move and show the player based on input
      humanPlayer.update();
      humanPlayer.show();
      //Retrieve the state of the player and store it for training purposes
      if (humanTraining) {
        ArrayList<float[]> playerState = humanPlayer.getState();
        trainingInputs.add(playerState.get(0));
        trainingOutputs.add(playerState.get(1));
      }
    } else {//once done return to ai
      humanPlaying = false;
      if (humanTraining) {
        humanTraining();
      }
    }
  } else 
  if (runBest) {// if replaying the best ever game
    if (!pop.bestPlayer.dead) {//if best player is not dead
      pop.bestPlayer.look();
      pop.bestPlayer.think();
      pop.bestPlayer.update();
      pop.bestPlayer.show();
    } else {//once dead
      runBest = false;//stop replaying it
      pop.bestPlayer = pop.bestPlayer.cloneForReplay();//reset the best player so it can play again
    }
  } else {//if just evolving normally
    displayEnabled = false;
    for (int i = 0; i < trainingSpeed; i++) {
      if (!pop.done()) {//if any players are alive then update them
        if (i == trainingSpeed - 1) {
          displayEnabled = true;
        }
        pop.updateAlive();
      } else {//all dead
        //genetic algorithm 
        if (!backpropagation) {
          pop.calculateFitness(); 
          pop.naturalSelection();
        } else {
          pop.reviveAll();
        }
      }
    }
  }
  showScore();//display the score
}
//------------------------------------------------------------------------------------------------------------------------------------------

void keyPressed() {
  switch(key) {
  case ' ':
    if (humanPlaying) {//if the user is controlling a ship shoot
      humanPlayer.shoot();
      humanPlayer.wantToShoot = true;
    } else {//if not toggle showBest
      showBest = !showBest;
    }
    break;
  case 'p'://play
    humanPlaying = !humanPlaying;
    humanPlayer = new Player();
    //Reset the recorded information
    trainingInputs.clear();
    trainingOutputs.clear();
    break;  
  case '+'://speed up frame rate
    if (speed < 300) {
      speed += 10;
      frameRate(speed);
    } else {
      trainingSpeed += 1;
    }
    println("Framerate: " + speed);
    println("Training Speed: " + trainingSpeed);
    break;
  case '-'://slow down frame rate
    if (trainingSpeed > 1) {
      trainingSpeed -= 1;
    } else {
      if (speed > 10) {
        speed -= 10;
        frameRate(speed);
      }
    }
    println("Framerate: " + speed);
    println("Training Speed: " + trainingSpeed);
    break;
  case 'h'://halve the mutation rate
    globalMutationRate /=2;
    println(globalMutationRate);
    break;
  case 'd'://double the mutation rate
    globalMutationRate *= 2;
    println(globalMutationRate);
    break;
  case 'b'://run the best
    runBest = true;
    break;
  case 's':
    nextGeneration();
    break;
  }

  //player controls
  if (key == CODED) {
    if (keyCode == UP) {
      humanPlayer.boosting = true;
    }
    if (keyCode == LEFT) {
      humanPlayer.spin = -0.08;
    } else if (keyCode == RIGHT) {
      humanPlayer.spin = 0.08;
    }
  }
}

void keyReleased() {
  //once key released
  if (key == ' ') {
    humanPlayer.wantToShoot = false;
  }
  if (key == CODED) {
    if (keyCode == UP) {//stop boosting
      humanPlayer.boosting = false;
    }
    if (keyCode == LEFT) {// stop turning
      humanPlayer.spin = 0;
    } else if (keyCode == RIGHT) {
      humanPlayer.spin = 0;
    }
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------
//function which returns whether a vector is out of the play area
boolean isOut(PVector pos) {
  if (pos.x < -50 || pos.y < -50 || pos.x > width+ 50 || pos.y > 50+height) {
    return true;
  }
  return false;
}

//------------------------------------------------------------------------------------------------------------------------------------------
//shows the score and the generation on the screen
void showScore() {
  if (humanPlaying) {
    textFont(font);
    fill(255);
    textAlign(LEFT);
    text("Score: " + humanPlayer.score, 80, 60);
  } else
    if (runBest) {
      textFont(font);
      fill(255);
      textAlign(LEFT);
      text("Score: " + pop.bestPlayer.score, 80, 60);
      text("Gen: " + pop.gen, width-200, 60);
    } else {
      if (showBest) {
        textFont(font);
        fill(255);
        textAlign(LEFT);
        text("Score: " + pop.players[0].score, 80, 60);
        text("Gen: " + pop.gen, width-200, 60);
      }
    }
}
