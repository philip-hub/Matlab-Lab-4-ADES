clc
clearvars
close all
%% Upper Tank Voltage to Height
%all upper tank for fitting
height = (1:9)';
v = [1.46 1.56 1.69 1.81 1.91 2.04 2.16 2.27 2.37]';

% fit voltage vs height data
fit = polyfit(height,v,1);
m=fit(1);
b=fit(2);

fprintf("Upper Tank\n")
fprintf(" m: %4.2f, ",m)
fprintf("b: %4.2f\n",b)

vFit=height*m+b;
% Figure A1
% Voltage vs height, tank upper
figure
plot(height, vFit, 'k', height, v, "or");
xlabel("height (in)")
ylabel("voltage (v)")
legend("Fit Data","Experimental Data")

%% Upper Tank Draining - Data Import
upperData = readmatrix("upper_cleaned.csv");


tdata1 = upperData(:,1); %time data
vdata1 = upperData(:,2); %voltage data
hdata1 = (vdata1-b)/m;

% Crop upper tank data and
% reset timescale
hdata1 = hdata1(11:73); 
tdata1 = tdata1(1:length(hdata1));

fprintf("Upper Tank Initial Height: %.2f in\n", hdata1(1))


tankDataUpper = [tdata1 hdata1]'; % Might need to transpose
save tankDataUpper;

% figure(1)
% plot(tdata1,hdata1)
% ylabel("height (in)")
% xlabel("time (s)")
% % 35 seconds closest to .5

%% Lower Tank Voltage to Height
%lower tank data

height2 = (1:9)';
v2 = [1.51 1.65 1.76 1.86 2.0 2.11 2.22 2.33 2.43]';

fit2 = polyfit(height2,v2,1);
m2=fit2(1);
b2=fit2(2);
vFit2=height2*m2+b2;
fprintf("Lower Tank\n")
fprintf(" m2: %4.2f, ",m2)
fprintf("b2: %4.2f\n",b2)


% Figure A2
figure
plot(height2, vFit2, 'k', height2, v2, "or");
xlabel("height (in)")
ylabel("voltage (v)")
legend("Fit Data","Experimental Data")

%% Lower Tank Draining - Data Import

lowerData = readmatrix("lower2_cleaned.csv");

tdata2 = lowerData(:,1); %time data
vdata2 = lowerData(:,3); %voltage data
hdata2 = (vdata2-b2)/m2;

% Crop lower tank data and
% reset timescale
hdata2 = hdata2(5:126); 
tdata2 = tdata2(1:length(hdata2));

fprintf("Lower Tank Initial Height: %.2f in\n", hdata2(1))


tankDataLower = [tdata2 hdata2]'; % Might need to transpose
save tankDataLower; % For @lab4_perf_index_lower to load
figure(1)
plot(tdata2,hdata2)
ylabel("height (in)")
xlabel("time (s)")
% 35 seconds closest to .5


%% Both Tanks Draining - Data Import
bothData = readmatrix("both2_cleaned.csv");

tdata3 = bothData(:,1); %time data
vdataUp3 = bothData(:,2); %voltage data upper tank
vdataDown3 = bothData(:,3); %voltage data lower tank
hdataUp3 = (vdataUp3-b)/m;
hdataDown3 = (vdataDown3-b2)/m2;

% figure
% plot(tdata3, hdataUp3, 'k', tdata3, hdataDown3, "--r");
% xlabel("height (in)")
% ylabel("voltage (v)")
% legend("Upper Tank","Lower Tank")


%% Fit Cd - Upper and Lower



Cd0 = 0.7; % Starting value for fminsearch



% Table 3: SEE with initial Cd
fprintf("\nWith initial Cd of %.2f\n", Cd0)
fprintf("Upper tank SEE = %.3f\n", lab4_perf_index_upper(0.7))
fprintf("Upper tank SEE = %.3f\n", lab4_perf_index_lower(0.7))


% Set options
options = optimset(@fminsearch);
options = optimset (options, 'Display', 'iter');

% Use fminsearch, adjusting Cd to minimize SEE
coeffs_upper = fminsearch(@lab4_perf_index_upper,Cd0,options);
coeffs_lower = fminsearch(@lab4_perf_index_lower, Cd0, options);

Cd_upper = coeffs_upper(1);
Cd_lower = coeffs_lower(1);

fprintf("Cd_upper: %.3f, ", Cd_upper)
fprintf("SEE upper: %.3f\n", lab4_perf_index_upper(Cd_upper))

fprintf("Cd_lower: %.3f, ", Cd_lower)
fprintf("SEE lower: %.3f\n", lab4_perf_index_lower(Cd_lower))

% Figure 1 & 2: Data over model response before and after optimizing Cd
load tankDataUpper; % We only need this to load from a file
tdata = tankDataUpper(1,:);
hdata = tankDataUpper(2,:);
hmodel_initial = tankmodel_upper(Cd0, tdata);
hmodel = tankmodel_upper(Cd_upper, tdata);
figure
plot(tdata, hmodel_initial, "--b", tdata, hmodel,"--r",  tdata, hdata, "k")
xlabel("Time (s)")
ylabel("Height (in)")
legend("Initial Model (Upper)", "Optimized Model", "Experimental Response")

%load tankDataLower; % We only need this to load from a file
tdata = tankDataLower(1,:);
hdata = tankDataLower(2,:);
hmodel_initial = tankmodel_lower(Cd0, tdata);
hmodel = tankmodel_lower(Cd_lower, tdata);
figure(9)
plot(tdata, hmodel, tdata, hdata)
plot(tdata, hmodel_initial, "--b", tdata, hmodel, "--r", tdata, hdata, "k")
xlabel("Time (s)")
ylabel("Height (in)")
legend("Initial Model (Lower)", "Optimized Model", "Experimental Response")


%% Simulink

%1 for upper tank
%2 for lower tank

d1=3/8;
d2=1/4;
A1 = (3.5*7.5); % inch^2
A2 = (3.5*7.5); % inch^2
Aout1 = (pi/4)*(d1^2); % in^2
Aout2 = (pi/4)*(d2^2); % in^2
b1 = 3/4; % in. b = height from bottom of tank to top of orifice
b2 = 3/4; % in
a1 = 3.25; % in. a = height from bottom of orifice to bottom of tank
a2 = 3.25; %in
Cd1 = Cd_upper;
Cd2 = Cd_lower;
g = 32.2; % ft/s^2
g = g*12; % in/s^2


% Initial Conditions
h10 = 8; % in
h20 = 4; % in



tf = 90;     % s
maxstep = 0.01; % s
tol = 1e-6; % Tolerance for the solver

sim("PreLab_4_sim.slx") % Import Simulink graph





figure % Double Tanks, simulink and data
plot(time,h1,'b', time,h2, 'r', tdata3, hdataUp3, '--k', tdata3, hdataDown3, "--r")
xlabel('Time (s)')
ylabel('Height (in)')
set(gcf, 'color', 'w')
legend('Upper Tank (Model)', 'Lower Tank (Model)',...
"Upper Tank (Experimental)","Lower Tank (Experimental)", "Location", "northeast")



