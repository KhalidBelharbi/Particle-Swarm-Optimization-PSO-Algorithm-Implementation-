function matriceDistances =getMatriceDistances(path)
idF=fopen(path);
first=fscanf(idF,'%f',[1 1])
ns=first(1,1);
lecteur=fscanf(idF,'%f',[2,ns]);
coordonne=lecteur'
global coordonner;
coordonner = coordonne;
mat=zeros(ns);
for i=1:ns   
    for j=1:ns        
       mat(i,j)=sqrt(((coordonne(i,1)-coordonne(j,1))^2)+((coordonne(i,2)-coordonne(j,2))^2));       
    end   
end
fclose(idF);
matriceDistances=mat;
end
