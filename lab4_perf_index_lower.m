function SEE = lab4_perf_index_lower(Cd)

% Physical parameters of the tank model:

d = 3/8; % inch
Aout = (pi/4)*d^2; % inch^2
Area = (3.5*7.5); % inch^2
h1o = 3/4; % inch. Distance from bottom of tank to top of orifice
ha = 3.25; % inch. Distance from bottom of tank to bottom of orifice
g = 32.2*12; % inch/s^2 
h0 = 9; % inch. Initial condition, from bottom of tank.

% Experimental data.
load tankDataLower; % We only need this to load from a file
tdata = tankDataLower(1,:);
hdata = tankDataLower(2,:);
% TODO get the time to plug into the below equation as t

% System model.
%hmodel = (sqrt(h0 + ha)-(Cd*Aout*sqrt(2*g)*t)/(2*Area))^2 + ha;
hmodel = tankmodel(Cd, Aout, Area, h1o, h0, ha, g, tdata);

% How close they are. We'll change Cd around 
% to make this number smaller.
SEE = sqrt(sum((hmodel-hdata).^2)./(length(hmodel)-2)); 