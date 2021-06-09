function [solution,cout,populationSolution] = Pso_Algorithme(matCout,nbrAgents,w,alpha1,beta1,alpha2,beta2,vitesseMax,iterationMax)
global matDistance;
matDistance=matCout;
global ns;
ns=size(matDistance,1);
MeilleursSolution=[];
for i = 1 : nbrAgents    
    Xi=randperm(ns);
    Xi=[Xi,Xi(1,1)];%Hamiltonien Cycle    
    Vi= -vitesseMax + (vitesseMax * 2)*rand(1,1)  ; % [a,b]----> a+(b-a) * rand    
    Pbesti= Xi;
    Gbest=getGbest(Xi);    
    nbrIterations=iterationMax;
    while(nbrIterations>0)   
		Vi=  w * Vi +  alpha1 * beta1 *(Pbesti-Xi) + alpha2 * beta2 * (Gbest-Xi);   
   partieEntier = floor(Vi);
   Vi = mod(partieEntier,vitesseMax)+(vitesseMax- partieEntier);   
   Xi=Xi+Vi;   
   Xi = CorrectionPosition(Xi);   
   Gbest=getGbest(Xi);   
      if(getVecteurLongeur(Pbesti) >  getVecteurLongeur(Xi) )          
          Pbesti=Xi;          
      end      
      if(getVecteurLongeur( Gbest) >  getVecteurLongeur(Pbesti) )          
          Gbest = Pbesti;          
      end                  
      MeilleursSolution=[ MeilleursSolution ; Gbest] ;      
      nbrIterations=nbrIterations-1;       
    end   
end
[Meilleur,cout]=selectionMeilleurSolution( MeilleursSolution);
solution=Meilleur;
populationSolution=MeilleursSolution;
end
function position = CorrectionPosition(X)
                global ns;               
                sol=zeros(1,size(X,2));
                X=abs(X);
                elem=mod(round(X(1,1)),ns);
                if(elem == 0)
                    sol(1,1)=1;
                    sol(1,end)=1;
                else
                     sol(1,1)=elem;
                     sol(1,end)=elem;    
                end
                villes=1:ns;
                villes = deleteElem(villes,sol(1,1)) ;
                for j=2:ns    
                    valeur=round(X(1,j));  
                    [vall,y]= getPlusProche(valeur,villes);
                    sol(1,j)=villes(1,y);                     
                    if(sol(1,j)>38)
                        sol(1,j)
                    end                    
                    villes(y)=[];  
                end
                position=sol;
end
function newVilles = deleteElem(vectVilles,elem)
for i=1:size(vectVilles,2)    
    if(vectVilles(1,i)==elem)
       vectVilles(i)=[];
        break;
    end    
end
newVilles=vectVilles;
end
function [valeurPlusProche,indice] = getPlusProche(v,vect)
diff=abs(vect-v);
[val,indice]=min(diff);
valeurPlusProche =val;
end
function ggBest=getGbest(Xi)  % donner moi la meilleurs parmi les pbest de mon voisinage
global ns;
Voisinage=[];
for i=1:40        
    indice1=randi([2,ns],1,1);    
    indice2=randi([2,ns],1,1);
     pos =  Xi;
     tmp=pos(indice1);
     pos(indice1)=pos( indice2);
     pos( indice2)=tmp;     
     Voisinage=[Voisinage;pos];
end
[Meilleur,cout] = selectionMeilleurSolution(Voisinage);
ggBest=Meilleur;
end
function [Meilleur,cout]=selectionMeilleurSolution(population)
vectDistt=getVecteurLongeur(population)';  
 [vv,ind]=min(vectDistt);
Meilleur = population(ind,:);
cout=vv;
end




   


function vectDistancesGlobales=getVecteurLongeur(matResultatt) % return vecteur colonne des distances

global matDistance;

vecttt=[];

for elem=matResultatt'
    dist=0;
    
    for i=1:size(elem,1)-1
        
       
        
        dist = dist+matDistance(elem(i,1),elem(i+1,1));
        
    end
    vecttt=[vecttt;dist];
    
end
vectDistancesGlobales=vecttt;


end