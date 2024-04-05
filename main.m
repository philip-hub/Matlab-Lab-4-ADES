clc
clearvars
close all

%all upper tank for fitting
height = (1:9)';
v = [1.46 1.56 1.69 1.81 1.91 2.04 2.16 2.27 2.37]';

fit = polyfit(height,v,1);
m=fit(1);
b=fit(2);

fprintf("Upper Tank")
fprintf(" m: %4.2f",m)
fprintf("b: %4.2f",b)

vFit=height*m+b;

figure
plot(height, vFit, 'k', height, v, "--r");
xlabel("height (in)")
ylabel("voltage (v)")
legend("Fit Data","Experimental Data")

% upper tank data
upperData = readmatrix("upper_cleaned.csv");


tdata1 = upperData(:,1); %time data
vdata1 = upperData(:,2); %voltage data
hdata1 = (vdata1-b)/m;

tankDataUpper = [tdata1 hdata1]'; % Might need to transpose
save tankDataUpper;

figure
plot(tdata1,hdata1)
ylabel("height (in)")
xlabel("time (s)")
%35 seconds closest to .5

%lower tank data

height2 = (1:9)';
v2 = [1.51 1.65 1.76 1.86 2.0 2.11 2.22 2.33 2.43]';

fit = polyfit(height2,v2,1);
m2=fit(1);
b2=fit(2);
vFit2=height2*m2+b2;
fprintf("Lower Tank")
fprintf(" m2: %4.2f",m2)
fprintf("b2: %4.2f",b2)


figure
plot(height2, vFit2, 'k', height2, v2, "--r");
xlabel("height (in)")
ylabel("voltage (v)")
legend("Fit Data","Experimental Data")

lowerData = readmatrix("lower2_cleaned.csv");

tdata2 = lowerData(:,1); %time data
vdata2 = lowerData(:,3); %voltage data
hdata2 = (vdata2-b2)/m2;

tankDataLower = [tdata2 hdata2]'; % Might need to transpose
save tankDataLower;

figure
plot(tdata2, hdata2)
xlabel("height (in)")
ylabel("voltage (v)")




%both tanks
bothData = readmatrix("both2_cleaned.csv");

tdata3 = bothData(:,1); %time data
vdataUp3 = bothData(:,2); %voltage data upper tank
vdataDown3 = bothData(:,3); %voltage data lower tank
hdataUp3 = (vdataUp3-b)/m;
hdataDown3 = (vdataDown3-b2)/m2;

figure
plot(tdata3, hdataUp3, 'k', tdata3, hdataDown3, "--r");
xlabel("height (in)")
ylabel("voltage (v)")
legend("Upper Tank","Lower Tank")



Cd0 = 0.7; % Starting value for fminsearch

options = optimset(@fminsearch);
options = optimset (options, 'Display', 'iter');

coeffs_upper = fminsearch(@lab4_perf_index_upper,Cd0,options);
coeffs_lower = fminsearch(@lab4_perf_index_lower, Cd0, options);

Cd_upper = coeffs_upper(1);
Cd_lower = coeffs_lower(1);

% TODO plot tankmodel(Cd1_upper, t) vs actual height, t
% Experimental data.
load tankDataUpper; % We only need this to load from a file
tdata = tankDataUpper(1,:);
hdata = tankDataUpper(2,:);
hmodel = tankmodel_upper(Cd_upper, tdata);
plot(tdata, hmodel, tdata, hdata)

load tankDataLower; % We only need this to load from a file
tdata = tankDataLower(1,:);
hdata = tankDataLower(2,:);
hmodel = tankmodel_lower(Cd_lower, tdata);
plot(tdata, hmodel, tdata, hdata)


%Simulink


clear all % Clear all yer variables
% close all % Close yer figure windows
clc % Clear yer command window

%1 for upper tank
%2 for lower tank

d1=3/8;
d2=1/4;
A1 = (pi/4)*d1^2; % in^2
A2 = (pi/4)*d2^2; % in^2 
Aout1 = (pi/4)*(0.25^2); % in^2
Aout2 = (pi/4)*(0.125^2); % in^2
b1 = 0.5; % in
b2 = 0.5; % in
a1 = 3.25; % in
a2 = 3.25; %in
Cd1 = Cd_upper;
Cd2 = Cd_lower;
g = 32.2; % ft/s^2
g = g*12; % in/s^2


% Initial Conditions
h10 = 7; % in
h20 = 3; % in



tf = 400;     % s
maxstep = 0.01; % s
tol = 1e-6; % Tolerance for the solver

sim("PreLab_4_sim.slx") % Import Simulink graph



figure(1) % Voltage graph
plot(time,h1,'b', time,h2, 'r')
xlabel('Time (s)')
ylabel('Height (in)')
set(gcf, 'color', 'w')
legend('Tank 1', 'Tank 2', "Location", "northeast")



