function SEE = lab4_perf_index_lower(Cd)

% Experimental data.
load tankDataLower; % We only need this to load from a file
tdata = tankDataLower(1,:);
hdata = tankDataLower(2,:);
% TODO get the time to plug into the below equation as t

% System model.
%hmodel = (sqrt(h0 + ha)-(Cd*Aout*sqrt(2*g)*t)/(2*Area))^2 + ha;
hmodel = tankmodel_lower(Cd, tdata);

% How close they are. We'll change Cd around 
% to make this number smaller.
SEE = sqrt(sum((hmodel-hdata).^2)./(length(hmodel)-2)); 