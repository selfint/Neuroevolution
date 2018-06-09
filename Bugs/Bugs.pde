Creature[] creatures;
Food[] foods;
int creatureAmount;
int foodAmount;
float scale;
float birthEnergy;
float creatureSize;
float minFoodSize, maxFoodSize, finalMinFoodSize, finalMaxFoodSize;
float birthHealth;

int sensorsMax;
float speedMax;
float sensorRangeMax;
int[] dimensions;
float mutationRate;
float[] foodLife;
int[] demographics;
float livingDistance;
float maxAge;
int foodLifespan;
int foodLifeSpans;
int framRateMinimum;

float mapWidth, mapHeight;

void setup() {
  size(1250, 750);
  mapWidth = 600;
  mapHeight = 600;
  creatureSize = 25;
  this.scale = 1;
  mutationRate = 0.1f;

  // important
  creatureAmount = 30;
  foodAmount = 20;
  sensorRangeMax = 400;
  speedMax = 5;
  sensorsMax = 6;
  minFoodSize = 25.0f;
  finalMinFoodSize = 25.0f;
  maxFoodSize = 50.0f;
  finalMaxFoodSize = 50.0f;
  maxAge = 15000;
  livingDistance = 0f;
  dimensions = new int[]{2};
  foodLifeSpans = 1000;
  framRateMinimum = 10;

  foodLife = new float[foodAmount];
  birthEnergy = 100;
  birthHealth = 100;
  creatures = new Creature[creatureAmount];
  demographics = new int[sensorsMax - 1];
  for (int i = 0; i < creatureAmount; i++) {
   creatures[i] = new Creature(i, sensorsMax, speedMax, sensorRangeMax, dimensions, birthEnergy, birthHealth,
                               random(0.0, mapWidth), random(0.0, mapHeight), random(0, 360), creatureSize);
  }

  foods = new Food[foodAmount];
  for (int i = 0; i < foodAmount; i++) {
   foods[i] = new Food(random(mapWidth / 10.0, mapWidth * 9.0 / 10.0),
                       random(mapHeight / 10.0, mapHeight * 9.0 / 10.0), random(minFoodSize, maxFoodSize));
  }
}

Creature findViableMate(ArrayList<Creature> matingPool, Creature father) {
  ArrayList<Creature> compatibleMates = new ArrayList<Creature>();
  for (int i = 0; i < matingPool.size(); i++) {
    if (matingPool.get(i).sensors == father.sensors && matingPool.get(i).sensorType == father.sensorType)
      compatibleMates.add(matingPool.get(i));
  }
  return compatibleMates.get(int(random(compatibleMates.size())));
}

float dataScale = 2.0;
float maxFitness = 0;
void printPopulationStats() {
  maxFitness = 0;
  float maxEnergy = 0;
  for (Creature c : creatures) {
    if (c.fitness > maxFitness)
      maxFitness = c.fitness;
    if (c.energy > maxEnergy)
      maxEnergy = c.energy;
  }

  int index = 0;
  int bestIndex = 0;
  Creature bestCreature = new Creature();
  Creature bestEnergy = new Creature();
  for (Creature c : creatures) {
    if (c.fitness == maxFitness) {
     bestCreature = c;
     bestIndex = index;
    }
    if (c.energy == maxEnergy) {
     bestEnergy = c;
    }
    index++;
  }
  fill(255);
  textAlign(LEFT);
  textSize(15);
  //text("Max fitness: " + bestCreature.fitness, 615, 400);
  //text("Mutation rate: " + mutationRate, 615, 425);
  text("Sensor range: " + nf(bestCreature.sensorRange, 0, 1), 615, 50);
  //text("Offsprings: " + bestCreature.children, 615, 475);
  text("BEST CREATURE " + bestIndex, 615, 25);

  float prevX = bestCreature.x;
  float prevY = bestCreature.y;
  float prevE = bestCreature.energy;
  fill(255, 0, 0, 127);
  stroke(0);
  strokeWeight(3);
  ellipse(bestCreature.x, bestCreature.y, bestCreature.size * 2, bestCreature.size * 2);
  if (maxEnergy <= 300)
    fill(0, 255, 0, 127);
  else if (maxEnergy <= 900)
    fill(0, 0, 255, 127);
  else
    fill(255, 127);
  ellipse(bestEnergy.x, bestEnergy.y, bestEnergy.size * 2, bestEnergy.size * 2);

  bestCreature.x = 675;
  bestCreature.y = 100;
  bestCreature.energy = 100;
  bestCreature.specialUpdate(dataScale);
  bestCreature.show(dataScale);
  bestCreature.brain.show(630, 200, 15.0);
  bestCreature.x = prevX;
  bestCreature.y = prevY;
  bestCreature.energy = prevE;
  bestCreature.specialUpdate(simScale);
}

