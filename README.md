# Lightsout

Lightsout is simple game that consists of n by n grid. Each cell in the game is either on or off. The cells of this game has a peculiar behaviour i.e., when a cell/button is pressed all its adjacent(not diagonally) cells toggles their state. The cells which are on will become off and vice versa.

## Demo

![demo image](https://github.com/shwejanraj/Lightsout/blob/main/readme/demo.png)

## Goal

The goal of this game is to turn off all the lights in the game.

![goal image](https://github.com/shwejanraj/Lightsout/blob/main/readme/goal.png)

## Implementation

- The given problem can be mathematically modelled and solved by using linear algebra.

- The idea is to represent n by n grid as n by n matrix with 0s and 1s. 0 represents off and 1 represents on.

- Now we need to model the pressing of buttons.

  ![button image](https://github.com/shwejanraj/Lightsout/blob/main/readme/button.png)

- Now we can see that a button press can be modelled as adding a toggle matrix to the current state of the game matrix and taking it modulo 2.

- Now what is toggle matrix??

- Toggle matrix is just a matrix with 0s and 1s. But the placement of 1s are special here. This toggle matrix contains 1 where the effect of button press is felt.

- For example.

- For this button press at (1,1).

  ![button image](https://github.com/shwejanraj/Lightsout/blob/main/readme/button_press_1.png)
  The toggle matrix is on right.

- And for this button(1,2).

  ![button image](https://github.com/shwejanraj/Lightsout/blob/main/readme/button_press_2.png)
  The toggle matrix is on right.

- Now that we have modelled everything we need.We can model clicking a sequence of buttons as adding a set of toggle matrices so that.

      G + T(i1, j1)+T(i2, j3)+. . . . .+T(ik, jk) = 0 (modulo 2)

- Here G is inital configuration of the game. T(i,j) is the toggle matrix.

- We can extend this idea is to assign a coefficient a(i, j) for each toggle matrix T(i, j).

- The coefficient is either 0 or 1. 0 means that button is not clicked and if the coefficient is 1 then the button is clicked.

- So now we have to find those coefficients so that the from the toggle matrix we get the buttons we have to click in order to solve the game.

- The above slide can be summarized into mathematical formula.

  <img src="https://latex.codecogs.com/svg.image?\bg{black}G&space;&plus;&space;\sum_{i,j}a(i,j)*T(i,j)&space;=&space;0(modulo&space;2)" title="https://latex.codecogs.com/svg.image?\bg{black}G + \sum_{i,j}a(i,j)*T(i,j) = 0(modulo 2)" />

- If we assume that everything here is drawn from GF(2), then we can drop the modulo 2

  <img src="https://latex.codecogs.com/svg.image?\bg{black}G&space;&plus;&space;\sum_{i,j}a(i,j)*T(i,j)&space;=&space;0" title="https://latex.codecogs.com/svg.image?\bg{black}G + \sum_{i,j}a(i,j)*T(i,j) = 0" />

- we can add -G on both sides of the equation to get.

  <img src="https://latex.codecogs.com/svg.image?\bg{black}\sum_{i,j}a(i,j)*T(i,j)&space;=&space;-G" title="https://latex.codecogs.com/svg.image?\bg{black}\sum_{i,j}a(i,j)*T(i,j) = -G" />

- In GF(2) -x can be replaced by x.

  <img src="https://latex.codecogs.com/svg.image?\bg{black}\sum_{i,j}a(i,j)*T(i,j)&space;=&space;G" title="https://latex.codecogs.com/svg.image?\bg{black}\sum_{i,j}a(i,j)*T(i,j) = G" />

- Right now, G and T(i, j) are matrices. we can convert them into column vectors in row-major order.

  ![matrix to column vector image](https://github.com/shwejanraj/Lightsout/blob/main/readme/row_major_order.png)

- Let's define the matrix V to be the matrix whose columns are the T(i, j) .

- Let a be the column vector whose elements are a(i,j) in that same order.

  therefore the formula can be rewritten as

            V a = G

- Now the goal is clear we need to solve this system of linear equations, each of whose values are drawn from GF(2). And 'a' contains the solution.

- Now we can employ any technique to solve this.

- We can invert the V and multiply the it with G. This will give us the solution but we can't solve the system if the matrix V is non invertable.

- Else we can use Gauss-elimination to convert the V into identity matrix so that the G contains the solution.

## Results

- For 3 by 3 grid.

  ![3by3 result](https://github.com/shwejanraj/Lightsout/blob/main/readme/3by3.gif)

- For 5 by 5 grid.

  ![3by3 result](https://github.com/shwejanraj/Lightsout/blob/main/readme/3by3.gif)

- For 7 by 7 grid.

  ![3by3 result](https://github.com/shwejanraj/Lightsout/blob/main/readme/3by3.gif)

## Code

The folder "Lightsout" contains all the necessary code files.

In that folder run file named run_this.m this takes the matrix as input. And prints the solution in matrix form which tells us which buttons to be pressed.

## Some facts.

1. Not all states have a solution except for 3 by 3.
2. If solution exists this code gives a solution that contains at most n^2 button presses.
