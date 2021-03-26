# the-witness
**Spoiler alert!!** This is a repository of Answer Set Programs designed to solve puzzles from "The Witness". It contains puzzle solutions!

Currently the only answer set that exists here solves puzzles of the "colour square" type. These puzzles consist of a grid of squares, some of which are filled with a colour: to solve a colour square puzzle, the player has to draw a line from the entrypoint (usually vertex (0,0)) to the ending point (usually the highest vertex on the grid); this line must separate differently-coloured squares into separate regions of the grid.

![colour squares puzzle](https://guides.gamepressure.com/thewitness/gfx/word/33068296.jpg)

## Running the program

You'll need a system which has Potassco's Clingo installed: https://github.com/potassco/clingo

Once you've achieved that, you can clone this repository and then run the program as follows;

`clingo colour_squares.lp colour_squares_input_1.lp -n 0`

## TODO
 - handle squares which have no colour at all (and thus do not need to be separated from the others)
