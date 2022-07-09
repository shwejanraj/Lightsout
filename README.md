# Lightsout

Lightsout is simple game that consists of n by n grid. Each cell in the game is either on or off. The cells of this game has a peculiar behaviour i.e., when a cell/button is pressed all its adjacent(not diagonally) cells toggles their state. The cells which are on will become off and vice versa.

## Demo

### put a gif showing the cells changing their state by pressing.

## Goal

The goal of this game is to turn off all the lights in the game.

## Implementation

The given problem can be mathematically modelled and solved by using linear algebra.

The idea is to represent n by n grid as n by n matrix with 0s and 1s. 0 represents off and 1 represents on.

Now we need to model the pressing of buttons.

![button image](https://github.com/shwejanraj/Lightsout/blob/main/readme/button.png)
