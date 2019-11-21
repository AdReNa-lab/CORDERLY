function [Xm, Ym, Hm] = SDF_Function(Data, Xmax, Ymax, Spacing)

%Read in positional information
Xd = Data(:,1);
Yd = Data(:,2);

%Sets up the edges for the 2D bins
Xs1 = 0.5*Spacing:Spacing:Xmax;
Xs2 = -0.5*Spacing:-Spacing:-Xmax;
Xs = [fliplr(Xs2), Xs1];

Ys1 = 0.5*Spacing:Spacing:Ymax;
Ys2 = -0.5*Spacing:-Spacing:-Ymax;
Ys = [fliplr(Ys2), Ys1];

%Pre-sets size of matrix of particle density (2D-histogram)
H = zeros(length(Ys)-1, length(Xs)-1);

%Determines the dimensions of the sample 
x_dim = abs(max(Xd)-min(Xd));
y_dim = abs(max(Yd)-min(Yd));

%Sets the lower left position of the rectangular sample area
ref_pos = [min(Xd), min(Yd)];

%Presets size of matrix for normalisation
norm_mat = zeros(length(Ys)-1, length(Xs)-1);

%Calculate the average density overall
avg_density_overall = length(Xd)/(x_dim*y_dim);

%Calculates the average density expected in a given bin
avg_density = avg_density_overall * Spacing^2;

%Pre-sets the Xa, Ya vectors for speed
Xa = zeros(length(Xd)^2,1);
Ya = zeros(length(Xd)^2,1);

%Create array for every particle in relation to every other particle
for i = 1:length(Xd)
    
    %Chooses the ith particle as the reference particle
    Xc = Xd(i);
    Yc = Yd(i);
    
    %Shifts the array such that the reference particle lies at the 0,0
    %point
    X_temp = Xd-Xc;
    Y_temp = Yd-Yc;
    
    %Adds the above array to the Xa, Ya vectors
    Xa((i-1)*length(Xd)+1:i*length(Xd),1) = X_temp;
    Ya((i-1)*length(Yd)+1:i*length(Yd),1) = Y_temp;
    
    %Shifts the rectangle (the sample area)
    ref_pos_temp = [0, 0];
    ref_pos_temp(1) = ref_pos(1) - Xc;
    ref_pos_temp(2) = ref_pos(2) - Yc;
    
    %determines the limits of the shifted rectangle
    rect_x_min = ref_pos_temp(1);
    rect_x_max = ref_pos_temp(1) + x_dim;
    rect_y_min = ref_pos_temp(2);
    rect_y_max = ref_pos_temp(2) + y_dim;
    
    %Determines the area of the rectangle (comprising the sample area) that
    %overlaps with each cell in the grid produced for the SDF
    for j = 1:length(Xs)-1
        
        %determines the x range of the rectangle overlapping the cell
        if rect_x_min >= Xs(j) && rect_x_min <= Xs(j+1)
            %if the left edge of the rectangle lies over the cell the x
            %length of the overlap is as follows:
            rx = Xs(j+1)-rect_x_min;
        elseif rect_x_min <= Xs(j) && rect_x_max >= Xs(j+1)
            %if the cell lies fully within the rectangle then the x length
            %of the overlap is the x length of the cell
            rx = Xs(j+1) - Xs(j);
        elseif rect_x_max >= Xs(j) && rect_x_max <= Xs(j+1)
            %if the right edge of the rectangle lies over the cell, the x
            %length of the overlap is as follows:
            rx = rect_x_max - Xs(j);
        else
            %if none of the above is true, the rectangle does not overlap
            %with the cell and the x length is 0
            rx = 0;
        end
        
        for k = 1:length(Ys)-1
            
            if rect_y_min >= Ys(k) && rect_y_min <= Ys(k+1)
                %if the lower edge of the rectangle lies over the cell the 
                %y length of the overlap is as follows:
                ry = Ys(k+1)-rect_y_min;
            elseif rect_y_min <= Ys(k) && rect_y_max >= Ys(k+1)
                %if the cell lies fully within the rectangle then the y 
                %length of the overlap is the y length of the cell
                ry = Ys(k+1) - Ys(k);
            elseif rect_y_max >= Ys(k) && rect_y_max <= Ys(k+1)
                %if the upper edge of the rectangle lies over the cell, the
                %y length of the overlap is as follows:
                ry = rect_y_max - Ys(k);
            else
                %if none of the above is true, the rectangle does not 
                %overlap with the cell and the y length is 0
                ry = 0;
            end
            
            %The area of overlap is the x * y length and this is divided by
            %the spacing squared as we are interested only in the number of
            %times it is stacked on that cell.
            ra = rx*ry/(Spacing^2);
    
            %The value above is added to the normalisation matrix so that
            %each time the rectangle is stacked on a cell, this number
            %increases.  
            norm_mat(k,j) = norm_mat(k,j)+ra;
            
        end
        
    end
    
end

%Removes 0,0 points which would otherwise skew the signal (as all particles
%take the reference (0,0) position)
Z1 = Xa == 0;
Z2 = Ya == 0;
Z3 = Z1.*Z2;
Z = find(Z3 == 0);

Xa = Xa(Z);
Ya = Ya(Z);
    
%Selects only the data within X and Y limits
Z1 = Xa <= Xmax;
Z2 = Xa >= -1*Xmax;
Z3 = Ya <= Ymax;
Z4 = Ya >= -1*Ymax;

Z5 = Z1.*Z2.*Z3.*Z4;
Z = find(Z5 == 1);
Xa = Xa(Z);
Ya = Ya(Z);


%Determines the density of points within each bin
for i = 1:length(Xs)-1
    
        X1 = Xa < Xs(i+1);
        X2 = Xa >= Xs(i);
        X3 = X1.*X2;
        
    for j = 1:length(Ys)-1

        Y1 = Ya < Ys(j+1);
        Y2 = Ya >= Ys(j);
        Y3 = Y1.*Y2;
        
        Z = X3.*Y3;
        
        H(j,i) = sum(Z);
        
    end
end

%Calculates the mid-point of each bin for plotting purposes
Xm = zeros(1,length(Xs)-1);
for i = 1:length(Xs)-1
    Xm(i) = mean([Xs(i+1), Xs(i)]);
end

Ym = zeros(1,length(Ys)-1);
for i = 1:length(Ys)-1
    Ym(i) = mean([Ys(i+1), Ys(i)]);
end

%normalizes data and if any zeros remain in the normalisation matrix it
%temporarily removes them for numerical accuracy and then replaces them
%with NaN
Z_test = norm_mat == 0;
norm_mat(Z_test) = 1;
Hm = H./(norm_mat*avg_density);
Hm(Z_test) = NaN;
end