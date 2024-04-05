function SEE = lab4_perf_index_upper(Cd)

% Experimental data.
load tankDataUpper; % We only need this to load from a file
tdata = tankDataUpper(1,:);
hdata = tankDataUpper(2,:);

% System model.
%hmodel = (sqrt(h0 + ha)-(Cd*Aout*sqrt(2*g)*t)/(2*Area))^2 + ha;
hmodel = tankmodel_upper(Cd, tdata);

% How close they are. We'll change Cd around 
% to make this number smaller.
SEE = sqrt(sum((hmodel-hdata).^2)./(length(hmodel)-2)); 