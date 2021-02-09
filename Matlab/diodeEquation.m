% diodeEquation.m

% DC Sweep (voltage)
x = [-1:.0001:1].';

% Diode Coefficients
Is_s = 10e-15; % silicon
eta_s = 1;
Vt = 0.026;

Is_g = 10e-6; % germanium
eta_g = 2;

N = length(x);
for n = 1:N
   
    % Output Current
    y(n,1) = Is_s * (exp(x(n,1)/(eta_s*Vt)) - 1);
     
    ger(n,1) = Is_g * (exp(x(n,1)/(eta_g*Vt)) - 1);
end

plot(x,y,x,ger);
axis([-1 1 -1 1]);



 

