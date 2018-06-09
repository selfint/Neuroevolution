class Creature {
 
  float x, y, dir;
  float health;
  float size;
  float[][] sensorPos;
  float mouthX, mouthY;
  float energy;
  boolean dead;
  
  // dna
  int sensors;
  float speed;
  float sensorRange;
  Dna dna;
  
  // brain
  NeuralNetwork brain;
  float[] sensoryInput;
  float[] sensoryInput2;
  
  // gen algo
  float fitness;
  int foodEaten = 0;
  float maxEnergy = 0;
  int children = 0;
  float distanceMoved = 0;
  float timeAlive = 0;
  float age = 0;
  int generation = 1;
  int name;
  int sensorType;
  int mother = -1, father = -1;
  int motherg = -1, fatherg = -1;
  
  // math functions
  float distance(float ax, float ay, float bx, float by) {
    return sqrt(pow(ax - bx, 2) + pow(ay - by, 2));
  }

  public Creature() {
    
  }
  
  public Creature(Dna dna, int name, float energy, float health, float x, float y, float dir, float size) {
    this.dna = dna;
    this.name = name;
    this.sensors = dna.sensors;
    this.sensorType = dna.sensorType;
    this.sensorPos = new float[this.sensors][2];
    this.energy = energy;
    this.health = health;
    this.sensorRange = dna.sensorRange;
    this.speed = dna.speed;
    
    this.brain = new NeuralNetwork(dna.dimensions);
    this.brain.setWeights(dna.weights);
    this.sensoryInput = new float[sensors];
    this.sensoryInput2 = new float[sensors];
    this.dead = false;
    this.fitness = 0;
    
    this.x = x;
    this.y = y;
    this.dir = dir;
    this.size = size;
  } 
  
  public Creature(int name, int sensorsMax, float speedMax, float sensorRangeMax, int[] dimensions, 
                  float energy, float health, float x, float y, float dir, float size) {
    this.dna = new Dna(sensorsMax, speedMax, sensorRangeMax, dimensions);
    this.name = name;
    this.sensors = dna.sensors;
    this.sensorType = dna.sensorType;
    this.sensorPos = new float[this.sensors][2];
    this.energy = energy;
    this.health = health;
    this.sensorRange = dna.sensorRange;
    this.speed = dna.speed;
    
    this.brain = new NeuralNetwork(this.dna.dimensions);
    this.brain.setWeights(this.dna.weights);
    this.sensoryInput = new float[sensors];
    this.sensoryInput2 = new float[sensors];
    this.dead = false;
    this.fitness = 0;
    
    this.x = x;
    this.y = y;
    this.dir = dir;
    this.size = size;
  }
  
  void moveForward(float[] thoughts) {
    if (!this.dead) {
      float temp = 1;
      if (this.energy > 300)
        temp = 2;
      if (this.energy > 900)
        temp = 3;
      this.fitness += 0.05 * temp;
      float moveSpeed = this.speed * thoughts[1] * 0.4 + this.speed * 0.6;
      if (this.energy > this.maxEnergy)
        this.maxEnergy = this.energy;
      if (thoughts[0] > 0.5)
        this.dir += (thoughts[0] - 0.5) * moveSpeed * 8.0;
      else
        this.dir -= (0.5 - thoughts[0]) * moveSpeed * 8.0;
      while (this.dir >= 360)
        this.dir -= 360;
      while (this.dir < 0)
        this.dir += 360;
      
      this.x += moveSpeed * cos(radians(this.dir));
      this.y += moveSpeed * sin(radians(this.dir));
      this.distanceMoved += abs(moveSpeed * (cos(radians(this.dir)) + sin(radians(this.dir))));
      float energyConsumption = 0;
      energyConsumption += moveSpeed / 10.0;
      energyConsumption += this.sensors / 100.0;
      energyConsumption += this.sensorRange / 1000.0;
      if (this.energy <= 0)
        this.energy = 0;
      this.energy -= energyConsumption;
    }
  }
  
  void update(float scale) {
   this.mouthX = this.x + this.size * cos(radians(this.dir)) * 0.45 * scale;
   this.mouthY = this.y + this.size * sin(radians(this.dir)) * 0.45 * scale;
   if (mouseX < this.x + this.size / 2.0 && mouseX > this.x - this.size / 2.0)
     if (mouseY < this.y + this.size / 2.0 && mouseY > this.y - this.size / 2.0)
       this.brain.show(this.x + 50, this.y + 50, 15);
   if (this.energy <= 0)
     this.health -= 0.5;
   else if (this.health < 100)
     this.health += 0.4;
   if (this.health <= 0) {
     this.health = 0;
     this.dead = true;
   }
   for(int i = 0; i < this.sensors; i++) {
     float sensorOffsetAngle = this.dir + (360.0 / this.sensors) * i + (360.0 / (this.sensors * 2.0));
     float sensorXOffset = cos(radians(sensorOffsetAngle)) * this.size * scale;
     float sensorYOffset = sin(radians(sensorOffsetAngle)) * this.size * scale;
     float[] sensorPos = new float[]{this.x + sensorXOffset * 0.6, this.y + sensorYOffset * 0.6};
     this.sensorPos[i] = sensorPos;
   }
   
   if (this.sensorType == 0) {
     float[] thoughts = this.brain.forwardsPropagation(this.sensoryInput);
     moveForward(thoughts);
   }
   else {
     float[] thoughts2 = this.brain.forwardsPropagation(this.sensoryInput2);
     moveForward(thoughts2);
   }
  }
  
  void specialUpdate(float scale) {
   this.mouthX = this.x + this.size * cos(radians(this.dir)) * 0.45 * scale;
   this.mouthY = this.y + this.size * sin(radians(this.dir)) * 0.45 * scale;
   if (mouseX < this.x + this.size / 2.0 && mouseX > this.x - this.size / 2.0)
     if (mouseY < this.y + this.size / 2.0 && mouseY > this.y - this.size / 2.0)
       this.brain.show(this.x + 50, this.y + 50, 15);
     
   if (this.energy <= 0)
     this.health -= 0.5;
   else if (this.health < 100)
     this.health += 0.4;
   if (this.health <= 0) {
     this.health = 0;
     this.dead = true;
   }
   for(int i = 0; i < this.sensors; i++) {
     float sensorOffsetAngle = this.dir + (360.0 / this.sensors) * i + (360.0 / (this.sensors * 2.0));
     float sensorXOffset = cos(radians(sensorOffsetAngle)) * this.size * scale;
     float sensorYOffset = sin(radians(sensorOffsetAngle)) * this.size * scale;
     float[] sensorPos = new float[]{this.x + sensorXOffset * 0.6, this.y + sensorYOffset * 0.6};
     this.sensorPos[i] = sensorPos;
   }
  }
  
  float normalizeAngle(float angle) {
   while(angle >= 360)
     angle -= 360;
   while(angle < 0)
     angle += 360;
   
   return angle;
  }
  
  Food calcSensoryInput2(Food[] foods, float minFoodSize, float maxFoodSize) {
    Food fEaten = null;
    boolean drawLine = false;
    for (int i = 0; i < this.sensors; i++) {
      float minDistance = this.sensorRange;
      this.sensoryInput2[i] = -6.0;
      for (Food f : foods) {
        float foodProportion = ((f.amount - minFoodSize) / (maxFoodSize - minFoodSize)) / 10.0;
        float a = distance(f.x, f.y, this.x, this.y);
        a -= a * foodProportion;
        float an = angle(this.x, this.y, f.x, f.y, this.dir);
        float sensorAngle = 360.0 / this.sensors;
        if (drawLine) {
          line(this.x, this.y, f.x, f.y);
          text(an, (this.x + f.x) / 2.0, (this.y + f.y) / 2.0);
        }
        if (a < minDistance) {
          if (an >= sensorAngle * (i) && an <= sensorAngle * (i + 1)) {
            minDistance = a;
          }
        }
        this.sensoryInput2[i] = (1.0 - minDistance / this.sensorRange) * 12.0 - 6.0;
        if (distance(f.x, f.y, this.mouthX, this.mouthY) < f.amount / 2.0 + this.size / 5.0)
          fEaten = f;
      }
      //println(this.sensoryInput2[0], this.sensoryInput2[1]);
      
    }
    //printArray(this.sensoryInput2);
    return fEaten;
  }
  
  Food calcSensoryInput(Food[] foods, float minFoodSize, float maxFoodSize, float scale) {
    for (int i = 0; i < this.sensors; i++) { 
      float[] sensorPosition = this.sensorPos[i];
      float minDistance = 1000000;
      for (Food f : foods) {
        if (distance(f.x, f.y, this.mouthX, this.mouthY) < (f.amount / 2.0 + this.size / 5.0) * scale)
          return f;
        float foodProportion = ((f.amount - minFoodSize) / (maxFoodSize - minFoodSize)) / 10.0;
        float a = distance(f.x, f.y, sensorPosition[0], sensorPosition[1]);
        a -= a * foodProportion;
        if (a < minDistance) {
          minDistance = a;
        }
      }
      if (minDistance < this.sensorRange) { 
        this.sensoryInput[i] = (1.0 - minDistance / this.sensorRange) * 12.0 - 6.0;
      }
      else
        this.sensoryInput[i] = -6.0;
    }
    return null;
  }
    
  float angle(float ax, float ay, float bx, float by, float dir) {
    float abx = abs(ax - bx);
    float aby = abs(ay - by);
    float abh = sqrt(pow(abx, 2) + pow(aby, 2));
      
    float asinab = degrees(asin(aby / abh));
    if (bx < ax && by > ay)
      asinab = 360 - asinab;
    else if (bx >= ax && by <= ay)
      asinab = 180 - asinab;
    else if (bx >= ax && by >= ay)
      asinab = 180 + asinab;
    
    asinab += 180 - dir;
    while (asinab >= 360)
      asinab -= 360;
    while (asinab < 0)
      asinab += 360;
    return asinab;
  }
  
  void show(float scale) {
   this.mouthX = this.x + this.size * cos(radians(this.dir)) * 0.45 * scale;
   this.mouthY = this.y + this.size * sin(radians(this.dir)) * 0.45 * scale;
   //showSensorRange();
   for(int i = 0; i < this.sensors; i++) {
     float sensorOffsetAngle = this.dir + (360.0 / this.sensors) * i + (360.0 / (this.sensors * 2.0));
     float sensorXOffset = cos(radians(sensorOffsetAngle)) * this.size * scale;
     float sensorYOffset = sin(radians(sensorOffsetAngle)) * this.size * scale;
     float[] sensorPos = new float[]{this.x + sensorXOffset * 0.6, this.y + sensorYOffset * 0.6};
     this.sensorPos[i] = sensorPos;
   }
   ellipseMode(CENTER);
   strokeWeight(this.size / 20.0 * scale);
   stroke(0);
   // body
   if (this.sensors == 2)
     fill(100, 180, 100);
   else if (this.sensors == 3)
     fill(180, 100, 100);
   else if (this.sensors == 4)
     fill(100, 100, 180);
   else if (this.sensors == 5)
     fill(180, 180, 100);
   else
     fill(100, 180, 180);
   ellipse(this.x, this.y, this.size * scale, this.size * scale);
   
   
   // sensors
   for(float[] sensorPosition : this.sensorPos) {
     float[] pos = sensorPosition;
     //fill(255, 255, 255, 10);
     //ellipse(pos[0], pos[1], this.sensorRange / 2.0, this.sensorRange / 2.0);
     if (this.sensorType == 0)
       fill(255, 0, 0);
     else
       fill(0, 0, 255);
     ellipse(pos[0], pos[1], this.size / 3.0 * scale, this.size / 3.0 * scale);
   }
   
   // health bar
   fill(255, 0, 0);
   rectMode(CENTER);
   rect(this.x, this.y + this.size * scale, this.health / 2.0 * scale, this.size / 5.0 * scale);
   
   // energy bar
   if (this.energy < 300)  {
     fill(0, 255, 0);
     rect(this.x, this.y + this.size * 6.25 / 5.0 * scale, this.energy / 2.0 * scale, this.size / 5.0 * scale);
   } 
   else if (this.energy < 900){
     fill(0, 0, 255);
     rect(this.x, this.y + this.size * 6.25 / 5.0 * scale, this.energy / 6.0 * scale, this.size / 5.0 * scale);
   } 
   else{
     fill(255, 255, 255);
     rect(this.x, this.y + this.size * 6.25 / 5.0 * scale, 150 / 2.0 * scale, this.size / 5.0 * scale);
   }
   
   // mouth
   ellipse(this.mouthX, this.mouthY, this.size / 5.0 * scale, this.size / 5.0 * scale);
  }
  
  void showSensorRange() {
   if (this.sensorType == 0) {
     for(float[] sensorPosition : this.sensorPos) {
       float[] pos = sensorPosition;
       fill(255, 255, 255, 0);
       stroke(0);
       strokeWeight(3);
       ellipse(pos[0], pos[1], this.sensorRange, this.sensorRange);
     }
   }
   else {
     for (int i = 0; i < this.sensors; i++) {
       float tx, ty;
       float x, y;
       x = this.x;
       y = this.y;
       tx = cos(radians(360.0 / (this.sensors) * (i) + this.dir)) * this.sensorRange;
       ty = sin(radians(360.0 / (this.sensors) * (i) + this.dir)) * this.sensorRange;
       float angleStart = 360.0 / (this.sensors) * i + this.dir;
       float angleAmount = 360.0 / (this.sensors);
       float angleEnd = angleStart + angleAmount;
       strokeWeight(3);
       stroke(0);
       line(x, y, x + tx, y + ty);
       textSize(20);
       fill(0);
       text(angleStart - this.dir, x + tx, y + ty);
       noStroke();
       //strokeWeight(3);
       if (this.sensoryInput2[i] > -6.0) {
         fill(255, 0, 0, 255 / 4.0);  
         arc(x, y, this.sensorRange * 2, this.sensorRange * 2, 
             radians(angleStart), radians(angleEnd)); 
       }
       strokeWeight(3);
       stroke(0);
       line(x, y, x + tx, y + ty);
     }
   }
  }
}