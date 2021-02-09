% gainChange.m

Fs = 48000; % sampling rate
Ts = 1/Fs;
f = 3;
t = [0:Ts:1].';
x = sin(2 * pi * f * t);
N = length(x);

% Circuit resistors
R1 = 1e3; % 1000 = 1k
R2 = 1e3;

alpha = 1;

% Potentiometer
P1 = R1 + (1-alpha) * R2;
P2 = alpha * R2;

% Gain scalar
g = P2 / (P1 + P2);
for n = 1:N
   
    y(n,1) = g * x(n,1);
    
end

plot(t,x,t,y);