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
