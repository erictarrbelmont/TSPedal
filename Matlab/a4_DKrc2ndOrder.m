% DKrc2ndOrder.m
clear; clc; close all;
% Digitizing a 2nd-order RC Filter

% Low-pass Filter
Fs = 48000; Ts = 1/Fs;

% Components
C1 = 82e-12;
R1 = Ts/(2*C1);
R2 = R1;
R3 = 240e3;
R4 = R3;

%fc = 1/(2*pi*R2*C1);

Vi = [1; zeros(2047,1)];
N = length(Vi);
Vo = zeros(N,1);

Gx = (1/R1 + 1/R3 + 1/R4);
Go = ((R4+R2)/R2);

% Filter coefficients
a0 = Go - 1/(R4*Gx);
b0 = 1/(R3 * Gx * a0);
b1 = 1/(Gx * a0);
b2 = R4/a0;
% States
x1 = 0;
x2 = 0;
for n = 1:N
    Vo(n,1) = b0 * Vi(n,1) + b1 * x1 + b2 * x2;
    Vx = Vo(n,1) * Go - R4*x2;
    x1 = (2/R1) * Vx - x1;
    x2 = (2/R2) * Vo(n,1) - x2;
end
[H,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -30 5]);

