% diodeEquation.m

vd = [-1:.001:1];

Vt = .026;
% Silicon 
Is_s = 10e-15; % 10e-12 to 10e-15
eta_s = 1;
i_s = Is_s * (exp(vd/(eta_s*Vt)) - 1);

% Germanium
Is_g = 10e-6;
eta_g = 1.5;  % 1-2
i_g = Is_g * (exp(vd/(eta_g*Vt)) - 1);

plot(vd,i_s,vd,i_g);
axis([-1 1 -1 1]);


