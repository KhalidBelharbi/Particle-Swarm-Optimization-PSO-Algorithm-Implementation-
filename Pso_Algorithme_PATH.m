function [solution,cout,populationSolution] = Pso_Algorithme_PATH(path,nbrAgents,w,alpha1,beta1,alpha2,beta2,vitesseMax,iterationMax)
[solution,cout,populationSolution] = Pso_Algorithme(getMatriceDistances(path),nbrAgents,w,alpha1,beta1,alpha2,beta2,vitesseMax,iterationMax);
end

