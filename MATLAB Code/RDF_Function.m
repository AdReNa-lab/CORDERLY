function [X, Y] = RDF_Function(Data, Rlim, NumBins)

%Determines radial limit over which the 1D-RDF can be calculated
%lim = min([Xlim, Ylim]);

Xmax = max(Data(:,1));
Ymax = max(Data(:,2));
Xmin = min(Data(:,1));
Ymin = min(Data(:,2));
rect = polyshape([Xmin, Xmin, Xmax, Xmax], [Ymax, Ymin, Ymin, Ymax]);

%Determines number of data points
n = size(Data,1);

%Calculates total number of possible pairs of particles and pre-sets size
%of variable D
N = n*(n-1)/2;
D = zeros(N,1);

l1 = 1;
l2 = 0;

%This sets up a vector of the edges for binning the data
edges = linspace(0, Rlim, NumBins+1);
%Creates a vector of the left (L) and the right (R) edge of each bin 
L = edges(1:NumBins);
R = edges(2:NumBins+1);

%Spacing = Rlim/NumBins;
edges_track = zeros(length(edges)-1,1);

for i = 1:n-1
    %Selects a point from the data
    Pt = Data(i,:);
    %Creates matrix of all other points
    Mat = Data(i+1:n,:);
    %These matrices are set up such that no pair of points is duplicated 
         
    %Calculates the distances between each pair of points
    X_temp = Mat(:,1)- Pt(:,1);
    Y_temp = Mat(:,2)- Pt(:,2);
    D_temp = (X_temp.^2 + Y_temp.^2).^(1/2); 
    
    Xl = abs(Xmin - Pt(1));
    Xh = abs(Xmax - Pt(1));
    Yl = abs(Ymin - Pt(2));
    Yh = abs(Ymax - Pt(2));
            
    j = n - i;
    l2 = l2 + j;
    
    %The distance is saved for further processing 
    D(l1:l2,1) = D_temp;
    
    l1 = l1+j;    
    
    parfor k = 1:length(edges)-1
        
        lims = [Xl, Xh, Yl, Yh];
        
        eout = R(k);
        test = lims <= eout
        
        if sum(test) == 0
            A_out = pi*eout^2;
            
        else
            cout = nsidedpoly(1000,'Center',Pt, 'Radius',eout);
            Int_out = intersect(rect,cout);
            Vout = Int_out.Vertices;
            A_out = polyarea(Vout(:,1), Vout(:,2));
            
        end
        
        ein = L(k);
        test = lims <= ein
        
        if sum(test) ==0
            A_in = pi*ein^2;
            
        else
            
            if ein == 0
                A_in = 0;
            else
                cin = nsidedpoly(1000,'Center',Pt, 'Radius',ein);
                Int_in = intersect(rect, cin);
                Vin = Int_in.Vertices;
                A_in = polyarea(Vin(:,1), Vin(:,2));
            end
            
        end
        
        Area = A_out - A_in;
        
        edges_track(k) = edges_track(k) + Area;
        
    end

end

%Only distances within the radial limit are retained
Z = D <= Rlim;
D = D(Z);

%Remove zeros

%The data is binned into the bins defined above
[V,~] = histcounts(D, edges);
%Determines the average density of particles
p = n/((Xmax-Xmin)*(Ymax-Ymin));
%Calculates the number of particles per each dr for an ideal gas
Nid = p*edges_track;

%Calculates the centre of each bin
X = (L+R)./2;

%Normalises the g(R)
Y = V./Nid';
Y = 2*Y;
end

