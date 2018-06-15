# Disclaimer
This code is super messy and i'm more focused on other projects right now. I might clean it up at some point, but right
now I highly recommend NOT looking at the code it is horrid.

# Neuroevolution
Simple evolution of "bugs" trying to find food in the most efficient way. Made with Java and Processing.
This project is inspired by the youtuber carykh and his projects on neuroevolution. 
Find him here: https://www.youtube.com/channel/UC9z7EZAbkphEMg0SP7rw44A.

# How it works
- Each "bug" is a neural network with a random dna at first.
- Dna contains the weights, sensor type, sensor range and speed.

# Sensors
- There are two types of sensors, blue and red.
- A red sensor's data is the distance from the sensor's position to the nearest food piece.
- A blue sensor's data is the distance from the sensor's position to the nearest food piece,
but only in a specific direction. Meaning if a bug has 2 sensors, one sensors will only look left,
while the other sensor only looks right.
- Sensor range is how far away the sensor can look (hover over creature to see this more clearly).

# Weights
- Simply the weights for the creature's neural network.

# Speed
- How fast the creature moves, the faster it moves the more "energy" it consumes.

# Simulation
- An amount of bugs are generated with random dna.
- Food sources are the pink circles.
- The larger a food source is the easier it is for the bugs to "see" it.
- Each bug has calories (green, blue, or white) and health (red).
- The faster a bug moves the faster he uses his calories.
- If calories are 0 then health starts to go down.
- If health is 0 the bug dies and a new one is born using crossover between other bugs and mutations.
- The more children a bug has, foods it ate, and the longer it was alive, the higher its fitness.

