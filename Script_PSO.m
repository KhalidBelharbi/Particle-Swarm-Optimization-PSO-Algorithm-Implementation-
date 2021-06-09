clear all;
close all;
path='ddj38.tspMATLAB.txt';
[solution,cout,populationSolution] = Pso_Algorithme_PATH(path,100,1,0.5,1,0.5,1,10,20);
solution
cout
