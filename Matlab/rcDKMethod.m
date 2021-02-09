% rcDKMethod.m
clear; clc;

Fs = 48000;
Ts = 1/Fs;

% Components
C1 = 82e-12;
R1 = Ts/(2*C1);
R2 = 240e3;

G = (1/R1 + 1/R2);

fc = 1/(2*pi*R2*C1);

Vi = [1 ; zeros(2047,1)];
N = length(Vi);

% Filter coefficients
b0 = R1/(R1+R2);
b1 = R1*R1/(R1+R2);

x1 = 0;

for n = 1:N
   
    Vo(n,1) = b0 * Vi(n,1) + b1 * x1;
    x1 = (2/R1) * Vo(n,1) - x1;
    
end

[H,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -30 5]);




