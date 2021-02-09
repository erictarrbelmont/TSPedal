% digitalDistortion.m
clc;clear; close all;
Fs = 48000;
Ts = 1/Fs;
f = 3;
t = [0:Ts:1].';

%x = sin(2*pi*f*t);

% DC Sweep
x = [-1:.001:1].';

N = length(x);
alpha = 5; %[1-10]
for n = 1:N
   
    % Cubic Distortion
    y(n,1) = (2/pi)*atan(alpha*x(n,1));
    
end

% Waveform
%plot(t,x,t,y);

%figure;

% Characteristic Curve
plot(x,x,x,y);

%thd(y,Fs);


