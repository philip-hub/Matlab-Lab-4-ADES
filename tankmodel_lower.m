function h_predict = tankmodel_lower(Cd, t) % t is a vector.


% Physical parameters of the tank model:

d = 1/4; % inch
Aout = (pi/4)*d^2; % inch^2
Area = (3.5*7.5); % inch^2
h1o = 3/4; % inch. Distance from bottom of tank to top of orifice
ha = 3.25; % inch. Distance from bottom of tank to bottom of orifice
g = 32.2*12; % inch/s^2 
h0 = 8.97; % inch. Initial condition, from bottom of tank.



h_predict = (sqrt(h0 + ha)-(Cd*Aout*sqrt(2*g)*t)/(2*Area)).^2 - ha;