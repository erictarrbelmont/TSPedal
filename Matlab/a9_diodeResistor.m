% diodeResistor.m
clear; clc; close all;

% Single Diode Clipper (AC Voltage source)
%  f(x) : -Vin/R + Is * exp(Vout/(eta*Vt) - 1) + Vout/R
% f'(x) : Is/(eta*Vt) * exp(Vd/(eta*Vt)) + 1/R
Is = 1*10^-12;
Vt = 26*10^-3;
eta = 1.68;
R = 1000;
N = 10;
c = 1;
x = 0;
thr = 0.0000001;
for Vin = -1:.001:1
    
    iter = 1;
    num = -Vin/R + Is * (exp(x/(eta*Vt)) - 1) + x/R;
    while (iter < 50 && abs(num) > thr)
        den = (Is/(eta*Vt)) * exp(x/(eta*Vt)) + 1/R;
        x = x - num/den;
        num = -Vin/R + Is * (exp(x/(eta*Vt)) - 1) + x/R;
        iter = iter + 1;
    end
    Vout(c,1) = x;
    c = c+1;
end

Vin = [-1:.001:1];
plot(Vin,Vout);


% Single Diode Clipper (reversed diode direction)
%  f(x) : -Vin/R + -Is * exp(Vout/(eta*Vt) - 1) + Vout/R
% f'(x) : -Is/(eta*Vt) * exp(Vout/(eta*Vt)) + 1/R
Is = 1*10^-12;
Vt = 26*10^-3;
eta = 1.68;
R = 1000;

c = 1;
 x = 0; 
for Vin = -1:.001:1
    iter = 1;
    num = -Vin/R - Is * (exp(-x/(eta*Vt)) - 1) + x/R;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(-x/(eta*Vt)) + 1/R;
        x = x - num/den;
        iter = iter + 1;
        num = -Vin/R - Is * (exp(-x/(eta*Vt)) - 1) + x/R;
    end
    Vout(c,1) = x;
    c = c+1;
end

Vin = [-1:.001:1];
plot(Vin,Vout);
% 
% x = [-1:.001:1];
% plot(x,-Is * (exp(-x/(eta*Vt)) - 1))
% axis([-1 1 -10 10]);


% Single Diode Clipper (diode at top of circuit, Vout over resistor)
%  f(x) : -Vin/R + Is * exp(Vd/(eta*Vt) - 1) + Vd/R
% f'(x) : Is/(eta*Vt) * exp(Vd/(eta*Vt)) + 1/R
% Vout = Vin - Vd
Is = 1*10^-12;
Vt = 26*10^-3;
eta = 1.68;
R = 1000;
c = 1;
x = 0; % Vd
for Vin = -1:.001:1
    iter = 1;
    num = -Vin/R + Is * (exp(x/(eta*Vt)) - 1) + x/R;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(x/(eta*Vt)) + 1/R;
        x = x - num/den;
        iter = iter + 1;
        num = -Vin/R + Is * (exp(x/(eta*Vt)) - 1) + x/R;
    end
    Vout(c,1) = Vin - x;
    c = c+1;
end

Vin = [-1:.001:1];
plot(Vin,Vout);

% Single Diode Clipper 
% (diode at top of circuit reversed direction, Vout over resistor)
%  f(x) : -Vin/R + -Is * exp(Vd/(eta*Vt) - 1) + Vd/R
% f'(x) : -Is/(eta*Vt) * exp(Vd/(eta*Vt)) + 1/R
% Vout = Vin - Vd
Is = 1*10^-12;
Vt = 26*10^-3;
eta = 1.68;
R = 1000;
c = 1;
x = 0; % Vd
for Vin = -1:.001:1
    iter = 1;
    num = -Vin/R + -Is * (exp(-x/(eta*Vt)) - 1) + x/R;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(-x/(eta*Vt)) + 1/R;
        x = x - num/den;
        iter = iter + 1;
        num = -Vin/R + -Is * (exp(-x/(eta*Vt)) - 1) + x/R;
    end
    Vout(c,1) = Vin - x;
    c = c+1;