void drawAreas() {
  rectMode(CORNER);
  fill(0, 150, 10);
  rect(0, 0, mapWidth, mapHeight);
}

int time = 0;
// 730 - bottom
// 620 - top
float graphHeight = 110;
void drawDemographics(float x, float y) {
  stroke(3);
  rectMode(CORNER);
  textAlign(RIGHT);
  int[] demographics = new int[(sensorsMax - 1) * 2];
  for (int i = 0; i < creatures.length; i++) {
    demographics[(creatures[i].sensors-2) + (sensorsMax-1) * creatures[i].sensorType]++;
  }
  for (int i = 0; i < demographics.length; i++) {
   if (i == 2-2)
     fill(100, 180, 100);
   else if (i == 3-2)
     fill(180, 100, 100);
   else if (i == 4-2)
     fill(100, 100, 180);
   else if (i == 5-2)
     fill(180, 180, 100);
   else if (i == 6-2)
     fill(100, 180, 180);
   else if (i == 7-2)
     fill(0, 180, 0);
   else if (i == 8-2)
     fill(180, 0, 0);
   else if (i == 9-2)
     fill(0, 0, 180);
   else if (i == 10-2)
     fill(180, 180, 0);
   else if (i == 11-2)
     fill(0, 180, 180);

   rect(x + 10 * i, y, 10, -demographics[i] * 11);
  }
  fill(0);
  textSize(11);
  for (int i = 0; i < creatureAmount + 1; i++) {
    text(i, x - 10, y + 5 - 11 * i);
  }
}

float averageFitness = 0, previousAverageFitness = 0;
float deltaGraphWidth = 400, deltaGraphHeight = 80;
float[] drawDeltaAverageFitness = new float[int(deltaGraphWidth)];
void drawDeltaAverageFitnessGraph(float x, float y, int time) {
 stroke(0);
 strokeWeight(3.0);
 line(x, y, x, y - deltaGraphHeight);
 line(x, y, x + deltaGraphWidth, y);
 textSize(14);
 textAlign(LEFT);
 fill(255);
 text("DELTA AVERAGE FITNESS", x, y + 15);
 textSize(14);
 textAlign(RIGHT);
 if (time > 2) {
   if (time < deltaGraphWidth)
     text(drawDeltaAverageFitness[time-2], x - 5, y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[time-2] * 2.5);
   else {
     text(drawDeltaAverageFitness[int(deltaGraphWidth) - 2], x - 5,
       y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[int(deltaGraphWidth)-2] * 2.5);
   }
 }
 float sumFit = 0;
 for (Creature c : creatures) sumFit += c.fitness;
 previousAverageFitness = averageFitness;
 averageFitness = sumFit / creatureAmount;

 float deltaAverageFitness = averageFitness - previousAverageFitness;
 noStroke();
 fill(255);
 if (time < deltaGraphWidth) {
   drawDeltaAverageFitness[time] = deltaAverageFitness;
   for(int i = 0; i < time-1; i++) {
     ellipse(x + i, y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[i] * 2.5,
          2, 2);
     stroke(255, 0, 0);
     strokeWeight(1);
     line(x + i, y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[i] * 2.5,
          x + i + 1, y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[i+1] * 2.5);
   }
 } else {
   drawDeltaAverageFitness[int(deltaGraphWidth)-1] = deltaAverageFitness;
   for (int i = 0; i < deltaGraphWidth - 1; i++) {
     drawDeltaAverageFitness[i] = drawDeltaAverageFitness[i+1];
   }
   for(int i = 0; i < deltaGraphWidth - 1; i++) {
     ellipse(x + i, y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[i] * 2.5,
          2, 2);
     stroke(255, 0, 0);
     strokeWeight(1);
     line(x + i, y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[i] * 2.5,
          x + i + 1, y - deltaGraphHeight / 2.0 - drawDeltaAverageFitness[i+1] * 2.5);
   }
 }
}

