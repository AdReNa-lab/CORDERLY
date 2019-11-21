function [Tm, Theta] = Angular_Distribution_Function(Data, Rmin, Rmax, Theta_Spacing)

%Read in positional information
Xd = Data(:,1);
Yd = Data(:,2);

%Pre-sets the Xa, Ya vectors for speed
Xa = zeros(length(Xd)^2,1);
Ya = zeros(length(Xd)^2,1);

%Create array for every particle in relation to every other particle
for i = 1:length(Xd)
    Xc = Xd(i);
    Yc = Yd(i);
    
    X_temp = Xd-Xc;
    Y_temp = Yd-Yc;
    
    Xa((i-1)*length(Xd)+1:i*length(Xd),1) = X_temp;
    Ya((i-1)*length(Yd)+1:i*length(Yd),1) = Y_temp;
end

%Removes 0,0 points which would otherwise skew the signal
Z1 = Xa == 0;
Z2 = Ya == 0;
Z3 = Z1.*Z2;
Z = find(Z3 == 0);

Xa = Xa(Z);
Ya = Ya(Z);
    
%Selects data within Radial Limit
Z1 = Xa <= Rmax;
Z2 = Xa >= -1*Rmax;
Z3 = Ya <= Rmax;
Z4 = Ya >= -1*Rmax;

Z5 = Z1.*Z2.*Z3.*Z4;
Z = find(Z5 == 1);
Xa = Xa(Z);
Ya = Ya(Z);

%Converts X,Y data from cartesian to polar- angle in radians
[T_rad,R] = cart2pol(Xa,Ya); 
T = T_rad;

%Theta spacing was set in degrees, converted here to radians 
Theta_Spacing_rad = Theta_Spacing*pi/180;

%Sets up the bin edges for angle, only goes to 180degrees as it is
%inherently symmetrical around 180degrees
Ts = 0:Theta_Spacing_rad:pi;
    
%Pre-sets the variables for speed
Theta = zeros(length(Ts)-1,1);
Tm = zeros(length(Ts)-1,1);
%Tm2 is set to plot 360 degrees based on rotational symmetry 
Tm2 = Tm;
    
%Limits the data to within the Radial limits specified by user
Test1 = R >= Rmin;
Test2 = R <= Rmax;
   
Test = Test1.*Test2;
Z = find(Test > 0);
   
T_temp = T(Z); %#ok<*FNDSB>
   
%Determines the number of points within each bin
for j = 1:length(Ts)-1
   Test1 = T_temp < Ts(j+1);
   Test2 = T_temp >= Ts(j);
   Test3 = Test1.*Test2; 

   Theta(j) = sum(Test3);

   Tm(j) = (Ts(j+1)+Ts(j))/2;
   Tm2(j) = Tm(j) + pi;
end
   
%Connects the ends of the data for clarity in the polar plot
Tm = [Tm; Tm2; Tm(1)];
Theta = [Theta; Theta; Theta(1)];

%normalises the data
Theta_m = mean(Theta);
Theta = Theta./Theta_m;
end