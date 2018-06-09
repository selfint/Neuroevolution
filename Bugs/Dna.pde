class Dna {
 
  float weightRange = 5.0f;
  int sensorsMax, sensors;
  float speedMax, sensorRangeMax;
  float speed;
  float sensorRange;
  float[][][] weights;
  int[] dimensions;
  int sensorType;
  int generation = 1;
  int father = -1, mother = -1;
  
  public Dna() {
    
  }
  
  public Dna(int sensorsMax, float speedMax, float sensorRangeMax, int[] dimensionsWithoutInput) {
    this.sensorsMax = sensorsMax;
    this.speedMax = speedMax;
    this.sensorRangeMax = sensorRangeMax;
    
    this.sensors = int(random(2.0, sensorsMax+1));
    this.sensorType = int(random(0, 2));
    int[] dimensions = new int[dimensionsWithoutInput.length + 1];
    dimensions[0] = this.sensors;
    for (int i = 0; i < dimensionsWithoutInput.length; i++) {
      dimensions[i+1] = dimensionsWithoutInput[i];
    }
    this.dimensions = dimensions;
    this.speed = random(1.0, speedMax);
    this.sensorRange = random(1.0, sensorRangeMax);
    this.weights = new float[dimensions.length][][];
    for (int i = 0; i < this.dimensions.length - 1; i++) {
      this.weights[i] = new float[this.dimensions[i] + 1][dimensions[i+1]];
      for (int j = 0; j < dimensions[i] + 1; j++) {
       for (int k = 0; k < dimensions[i+1]; k++) {
        this.weights[i][j][k] = random(-weightRange, weightRange); 
       }
      }
    }
  }
  
  // each chromosome and gene has a 50% change to come from each parent
  // species are determined by sensor amount, no inter-species mating
  Dna crossover(Dna father, Dna mother, float mutationRate) {
    Dna child = new Dna();
    child.dimensions = father.dimensions;
    child.sensors = father.sensors;
    child.sensorType = father.sensorType;
    if (random(0.0, 1.0) < 0.5)
      child.speed = father.speed;
    else
      child.speed = mother.speed;
    if (random(0.0, 1.0) < 0.5)
      child.sensorRange = father.sensorRange;
    else
      child.sensorRange = mother.sensorRange;
      
    if (random(0.0, 1.0) < mutationRate)
      child.speed = random(1.0, this.speedMax);
    if (random(0.0, 1.0) < mutationRate)
      child.sensorRange = random(50.0, this.sensorRangeMax);
    
    child.weights = new float[father.dimensions.length][][];
    for (int i = 0; i < father.dimensions.length - 1; i++) {
      child.weights[i] = new float[father.dimensions[i] + 1][father.dimensions[i+1]];
      for (int j = 0; j < father.dimensions[i] + 1; j++) {
       for (int k = 0; k < father.dimensions[i+1]; k++) {
         if (random(0.0, 1.0) < 0.5) {
           child.weights[i][j][k] = father.weights[i][j][k];
         } 
         else {
           child.weights[i][j][k] = mother.weights[i][j][k];
         }
         if (random(0.0, 1.0) < mutationRate)
           child.weights[i][j][k] = random(-weightRange, weightRange);
       }
      }
    }
    return child;
  }
}