ArrayList<Float> averageFitnessHistory = new ArrayList<Float>();
float increment = width;
float maxFitt = 0.0;
void drawAverageFitnessGraph(float x, float y, float graphWidth, float graphHeight) {
  stroke(0);
  strokeWeight(3);
  line(x - 1.5, y + 1.5, x - 1.5, y - graphHeight);
  line(x - 1.5, y + 1.5, x + graphWidth, y + 1.5);
  textSize(14);
  fill(255);
  textAlign(LEFT);
  text("AVERAGE FITNESS", x, y + 15);
  float sumFit = 0;
  for (Creature c : creatures) {
    sumFit += c.fitness;
  }
  float averageFit = sumFit / creatureAmount;
  averageFitnessHistory.add(averageFit);
  float startR = x;
  noStroke();
  float shrinkAmount = 1;
  if (maxFitt * shrinkAmount > graphHeight) {
    shrinkAmount = (graphHeight) / (maxFitt * shrinkAmount);
  }
  if (frameRate < framRateMinimum)
    averageFitnessHistory.remove(0);
  textAlign(RIGHT);
  text(0, x - 15, y);
  text(nf(maxFitt / 2.0, 0, 1), x - 10, y - maxFitt * shrinkAmount / 2.0);
  text(nf(maxFitt, 0, 1), x - 10, y - maxFitt * shrinkAmount);
  for (float fit : averageFitnessHistory) {
    if (fit > maxFitt)
      maxFitt = fit;
    rect(startR, y, increment, -fit * shrinkAmount);
    startR += increment;
  }
  if (startR > x + graphWidth)
    increment = graphWidth / averageFitnessHistory.size();
}


ArrayList<int[]> demographicHistory = new ArrayList<int[]>();
float dIncrement = width;
void demographicGraph(float x, float y, float graphWidth, float graphHeight, int updateRate, int time) {
  stroke(0);
  strokeWeight(3);
  line(x - 1.5, y + 1.5, x - 1.5, y - graphHeight);
  line(x - 1.5, y + 1.5, x + graphWidth, y + 1.5);
  textSize(14);
  fill(255);
  textAlign(LEFT);
  text("DEMOGRAPHICS", x, y + 15);

  if (time % updateRate == 0) {
    demographics = new int[(sensorsMax-1) * 2];
    for (Creature c : creatures) {
      demographics[(c.sensors - 2) + (sensorsMax - 1) * (c.sensorType)]++;
    }
    demographicHistory.add(demographics);
  }
  if (frameRate < 16) {
    demographicHistory.remove(0);
  }
  float startR = x;
  noStroke();
  for (int[] demo : demographicHistory) {
    float prevS = 0;
    int cl = 0;
    for (int sens : demo) {
      float h = sens * (graphHeight / creatureAmount);
       if (cl == 0)
         fill(100, 180, 100, 255);
       else if (cl == 1)
         fill(180, 100, 100, 255);
       else if (cl == 2)
         fill(100, 100, 180, 255);
       else if (cl == 3)
         fill(180, 180, 100, 255);
       else if (cl == 4)
         fill(100, 180, 180, 255);
       else if (cl == 5)
         fill(0, 180, 0, 255);
       else if (cl == 6)
         fill(180, 0, 0, 255);
       else if (cl == 7)
         fill(0, 0, 180, 255);
       else if (cl == 8)
         fill(180, 180, 0, 255);
       else if (cl == 9)
         fill(0, 180, 180, 255);
      rect(startR, y - prevS, dIncrement, -h);
      cl++;
      prevS += h;
    }
    startR += dIncrement;
  }
  float prevS = 0;
  int cl = 0;
  for (int sens : demographics) {
    float h = sens * (graphHeight / creatureAmount);
    if (cl == 0)
      fill(100, 180, 100, 255);
    else if (cl == 1)
      fill(180, 100, 100, 255);
    else if (cl == 2)
      fill(100, 100, 180, 255);
    else if (cl == 3)
      fill(180, 180, 100, 255);
    else if (cl == 4)
      fill(100, 180, 180, 255);
    else if (cl == 5)
      fill(0, 180, 0, 255);
    else if (cl == 6)
      fill(180, 0, 0, 255);
    else if (cl == 7)
      fill(0, 0, 180, 255);
    else if (cl == 8)
      fill(180, 180, 0, 255);
    else if (cl == 9)
      fill(0, 180, 180, 255);
    textAlign(RIGHT);
    textSize(10);
    if (sens > 0)
      text("S" + cl, x + 20 + graphWidth, y - prevS);
    cl++;
    prevS += h;
  }

  if (startR > x + graphWidth)
    dIncrement = graphWidth / (demographicHistory.size());
}

