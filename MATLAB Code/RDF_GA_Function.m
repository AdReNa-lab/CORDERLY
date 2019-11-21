function [X, Y] = RDF_GA_Function(Data, Rlim, NumBins)

%Creates subset of data
Xmin = min(Data(:,1));
Xmax = max(Data(:,1));
Ymin = min(Data(:,2));
Ymax = max(Data(:,2));

Xl = Xmin + Rlim;
Xh = Xmax - Rlim;
Yl = Ymin + Rlim;
Yh = Ymax - Rlim;

t1 = Data(:,1) >= Xl;
t2 = Data(:,1) <= Xh;
t3 = Data(:,2) >= Yl;
t4 = Data(:,2) <= Yh;

t5 = logical(t1.*t2.*t3.*t4);

X = Data(:,1);
Y = Data(:,2);
Xsub = X(t5);
Ysub = Y(t5);

Data_sub = [Xsub, Ysub];

%Determines number of data points
n = size(Data,1);
n_sub = size(Data_sub,1);

D = [];

for i = 1:n_sub-1
    %Selects a point from the data
    Pt = Data_sub(i,:);
    %Creates matrix of all other points
    Mat = Data;
    xtest = find(Mat(:,1) == Pt(1));
    if length(xtest) == 1
        Mat(xtest,:) = [];
    else
        ytest = find(Mat(:,2) == Pt(2));
        [idx] = intersect(xtest,ytest);
        Mat(idx, :) = [];
    end
        
    %These matrices are set up such that no pair of points is duplicated 
          
    %Calculates the distances between each pair of points
    X_temp = Pt(:,1) - Mat(:,1);
    Y_temp = Pt(:,2) - Mat(:,2);
    D_temp = (X_temp.^2 + Y_temp.^2).^(1/2); 
    
    %The distance is saved for further processing 
    D = [D; D_temp]; %#ok<AGROW>
    
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
p = n/((Xmax-Xmin)*(Ymax-Ymin));
%Calculates the number of particles per each dr for an ideal gas
Nid = p*pi*(R.^2-L.^2);

%Calculates the centre of each bin
X = (L+R)./2;

%Normalises the g(R)
Y = V./Nid;
Y = Y/(n_sub-1);
end

