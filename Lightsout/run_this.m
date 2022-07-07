
clc
clear all
inp = input('Enter game state : \n');
[row, col] = size(inp);
res = reshape(inp',row*row,1);
printSolution(row,res);

