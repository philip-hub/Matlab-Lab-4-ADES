function h_predict = tankmodel(Cd, Aout, Area, h1o, h0, ha, g, t) % t is a vector.



h_predict = (sqrt(h0 + ha)-(Cd*Aout*sqrt(2*g)*t)/(2*Area)).^2 + ha;