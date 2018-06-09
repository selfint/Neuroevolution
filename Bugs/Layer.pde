class Layer {
 
  float[][] weights;
  float[] nodeDatas;
  float[] nodeOutputs;
  
  int size, nextLayerSize;
  float activationFunction(float x, boolean derivative) {
    if (derivative) {
      return x * (1.0 - x);
    } else {
      return 1.0 / (1.0 + exp(-x));
    }
  }
  
  float activationFunction1(float x, boolean derivative) {
    if (derivative) {
      if(x > 0) 
        return 1;
      else
        return 0.01;
    } else {
      if(x > 0) 
        return x;
      else
        return 0.01 * x;
    }
  }
  
  public Layer() {
    
  }
  
  public Layer(int size, int nextLayerSize) {
    this.size = size;
    this.nextLayerSize = nextLayerSize;
    this.nodeDatas = new float[this.size];
    this.nodeOutputs = new float[this.size];
    if (nextLayerSize > 0) {
      this.generateWeights();
    }
  }
  
  void generateWeights() {
    // if not output layer
    this.weights = new float[this.size + 1][this.nextLayerSize];
    for (int i = 0; i < this.size + 1; i++) {
     for (int j = 0; j < this.nextLayerSize; j++) {
      this.weights[i][j] = random(-1.0, 1.0); 
     }
    }
  }
  
  void calcOutputs() {
    for (int i = 0; i < this.size; i++) {
      this.nodeOutputs[i] = this.activationFunction(this.nodeDatas[i], false);
    }
  }
  
  void calcData(Layer prevLayer) {
    for (int j = 0; j < this.size; j++) {
      float nodeInput = 0;
      for (int i = 0; i < prevLayer.size; i++) {
        nodeInput += prevLayer.nodeOutputs[i] * prevLayer.weights[i][j];
      }
      // bias node
      nodeInput += 1 * prevLayer.weights[prevLayer.size][j];
      this.nodeDatas[j] = nodeInput;
    }
  }
  
}