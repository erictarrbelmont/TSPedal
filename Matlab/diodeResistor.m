% diodeResistor.m

clc; clear; close all;

% DC Sweep
Vi = [-1:.001:1].';

Fs = 48000;
Ts = 1/Fs;
f = 3;
t = [0:Ts:1].';
Vi = sin(2*pi*f*t);

% Diode Parameters
Is = 10e-12;
eta = 1;
Vt = 0.0253;

R = 1000;

x = 0;
iter = 30;
thr = 0.0000001;

% Loop for Vi samples
N = length(Vi);

for n = 1:N
    
    i = 1;
    fx = x/R + Is * (exp(x/(eta*Vt))-1) - Vi(n,1)/R;
    while (i < iter && abs(fx) > thr)
        den = 1/R + Is/(eta*Vt) * exp(x/(eta*Vt));
        x = x - fx/den;
        i = i+1;
        fx = x/R + Is * (exp(x/(eta*Vt))-1) - Vi(n,1)/R;
    end
    Vo(n,1) = x;
end
% DC Sweep
%plot(Vi,Vo);

% Waveform
plot(t,Vi,t,Vo);
