import processing.pdf.*;

class NeuralNetwork {
 
  int[] dimensions;
  int size;
  Layer[] layers;
  
  public NeuralNetwork() {
    
  }
  
  public NeuralNetwork(int[] dimensions) {
    this.dimensions = dimensions;
    this.size = dimensions.length;
    this.layers = new Layer[this.size];
    for (int i = 0; i < this.size-1; i++) {
      this.layers[i] = new Layer(this.dimensions[i], this.dimensions[i+1]);
    }
    this.layers[this.layers.length-1] = new Layer(this.dimensions[this.size-1], -1);
  }  
  
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
  
  float[] forwardsPropagation(float[] inputs) {
    this.layers[0].nodeDatas = inputs;
    for (int i = 0; i < this.size - 1; i++) {
      Layer layer = this.layers[i];
      Layer nextLayer = this.layers[i + 1];
      layer.calcOutputs();
      nextLayer.calcData(layer);
    }
    this.layers[this.size - 1].calcOutputs();
    //float[] networkOutput = this.layers[this.size - 1].nodeOutputs;
    //print("OUTPUT: ");
    //for (float output : networkOutput) 
    //  print(output + ", ");
    //println();
    return this.layers[this.size - 1].nodeOutputs;
  }
  
  float[][][] getWeights() {
    float[][][] weights = new float[this.dimensions.length][][]; 
    for(int i = 0; i < this.dimensions.length; i++) {
      Layer l = this.layers[i];
      weights[i] = l.weights;
    }
    return weights;
  }
  
  void setWeights(float[][][] weights) {
    for(int i = 0; i < this.dimensions.length - 1; i++) {
      Layer l = this.layers[i];
      l.weights = weights[i];      
    }
  }
  
  void show(float x, float y, float scale) {
    int maxSize = max(this.dimensions);
    for (int i = 0; i < this.size - 1; i++) {
      Layer layer = this.layers[i];
      Layer nextLayer = this.layers[i+1];
      for (int k = 0; k < nextLayer.size; k++) {
        for (int j = 0; j < layer.size + 1; j++) {
          stroke((layer.weights[j][k] + 1) / 2.0 * 255);
          //strokeWeight(((layer.weights[j][k] + 1) / 2.0 * 3 + 1) * 0.075 * scale);
          float layerOffset = maxSize - layer.size;
          float nextLayerOffset = maxSize - nextLayer.size;
          line(x + 3 * i       * scale, y + 2 * j * scale + layerOffset     * scale, 
               x + 3 * (i + 1) * scale, y + 2 * k * scale + nextLayerOffset * scale);
        }
      }
    }
    
    for (int i = 0; i < this.size; i++) {
      Layer layer = this.layers[i];
      for (int j = 0; j < layer.size + 1; j++) {
        if (!(j == layer.size && i == this.size - 1)) {
          stroke(0);
          strokeWeight(2);
          fill(255);
          ellipseMode(CENTER);
          float layerOffset = maxSize - layer.size;
          
          ellipse(x + 3 * i * scale, y + 2 * j * scale + layerOffset * scale, 1.5 * scale, 1.5 * scale);
          String nodeOutput = "1.0";
          int temp = 0;
          if (j != layer.size) {
            nodeOutput = nf(layer.nodeOutputs[j], 0, 1);
            if (layer.nodeOutputs[j] < 0)
              temp = 1;
            if (abs(layer.nodeDatas[j]) >= 10.0) {
              float tempData = abs(layer.nodeDatas[j]);
              while (tempData >= 10) {
                tempData /= 10.0;
                temp++;
              }
            }
          }
          fill(0);
          textSize(0.5 * scale);
          text(nodeOutput, x + 3 * i * scale - 0.4 * scale - 0.2 * scale * temp, y + 2 * j * scale + layerOffset * scale + 0.2 * scale);
        }
      }
    }
  }
  
}