Evolutionary Platformer
developed by Samuel Lehmann for the University of Alberta's ENCMP 100 Programming Competition in 2016 (undergraduate-first year)

SOURCE CODE AT: https://github.com/slehmann1/Evolutionary-Platformer

COPYRIGHT INFO: Feel free to copy, plagiarize, steal, and do what you wish with this project. Crediting me would be nice, but I will survive
if you don't.

ABOUT
This is a platformer simulation that solves itself using a genetic algorithm. This algorithm is not the most efficient way to solve a platformer,
nor does it pretend to be. It takes an iterative process, generating generations of characters that each run the platformer, based on their
"genetic code". The characters are then evaluated by a fitness function, and are then bred with each other, with the fittest characters being
most likely to breed. Mutations are then introduced to the characters. In this way, the characters improve gradually, becoming more and more fit 
after each generation. The "genetic code" of the characters consists of actions, run at specified times, with specified speeds. The first action
of each character is the move action, which specified to make the character run to the right. All other actions are jump actions. When running
the program, the trajectories of the characters are shown in the top left graph, with further information displayed in the other graphs.

HOW TO RUN

A compiled version should be included, which can be run, and will have slight performance advantages. Alternatively, if running the code inside 
of matlab, platformEvolution.m is the main file, with platformEvolution() as the entry point. This program has been tested back to Matlab R2015a,
and may or may not be backwards compatible beyond that point.

When running the program, the first window that will show up will have a textbox to input a NUMERIC SEED value, which controls the results of
running the program, the same seed value will result in the same results, different seed values will result in different results. A default
seed value is provided inside the textbox.  After selecting a seed value, one can choose to change further advanced settings, or to use default 
values (recommended initially). Changing advanced settings will change output, even if the seed is the same. If one chooses to change advanced 
settings, a number of options will appear. Pressing the cancel button will terminate the program. Invalid values will cause errors.

LEVEL OPTIONS:
Level length : the length of the level in m
Minimum/Maximum stair height: the minimum/maximum difference in heights between two sequential stairs, adjusting this value will change the number
of stairs, due to the way that stairs are generated
Minimum stair spacing width: The minimum width of the stairs, some stairs will be an integer multiple of this value in width, the larger the width,
the fewer the maximum number of stairs.


CHARACTER OPTIONS:
Start speed: in m/s
Air resistance: the character will move this many times slower horizontally when airborne
Gravity: in m/s^2
Time interval: A characters position will be evaluated after this many seconds. A smaller value will increase accuracy, but will reduce performance.
Too large of a value will cause level clipping.
Maximum Jump Height:
The maximum height that the character can jump

EVOLUTION OPTIONS:
Generation size: The number of characters to be calculated per iteration, the size of the gene pool. MUST BE A POSITIVE INTEGER
Number of clones: The fittest number of clones will be copied from one generation to the next, without mutation or breeding. This reduces the relation
to real life evolution, but it increases the effectiveness of the algorithm to have one or two clones. MUST BE A POSITIVE INTEGER OR ZERO
Mutation rate: a decimal proportion of the number of characters to be mutated per iteration on average, MUST BE BETWEEN ZERO AND ONE (INCLUSIVE)
Add action rate: a decimal proportion of the number of mutations to add an action per mutation on average, MUST BE BETWEEN ZERO AND ONE (INCLUSIVE)
Remove action rate: a decimal proportion of the number of mutations to remove an action per mutation on average, MUST BE BETWEEN ZERO AND ONE
(INCLUSIVE)
NOTE: Add action rate and Remove action rate should not sum to greater than 1, 1-(Add action rate+ Remove action rate) is the Change action rate,
the proportion of actions that are modified per mutation. This modification consists of changing either the time or the speed of the action.

FITNESS OPTIONS:
Fitness is determined by the formula: (maximumDistance*distanceWeight+ (timeAlive)*timeWeight)-EnergyUsed*energyWeight)^differentiationFactor
Strange behaviour will occur if these values are non-positive
Differentiation factor impacts breeding of characters. A low differentiation factor will mean that less fit characters will have a greater chance of 
breeding, increasing genetic diversity, but potentially decreasing fitness if the value is too low. Too high of a value will mean that the most fit
character will only breed with itself. Differentiation factor does not impact the values shown on the fitness vs generation graph, what is displayed 
is the undifferentiated fitness.
