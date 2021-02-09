% DKsallenKey.m
clear; clc; close all;
% Active Sallen-Key LPF

% Low-pass Filter
Fs = 48000; Ts = 1/Fs;

% Components
C1 = .1e-6;
R1 = Ts/(2*C1);
C2 = .1e-6;
R2 = Ts/(2*C2);
R3 = 10e3;
R4 = 10e3;
RA = 10e3;
RB = 5.55e3;

Vi = [1; zeros(2047,1)];
N = length(Vi);
Vo = zeros(N,1);

Gy = (1/R2 + 1/R3 + 1/R4);
Go = RB/(RA+RB);
Gp = R4/R1 + 1;

% Filter coefficients
a0 = Gy * Go * Gp - 1/R2 - Go/R4;
b0 = 1/(R3 * a0);
b1 = R4 * Gy/a0;
b2 = 1/a0;

% States
x1 = 0;
x2 = 0;
for n = 1:N
    Vo(n,1) = b0 * Vi(n,1) + b1 * x1 + b2 * x2;
    Vx = Vo(n,1) * Go;
    Vy = Vo(n,1) * Go * Gp - R4 * x1;
    x1 = (2/R1) * Vx - x1;
    x2 = (2/R2) * (Vy-Vo(n,1)) - x2;
end
[H,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -30 25]);

