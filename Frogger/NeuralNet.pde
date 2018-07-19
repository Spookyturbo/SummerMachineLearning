class NeuralNet {

  int iNodes;//No. of input nodes
  int hNodes;//No. of hidden nodes
  int oNodes;//No. of output nodes

  Matrix whi;//matrix containing weights between the input nodes and the hidden nodes
  Matrix whh;//matrix containing weights between the hidden nodes and the second layer hidden nodes
  Matrix woh;//matrix containing weights between the second hidden layer nodes and the output nodes

  /*  Matrix Structure
   // [ I1O1, I2O1, BO1 ]
   // [ I1O2, I202, BO2 ]
   // I = Input O = Output B = Bias
   // This is for a 2 input 2 output structure network
   // Row = Output (The outputs are the same on each row)
   // Col = Input (The inputs are the same on each column)
   // This makes the input require a 1 at the very bottom of the column matrix so the bias works properly
   // EX input matrix
   // [ I1 ]
   // [ I2 ]
   // [ 1  ] (1 so that it can not be 0 when multiplied with the weight)
   */

  //constructor
  NeuralNet(int inputs, int hiddenNo, int outputNo) {

    //set dimensions from parameters
    iNodes = inputs;
    oNodes = outputNo;
    hNodes = hiddenNo;


    //create first layer weights 
    //included bias weight
    whi = new Matrix(hNodes, iNodes +1);

    //create second layer weights
    //include bias weight
    whh = new Matrix(hNodes, hNodes +1);

    //create second layer weights
    //include bias weight
    woh = new Matrix(oNodes, hNodes +1);  

    //set the matricies to random values
    whi.randomize();
    whh.randomize(); 
    woh.randomize();
  }


  //mutation function for genetic algorithm
  void mutate(float mr) {
    //mutates each weight matrix
    whi.mutate(mr);
    whh.mutate(mr);
    woh.mutate(mr);
  }

  //calculate the output values by feeding forward through the neural network
  float[] output(float[] inputsArr) {

    //convert array to matrix
    //Note woh has nothing to do with it its just a funciton in the Matrix class (Static methods are not possible in processing unless you create a .java file)
    Matrix inputs = woh.singleColumnMatrixFromArray(inputsArr);

    //add bias 
    Matrix inputsBias = inputs.addBias();


    //-----------------------calculate the guessed output

    //apply layer one weights to the inputs
    Matrix hiddenInputs = whi.dot(inputsBias);

    //pass through activation function(sigmoid)
    Matrix hiddenOutputs = hiddenInputs.activate();

    //add bias
    Matrix hiddenOutputsBias = hiddenOutputs.addBias();

    //apply layer two weights
    Matrix hiddenInputs2 = whh.dot(hiddenOutputsBias);
    Matrix hiddenOutputs2 = hiddenInputs2.activate();
    Matrix hiddenOutputsBias2 = hiddenOutputs2.addBias();

    //apply level three weights
    Matrix outputInputs = woh.dot(hiddenOutputsBias2);
    //pass through activation function(sigmoid)
    Matrix outputs = outputInputs.activate();

    //convert to an array and return
    return outputs.toArray();
  }

  //crossover funciton for genetic algorithm
  NeuralNet crossover(NeuralNet partner) {

    //creates a new child with layer matricies from both parents
    NeuralNet child = new NeuralNet(iNodes, hNodes, oNodes);
    child.whi = whi.crossover(partner.whi);
    child.whh = whh.crossover(partner.whh);
    child.woh = woh.crossover(partner.woh);
    return child;
  }

  //return a neural net whihc is a clone of this Neural net
  NeuralNet clone() {
    NeuralNet clone  = new NeuralNet(iNodes, hNodes, oNodes); 
    clone.whi = whi.clone();
    clone.whh = whh.clone();
    clone.woh = woh.clone();

    return clone;
  }

  //converts the weights matricies to a single table 
  //used for storing the snakes brain in a file
  Table NetToTable() {

    //create table
    Table t = new Table();


    //convert the matricies to an array 
    float[] whiArr = whi.toArray();
    float[] whhArr = whh.toArray();
    float[] wohArr = woh.toArray();

    //set the amount of columns in the table
    for (int i = 0; i< max(whiArr.length, whhArr.length, wohArr.length); i++) {
      t.addColumn();
    }

    //set the first row as whi
    TableRow tr = t.addRow();

    for (int i = 0; i< whiArr.length; i++) {
      tr.setFloat(i, whiArr[i]);
    }


    //set the second row as whh
    tr = t.addRow();

    for (int i = 0; i< whhArr.length; i++) {
      tr.setFloat(i, whhArr[i]);
    }

    //set the third row as woh
    tr = t.addRow();

    for (int i = 0; i< wohArr.length; i++) {
      tr.setFloat(i, wohArr[i]);
    }

    //return table
    return t;
  }


  //takes in table as parameter and overwrites the matricies data for this neural network
  //used to load snakes from file
  void TableToNet(Table t) {

    //create arrays to tempurarily store the data for each matrix
    float[] whiArr = new float[whi.rows * whi.cols];
    float[] whhArr = new float[whh.rows * whh.cols];
    float[] wohArr = new float[woh.rows * woh.cols];

    //set the whi array as the first row of the table
    TableRow tr = t.getRow(0);

    for (int i = 0; i< whiArr.length; i++) {
      whiArr[i] = tr.getFloat(i);
    }


    //set the whh array as the second row of the table
    tr = t.getRow(1);

    for (int i = 0; i< whhArr.length; i++) {
      whhArr[i] = tr.getFloat(i);
    }

    //set the woh array as the third row of the table

    tr = t.getRow(2);

    for (int i = 0; i< wohArr.length; i++) {
      wohArr[i] = tr.getFloat(i);
    }


    //convert the arrays to matricies and set them as the layer matricies
    whi.fromArray(whiArr);
    whh.fromArray(whhArr);
    woh.fromArray(wohArr);
  }

  void train(float[] inputsArr, float[] desiredOutputsArr) {
    //First do the feedForward process to see the machines prediction 
    //Make sure to save all steps of the process
    Matrix inputs = woh.singleColumnMatrixFromArray(inputsArr);
    Matrix desiredOutputs = woh.singleColumnMatrixFromArray(desiredOutputsArr);

    Matrix inputsWithBias = inputs.addBias();

    Matrix hidden1 = whi.dot(inputsWithBias);
    Matrix hidden1Outputs = hidden1.activate();
    Matrix hidden1WithBias = hidden1Outputs.addBias();

    Matrix hidden2 = whh.dot(hidden1WithBias);
    Matrix hidden2Outputs = hidden2.activate();
    Matrix hidden2WithBias = hidden2Outputs.addBias();

    Matrix outputs = woh.dot(hidden2WithBias);
    Matrix outputsActivated = outputs.activate();

    //--------------Start Backpropagation-------------------
    //--------------Find all Error First--------------------
    
    Matrix outputError = desiredOutputs.subtract(outputsActivated);
  
    //hidden2 error
    Matrix transposedWOH = woh.transpose();
    Matrix hidden2ErrorWithBias = transposedWOH.dot(outputError);
    //The bias does not have error, so remove it
    Matrix hidden2Error = hidden2ErrorWithBias.removeBottomLayer();

    //hidden1 error
    Matrix transposedWHH = whh.transpose();
    Matrix hidden1ErrorWithBias = transposedWHH.dot(hidden2Error);
    Matrix hidden1Error = hidden1ErrorWithBias.removeBottomLayer();

    //------------Use the errors to change weights via Gradient Descent-----------------
    //woh changed
    Matrix outputsDerivative = outputsActivated.sigmoidDerived();
    Matrix transposedHidden2 = hidden2WithBias.transpose();
    Matrix deltaWOH = (outputError.multiply(outputsDerivative)).dot(transposedHidden2);
    woh = woh.add(deltaWOH);
    
    //whh changed
    Matrix hidden2Derivative = hidden2Outputs.sigmoidDerived();
    Matrix transposedHidden1 = hidden1WithBias.transpose();
    Matrix deltaWHH = (hidden2Error.multiply(hidden2Derivative)).dot(transposedHidden1);
    whh = whh.add(deltaWHH);
    
    //whi changed
    Matrix hidden1Derivative = hidden1Outputs.sigmoidDerived();
    Matrix transposedInputs = inputsWithBias.transpose();
    Matrix deltaWHI = (hidden1Error.multiply(hidden1Derivative)).dot(transposedInputs);
    whi = whi.add(deltaWHI);
    
  }
}