int timePerDeath = 0;
int maxDeaths = 0;
float dhIncrement = width;
ArrayList<Integer> deathHistory = new ArrayList<Integer>();
void drawDeathGraph(float x, float y, float graphWidth, float graphHeight) {
  if (timePerDeath != 0) {
    deathHistory.add(timePerDeath);
    if (timePerDeath > maxDeaths)
      maxDeaths = timePerDeath;
    timePerDeath = 0;
  }
  stroke(0);
  strokeWeight(3);
  line(x - 1.5, y + 1.5, x - 1.5, y - graphHeight);
  line(x - 1.5, y + 1.5, x + graphWidth, y + 1.5);
  noStroke();
  fill(255);
  float startR = x;
  float shrinkAmount = 1f;
  if (maxDeaths * shrinkAmount > graphHeight) {
     shrinkAmount = (graphHeight) / (maxDeaths * shrinkAmount);
  }
  textAlign(LEFT);
  textSize(15);
  text("TIME PER DEATH", x, y + 15);
  textAlign(RIGHT);
  text(0, x - 10, y);
  text(nf(maxDeaths / 2.0, 0, 1), x - 10, y - maxDeaths * shrinkAmount / 2.0);
  text(nf(maxDeaths, 0, 1), x - 10, y - maxDeaths * shrinkAmount);

  for (int i = 0; i < deathHistory.size() - 1; i++) {
    rect(startR, y, dhIncrement, -deathHistory.get(i) * (shrinkAmount) - 1);
    startR += dhIncrement;
  }

  if (startR > x + graphWidth)
    dhIncrement = graphWidth / (deathHistory.size());
  if (frameRate < framRateMinimum)
    deathHistory.remove(0);
}

void populationStatistics(float x, float y) {
  textAlign(CENTER);
  fill(255);
  textSize(15);
  text("POPULATION STATISTICS", x, y);
  textAlign(LEFT);
  textSize(13);
  float maxFitness = 0;
  float maxEnergy = 0;
  float maxFEaten = 0;
  for (Creature c : creatures) {
   float[] creatureFits = new float[creatureAmount];
   int index = 0;
   for (Creature p : creatures) {
     if (p == c || !p.dead) {
       creatureFits[index] = p.fitness;
       index++;
     }
   }
   float[] creatureEnergies = new float[creatureAmount];
   int indexE = 0;
   for (Creature p : creatures) {
     if (p == c || !p.dead) {
       creatureEnergies[indexE] = p.maxEnergy;
       indexE++;
     }
   }
   float[] creatureFEeaten = new float[creatureAmount];
   int indexFE = 0;
   for (Creature p : creatures) {
     if (p == c || !p.dead) {
       creatureFEeaten[indexFE] = p.foodEaten;
       indexFE++;
     }
   }

   if (creatureFits.length > 0) {
     maxFitness = max(creatureFits);
     maxEnergy = max(creatureEnergies);
     maxFEaten = max(creatureFEeaten);
   }
   else {
     maxFitness = c.fitness;
     maxEnergy = c.maxEnergy;
     maxFEaten = c.foodEaten;
   }
  }
  text("# T-ALIVE FITNESS ENERGY C#  FG   MG  FOOD# F-RATIO S-RANGE SPEED G#", x - 110, y + 15);
  float bestT = 0, bestF = 0, bestE = 0, bestC = 0, bestET = 0, bestFR = 0;
  float[] fitRatios = new float[creatureAmount];
  int temp = 0;
  for (Creature c : creatures)  {
    if (c.timeAlive > bestT) bestT = c.timeAlive;
    if (c.fitness > bestF) bestF = c.fitness;
    if (c.energy > bestE) bestE = c.energy;
    if (c.children > bestC) bestC = c.children;
    if (c.foodEaten > bestET) bestET = c.foodEaten;
    float fitRatio = calcFitRatio(c, maxFitness, maxEnergy, maxFEaten);
    fitRatios[temp] = fitRatio;
    temp++;
    if (fitRatio > bestFR) bestFR = fitRatio;
  }
  for (int i = 0; i < creatures.length; i++) {
    float cy = y + 30 + 20 * i;
    textAlign(RIGHT);
    textSize(10);
    fill(0);
    text(i, x - 100, cy);
    Creature c = creatures[i];
    rectMode(CENTER);
    noStroke();
    fill(90, 44, 193, 150);
    if (c.timeAlive == bestT) {
      rect(x - 70, cy - 5, 50, 10);
    }
    fill(0, 0, 255, 50);
    if (c.fitness == bestF) {
      rect(x - 10, cy - 5, 50, 10);
    }
    fill(0, 255, 0, 150);
    if (c.energy == bestE) {
      rect(x + 40, cy - 5, 50, 10);
    }
    fill(255, 0, 0, 50);
    if (c.children == bestC) {
      rect(x + 70, cy - 5, 20, 10);
    }
    fill(255, 50, 150, 200);
    if (c.foodEaten == bestET) {
      rect(x + 160, cy - 5, 20, 10);
    }
    fill(255, 255, 150, 200);
    if (fitRatios[i] == bestFR) {
      rect(x + 220, cy - 5, 50, 10);
    }
    textAlign(CENTER);
    fill(0);
    text(nf(c.timeAlive, 0, 1), x - 70, cy);
    text(nf(c.fitness, 0, 1), x - 10, cy);
    text(nf(c.energy, 0, 1), x + 40, cy);
    text(c.children, x + 70, cy);
    text(c.father, x + 90, cy);
    text(c.fatherg, x + 100, cy);
    text(c.mother, x + 120, cy);
    text(c.motherg, x + 130, cy);
    text(c.foodEaten, x + 160, cy);
    text(fitRatios[i], x + 220, cy);
    text(c.sensors, x + 260, cy);
    text(nf(c.sensorRange, 0, 1), x + 290, cy);
    text(nf(c.speed, 0, 1), x + 330, cy);
    text(c.generation, x + 360, cy);
  }
}

