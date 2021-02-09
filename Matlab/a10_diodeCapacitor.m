% diodeCapacitor.m
clear; clc; close all;

% This script demonstrates how to using the 
% discrete kirchhoff (DK) Method to implement
% a circuit that contains a capacitor and
% a diode


% Single Diode Clipper with Capacitor (Negative DC Offset)

% Diode Parameters
Is = 1*10^-6;
Vt = 26*10^-3;
eta = 1.68;
% eta = 1;
% Is = 1*10^-15;
% Vt = 26*10^-3;

% Diode Parameters Using DK Method
C = 80*10^-9;
Fs = 48000; Ts = 1/Fs;
R = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);

% Initialize Output Signal
N = length(Vi);
Vo = zeros(N,1);

thr = 0.0000001;
x = 0; % State variable (current source)
Vd = 0; % Variable for N-R iteration
for n = 1:N 
    
    % Step 1: Find voltage across nonlinear componenets
    iter = 1;
    num = -Vi(n,1)/R + Is * (exp(Vd/(eta*Vt)) - 1) + Vd/R + x;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(Vd/(eta*Vt)) + 1/R;
        Vd = Vd - num/den;
        iter = iter + 1;
        num = -Vi(n,1)/R + Is * (exp(Vd/(eta*Vt)) - 1) + Vd/R + x;
    end
    
    % Step 2: Calculate Output
    Vo(n,1) = Vd;
    
    % Step 3: Update State Variables
    x = 2/R*(Vi(n,1) - Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);

figure;
clear; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Single Diode Clipper with Capacitor (Reversed Direction)
% Positive DC Offset

% Diode Parameters
Is = 1*10^-6;
Vt = 26*10^-3;
eta = 1.68;

% Diode Parameters Using DK Method
C = 80*10^-9;
Fs = 48000; Ts = 1/Fs;
R = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);

% Initialize Output Signal
N = length(Vi);
Vout = zeros(N,1);

thr = 0.000001;
x = 0;
Vo = 0;
for n = 1:N 
    
    
    % Step 1: Find voltage across nonlinear componenets
    num = -Vi(n,1)/R + -Is * (exp(-Vo/(eta*Vt)) - 1) + Vo/R + x;
    iter = 1;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(-Vo/(eta*Vt)) + 1/R;
        Vo = Vo - num/den;
        iter = iter + 1;
        num = -Vi(n,1)/R + -Is * (exp(-Vo/(eta*Vt)) - 1) + Vo/R + x;
    end
    % Step 2: Calculate Output
    Vout(n,1) = Vo;
    
    % Step 3: Update State Variables
    x = 2/R*(Vi(n,1) - Vo) - x;
end

% Waveforms
plot(t,Vi,t,Vout);


figure;
clear; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Single Diode Clipper with RC LPF

% Diode Parameters
Is = 1*10^-6;
Vt = 26*10^-3;
eta = 1.68;
% eta = 1;
% Is = 1*10^-15;
% Vt = 26*10^-3;

% Diode Parameters Using DK Method
R1 = 240000;
C = 80*10^-9;
Fs = 48000; Ts = 1/Fs;
R2 = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*20*t);

% Initialize Output Signal
N = length(Vi);
Vo = zeros(N,1);

x = 0;
Vd = 0;
thr = 0.000000001;
for n = 1:N 
    
    % Step 1: Find voltage across nonlinear componenets
    num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
    iter = 1;
    while (iter < 50 && abs(num) > thr)
        
        den = (Is/(eta*Vt)) * exp(Vd/(eta*Vt)) + (1/R1 + 1/R2);
        Vd = Vd - num/den;
        num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
        iter = iter + 1;
    end
    % Step 2: Calculate Output
    Vo(n,1) = Vd;
    
    % Step 3: Update State Variables
    x = 2/R2*(Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Double Diode Clipper with RC LPF

% Diode Parameters
% Is = 1*10^-6;
% Vt = 26*10^-3;
% eta = 1.68;
eta = 1;
Is = 1*10^-15;
Vt = 26*10^-3;

% Diode Parameters Using DK Method
R1 = 240000;
C = 80*10^-12;
fc = 1/(2*pi*R1*C)
Fs = 48000; Ts = 1/Fs;
R2 = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);

% Initialize Output Signal
N = length(Vi);
Vo = zeros(N,1);

x = 0;
Vd = 0;
thr = 0.000000001;
for n = 1:N 
    
    % Step 1: Find voltage across nonlinear componenets
    iter = 1;
    num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) - Is * (exp(-Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
    while (iter < 50 && abs(num) > thr)
        den = (Is/(eta*Vt)) * exp(Vd/(eta*Vt)) + (Is/(eta*Vt)) * (exp(-Vd/(eta*Vt))) + (1/R1 + 1/R2);
        Vd = Vd - num/den;
        num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) - Is * (exp(-Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
        iter = iter + 1;
    end
    % Step 2: Calculate Output
    Vo(n,1) = Vd;
    
    % Step 3: Update State Variables
    x = 2/R2*(Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);
%thd(Vo,Fs);

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Double Diode Clipper with RC LPF Combined NL EQ (sinh)

% Diode Parameters
% Is = 1*10^-6;
% Vt = 26*10^-3;
% eta = 1.68;
eta = 1;
Is = 1*10^-15;
Vt = 26*10^-3;

% Diode Parameters Using DK Method
R1 = 240000;
C = 80*10^-12;
fc = 1/(2*pi*R1*C)
Fs = 48000; Ts = 1/Fs;
R2 = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);

% Initialize Output Signal
N = length(Vi);
Vo = zeros(N,1);

x = 0;
Vd = 0;
thr = 0.0000000001;
for n = 1:N 
    
    % Step 1: Find voltage across nonlinear componenets
    iter = 1;
    num = -Vi(n,1)/R1 + 2*Is * sinh(Vd/(eta*Vt)) + (1/R1 + 1/R2)*Vd - x;
    while (iter < 50 && abs(num) > thr)
        
        den = 2*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + (1/R1 + 1/R2);
        Vd = Vd - num/den;
        num = -Vi(n,1)/R1 + 2*Is * sinh(Vd/(eta*Vt)) + (1/R1 + 1/R2)*Vd - x;
        iter = iter + 1;
    end
    % Step 2: Calculate Output
    Vo(n,1) = Vd;
    
    % Step 3: Update State Variables
    x = 2/R2*(Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);
%thd(Vo,Fs);