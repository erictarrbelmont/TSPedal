% rcFilter.m
clear; clc; close all;
% Digitizing and RC Filter

% Low-pass Filter

R = 240000;
C = 82e-12;

num = 1;
den = [R*C , 1];
fc = 1/(2*pi*R*C);
%freqs(num,den); % good place to start
W = 2*pi*[20:1:20000];
[H,w]=freqs(num,den,W);
semilogx(w/(2*pi),20*log10(abs(H)));
axis([20 20000 -30 5]);

Fs = 48000;
% Bilinear transform
% Convert analog to digital
[numD , denD] = bilinear(num,den,Fs);

figure;
freqz(numD,denD);
[Hd,F] = freqz(numD,denD,2048,Fs);
semilogx(w/(2*pi),20*log10(abs(H)),F,20*log10(abs(Hd)));
axis([20 20000 -30 5]);

% High-pass filter

num = [ R*C , 0];
den = [R*C, 1];



freqs(num,den);

% Convert analog to digital
[numD , denD] = bilinear(num,den,Fs);

figure;
freqz(numD,denD);




