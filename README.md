# sindemia
Short game as final proyect for CS50 fall 2020



Sindemia is a small game developed by victorjvalbuena as a final project of the CS50 course during the global coronavirus pandemic in the fall of 2020.

The story of the game is set in a city that has reached a contagious virus.

People become infected by not maintaining physical distancing.

The player controls a character that moves through the city looking for three people who are collaborating with the development of a vaccine.

The player has a compass that tells him where her or his (you can choose between a female or a male character) destination is.

Along the way, the player may meet infected but asymptomatic characters or infected characters who sneeze; if the player collides with infected characters or with the sneeze virus, the player becomes infected and the level restarts.

The city map is a 8 squares x 16 tiles x 32 pixels tile map developed with Tiled.

The map is made up of several parts:

- Three layers of tiles from the world, which form the edge of the city;
- 4 groups of neighborhoods layers, which are loaded randomly (top / bottom and left / right) inside the world layers.
- Several layers of roads that randomly connect the edges with the neighborhoods.

The different combinations of the neighborhoods form different labyrinths.

NPCs move around the city map. If an infected character collides with another that is not infected, it becomes infected and the contagion rate increases.

If the contagion rate exceeds 90% of the population, the game is over.

If the player manages to contact his target character, she or he goes to the next level.

If the player complete all three levels, the player wins the game.

The code is available at https://github.com/0vjv0/sindemia

The game can be downloaded at 


