clear all % Clear all yer variables
% close all % Close yer figure windows
clc % Clear yer command window


A1 = 30; % in^2
A2 = 30; % in^2
Aout1 = (pi/4)*(0.25^2); % in^2
Aout2 = (pi/4)*(0.125^2); % in^2
b1 = 0.5; % in
b2 = 0.5; % in
a1 = 2; % in
a2 = 2; %in
Cd1 = 0.7;
Cd2 = 0.9;
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