function [X, Y] = RDF_PCBs_Function(Data, Rlim, NumBins)

Xlim = max(Data(:,1));
Ylim = max(Data(:,2));

%Determines number of data points
n = size(Data,1);

%Calculates total number of possible pairs of particles and pre-sets size
%of variable D
N = n*(n-1)/2;
D = zeros(N,1);

l1 = 1;
l2 = 0;

for i = 1:n-1
    %Selects a point from the data
    Pt = Data(i,:);
    %Creates matrix of all other points
    Mat = Data(i+1:n,:);
    %These matrices are set up such that no pair of points is duplicated 
    
    %The following lines of code apply a periodic boundary condition
    X_temp = Pt(:,1) - Mat(:,1);
    Y_temp = Pt(:,2) - Mat(:,2);
    
    X1 = X_temp > Xlim/2;
    X_temp(X1) = X_temp(X1) - Xlim;
    X2 = X_temp < -Xlim/2;
    X_temp(X2) = X_temp(X2) + Xlim;
    
    Y1 = Y_temp > Ylim/2;
    Y_temp(Y1) = Y_temp(Y1) - Ylim;
    Y2 = Y_temp < -Ylim/2;
    Y_temp(Y2) = Y_temp(Y2) + Ylim;
    
    %Calculates the distances between each pair of points
    D_temp = (X_temp.^2 + Y_temp.^2).^(1/2); 
    
    j = n - i;
    l2 = l2 + j;
    
    %The distance is saved for further processing 
    D(l1:l2,1) = D_temp;
    
    l1 = l1+j;    

end

%Only distances within the radial limit are retained
Z = D <= Rlim;
D = D(Z);

%This sets up a vector of the edges for binning the data
edges = linspace(0, Rlim, NumBins+1);
%The data is binned into the bins defined above
[V,edges] = histcounts(D, edges);
%Creates a vector of the left (L) and the right (R) edge of each bin 
L = edges(1:NumBins);
R = edges(2:NumBins+1);
%Determines the average density of particles
p = n/(Xlim*Ylim);
%Calculates the number of particles per each dr for an ideal gas
Nid = p*pi*(R.^2-L.^2);

%Calculates the centre of each bin
X = (L+R)./2;

%Normalises the g(R)
Y = V./Nid;
Y = 2*Y/(n-1);
end