void foodExpectancy() {
 for (int i = 0; i < foodAmount; i++) {
   foodLife[i]++;
   if (foodLife[i] > foodLifeSpans) {
     Food f = foods[i];
     foodLife[i] = 0;
     f.x = random(mapWidth / 10.0, mapWidth * 9.0 / 10.0);
     f.y = random(mapHeight / 10.0, mapHeight * 9.0 / 10.0);
     f.amount = random(minFoodSize, maxFoodSize);
   }
 }
}

float calcFitRatio(Creature c1, float _maxFitness, float _maxEnergy, float _maxFEaten) {
  return c1.fitness / _maxFitness * 0.4 + c1.maxEnergy / _maxEnergy * 0.3 + c1.foodEaten / _maxFEaten * 0.3;
}

float simScale = 1;
boolean creatureDied = false;
int prevDeathtime = 0;
void draw() {
  background(200, 200, 10);
  fill(0);
  textSize(20);
  textAlign(LEFT);
  text("SIMULATION TIME: " + time, 975, 25);
  if (true) {
    drawAreas();
    printPopulationStats();
    drawDemographics(650, 725);
    drawAverageFitnessGraph(350, 725, 250, 100);
    demographicGraph(800, 725, 400, 75, 1, time);
    drawDeathGraph(60, 725, 230, 100);
    populationStatistics(875, 25);
    //drawDeltaAverageFitnessGraph(800, 725, time);
    foodExpectancy();
    if (mutationRate > 0.01f)
      mutationRate /= 1.0001f;
    if (minFoodSize > finalMinFoodSize)
      minFoodSize /= 1.0001f;
    if (maxFoodSize > finalMaxFoodSize)
      maxFoodSize /= 1.0001f;
    for (int i = 0; i < creatures.length; i++) {
     Creature c = creatures[i];
     //if (c.age > maxAge)
     //  c.dead = true;
     //else
       c.age++;
     Food f = new Food();
     if (c.sensorType == 0)
       f = c.calcSensoryInput(foods, minFoodSize, maxFoodSize, simScale);
     else
       f = c.calcSensoryInput2(foods, minFoodSize, maxFoodSize);
     if (f != null && c.distanceMoved > livingDistance) {
       c.energy += f.amount / 2.0;
       c.fitness += f.amount * 2.0;
       c.foodEaten++;
       for (int j = 0; j < foodAmount; j++) {
         if (foods[j] == f) {
           foodLife[j] = 0;
           f.x = random(mapWidth / 10.0, mapWidth * 9.0 / 10.0);
           f.y = random(mapHeight / 10.0, mapHeight * 9.0 / 10.0);
           f.amount = random(minFoodSize, maxFoodSize);
         }
       }
       f.x = random(mapWidth / 10.0, mapWidth * 9.0 / 10.0);
       f.y = random(mapHeight / 10.0, mapHeight * 9.0 / 10.0);
       f.amount = random(minFoodSize, maxFoodSize);
     }
     if (!keyPressed)
       c.update(simScale);
     float maxFit = 0;
     for (Creature temp : creatures)
       if (temp.fitness > maxFit) maxFit = temp.fitness;

     // genetic algorithm
     if (c.dead) {
       creatureDied = true;
       int livingCreatures = 0;
       for (Creature p : creatures) {
         if (p == c || !p.dead) {
           livingCreatures ++;
         }
       }
       Creature[] availableMates = new Creature[livingCreatures];
       float[] creatureFits = new float[livingCreatures];
       int index = 0;
       for (Creature p : creatures) {
         if (p == c || !p.dead) {
           availableMates[index] = p;
           creatureFits[index] = p.fitness;
           index++;
         }
       }
       float[] creatureEnergies = new float[livingCreatures];
       int indexE = 0;
       for (Creature p : creatures) {
         if (p == c || !p.dead) {
           creatureEnergies[indexE] = p.maxEnergy;
           indexE++;
         }
       }
       float[] creatureFEeaten = new float[livingCreatures];
       int indexFE = 0;
       for (Creature p : creatures) {
         if (p == c || !p.dead) {
           creatureFEeaten[indexFE] = p.foodEaten;
           indexFE++;
         }
       }

       ArrayList<Creature> matingPool = new ArrayList<Creature>();
       float maxFitness;
       float maxEnergy;
       float maxFEaten;
       if (creatureFits.length > 0) {
         maxFitness = max(creatureFits);
         maxEnergy = max(creatureEnergies);
         maxFEaten = max(creatureFEeaten);
       }
       else {
         maxFitness = c.fitness;
         maxEnergy = c.maxEnergy;
         maxFEaten = c.foodEaten;
       }
       
       for (Creature c1 : creatures) {
         //float fitRatio = c1.fitness / maxFitness * 0.6 + c1.maxEnergy / maxEnergy * 0.2 + c1.foodEaten / maxFEaten * 0.2;
         float fitRatio = calcFitRatio(c1, maxFitness, maxEnergy, maxFEaten);
         for(int j = 0; j < fitRatio * 100; j++) {
           matingPool.add(c1);
         }
       }
       Creature father = matingPool.get(int(random(0, matingPool.size() - 1)));
       //while(father.sensors == c.sensors)
         //father = matingPool.get(int(random(0, matingPool.size() - 1)));
       Creature mother = findViableMate(matingPool, father);
       // if after 1000 tries no viable mate can be found, the creature will mate with itself
       if (mother == null)
         mother = father;
       Dna childDna = father.dna.crossover(father.dna, mother.dna, mutationRate);
       father.children++;
       mother.children++;
       Creature child = new Creature(childDna, i, birthEnergy, birthHealth, random(0.0, mapWidth), random(0.0, mapHeight),
                                     random(0.0, 360.0), creatureSize);
       if (father.generation > mother.generation)
         child.generation = father.generation+1;
       else
         child.generation = mother.generation+1;
       child.father = father.name;
       child.mother = mother.name;
       child.fatherg = father.generation;
       child.motherg = mother.generation;
       creatures[i] = child;

     }

     if (mouseX < c.x + c.size / 2.0 && mouseX > c.x - c.size / 2.0)
       if (mouseY < c.y + c.size / 2.0 && mouseY > c.y - c.size / 2.0)
         c.showSensorRange();

     // constrain creatures to map
     if (c.x < mapWidth / 13.0) c.x = mapWidth / 13.0;
     if (c.x > mapWidth * 12.0 / 13.0) c.x = mapWidth * 12.0 / 13.0;
     if (c.y < mapHeight / 13.0) c.y = mapHeight / 13.0;
     if (c.y > mapHeight * 12.0 / 13.0) c.y = mapHeight * 12.0 / 13.0;
     c.show(simScale);

     // creature number
     textAlign(CENTER);
     textSize(15);
     fill(255);
     text(i, c.x, c.y + 15 / 2.0);
     c.timeAlive++;
    }

    for (Food f : foods) {
     f.show(simScale);
    }
    time++;
  }
  if (creatureDied) {
    creatureDied = false;
    timePerDeath = time - prevDeathtime;
    prevDeathtime = time;
  }
}