end

Vin = [-1:.001:1];
plot(Vin,Vout);



% Double Diode Clipper 
% (Vout across 2 diode with opposite directions)
%  f(x) : -Vin/R + -Is * exp(-Vout/(eta*Vt) - 1) + Is * exp(Vout/(eta*Vt) - 1)+ Vd/R
% f'(x) : Is/(eta*Vt) * exp(-Vout/(eta*Vt)) + Is/(eta*Vt) * exp(Vout/(eta*Vt)) + 1/R
% Vout = Vin - Vd
%Vt = .0253;
eta = 1;
Is = 1*10^-15;
Vt = 26*10^-3;
R = 1000;
c = 1;
x = 0; % Vd
for Vin = -1:.001:1
    iter = 1;
    num = -Vin/R + -Is * (exp(-x/(eta*Vt)) - 1) + Is * (exp(x/(eta*Vt)) - 1)+ x/R;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(-x/(eta*Vt)) + (Is/(eta*Vt)) * exp(x/(eta*Vt)) + 1/R;
        x = x - num/den;
        num = -Vin/R + -Is * (exp(-x/(eta*Vt)) - 1) + Is * (exp(x/(eta*Vt)) - 1)+ x/R;
        iter = iter + 1;
    end
    Vout(c,1) = x;
    c = c+1;
end

Vin = [-1:.001:1];
plot(Vin,Vout);



% Double Diode Clipper (substitution)
% 2*Is * sinh(Vd/(eta*Vt))
% 2*Is/(eta*Vt) * cosh(Vd/(eta*Vt))
%  f(x) : -Vin/R + 2*Is * sinh(Vd/(eta*Vt))+ Vd/R
% f'(x) : 2*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + 1/R
% Vout = Vin - Vd
%Vt = .0253;
eta = 1;
Is = 1*10^-15;
Vt = 26*10^-3;
R = 1000;
c = 1;
x = 0;
for Vin = -1:.001:1
    iter = 1;
    num = -Vin/R + 2*Is * sinh(x/(eta*Vt)) + x/R;
    while (iter < 50 && abs(num)>thr)
        den = 2*Is/(eta*Vt) * cosh(x/(eta*Vt)) + 1/R;
        x = x - num/den;
        num = -Vin/R + 2*Is * sinh(x/(eta*Vt)) + x/R;
        iter = iter + 1;
    end
    Vout(c,1) = x;
    c = c+1;
end

Vin = [-1:.001:1];
plot(Vin,Vout);


% 2+1 Diode Clipper 
% (Vout across parallel diodes, 2 in one direction, 1 in other)
% Asymmetrical Clipping
%  f(x) : -Vin/R + -Is * exp(-Vout/(eta*Vt) - 1) + Is * exp(Vout/(2*eta*Vt) - 1)+ Vd/R
% f'(x) : Is/(eta*Vt) * exp(-Vout/(eta*Vt)) + Is/(eta*Vt) * exp(Vout/(2*eta*Vt)) + 1/R
% Vout = Vin - Vd
%Vt = .0253;
eta = 1;
Is = 1*10^-6;
Vt = 26*10^-3;
R = 1000;
c = 1;
x = 0; % Vd
for Vin = -1:.001:1
    iter = 1;
    num = -Vin/R + -Is * (exp(-x/(eta*Vt)) - 1) + Is * (exp(x/(0.5*eta*Vt)) - 1)+ x/R;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(-x/(eta*Vt)) + (Is/(0.5*eta*Vt)) * exp(x/(0.5*eta*Vt)) + 1/R;
        x = x - num/den;
        iter = iter + 1; 
        num = -Vin/R + -Is * (exp(-x/(eta*Vt)) - 1) + Is * (exp(x/(0.5*eta*Vt)) - 1)+ x/R;
    end
    Vout(c,1) = x;
    c = c+1;
end

Vin = [-1:.001:1];
plot(Vin,Vout);