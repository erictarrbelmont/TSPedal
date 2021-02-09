% TSClipper.m
clear; clc; close all;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tube Screamer Clipping Section

% Diode Parameters
% Is = 1*10^-6;
% Vt = 26*10^-3;
% eta = 1.68;
eta = 1;
Is = 1*10^-15;
Vt = 26*10^-3;

Fs = 48000; Ts = 1/Fs;
% Components 
C1 = 47*10^-9;
R1 = Ts/(2*C1);
C2 = 51*10^-12;
R2 = Ts/(2*C2);
pot = 1;
P1 = pot*500000;
R3 = 51000 + P1;
R4 = 4700;%47000;

% Combined Resistances
G1 = (1 + R4/R1);
G4 = (1 + R1/R4);


% Choose Input Signal
%Vi = [-1:.001:1].'; % DC Sweep

t = [0:Ts:1].';
Vi = 0.1*sin(2*pi*10000*t); % Error for 10000

% Initialize Output Signal
N = length(Vi);
Vo = zeros(N,1);

x1 = 0;
x2 = 0;
thr = 0.00000000001;
Vd = 0;
for n = 1:N 
    
    % Step 1: Find voltage across nonlinear componenets
    p = -Vi(n,1)/(G4*R4) + R1/(G4*R4)*x1 - x2;

    iter = 1;
    num =  p + Vd/R2 + Vd/R3 + 2*Is * sinh(Vd/(eta*Vt));
    while(iter<50 && abs(num) > thr)
        
        den = 2*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + 1/R2 + 1/R3;
        Vd = Vd - num/den;
        iter = iter + 1;
        num =  p + Vd/R2 + Vd/R3 + 2*Is * sinh(Vd/(eta*Vt));
    end
  
    % Step 2: Calculate Output
    Vo(n,1) = Vd + Vi(n,1);
    
    % Step 3: Update State Variables
    x1 = (2/R1)*(Vi(n,1)/G1 + x1*R4/G1) - x1;
    x2 = (2/R2)*(Vd) - x2;
end

% DC Sweep
%plot(Vi,Vo);

% Waveforms
ttt = 600;
plot(t(1:ttt),Vi(1:ttt),t(1:ttt),Vo(1:ttt));
axis([t(1) t(ttt) -2 2]);

% THD
%figure;
%thd(Vo,Fs);




%%%%%%%%%%%%%%%% DAMPED Newton-Raphson

t = [0:Ts:1].';
Vi = 1*sin(2*pi*400*t);

% Initialize Output Signal
N = length(Vi);
Vo = zeros(N,1);

x1 = 0;
x2 = 0;
x3 = 0;
thr = 0.000000001;
Vd = 0;
for n = 1:N 
    
    % Step 1: Find voltage across nonlinear componenets
    p = -Vi(n,1)/(G4*R4) + R1/(G4*R4)*x1 - x2;

    iter = 1;
    b = 1;
    fd =  p + Vd/R2 + Vd/R3 + 2*Is * sinh(Vd/(eta*Vt));
    while(iter<50 && abs(fd) > thr)
        
        den = 2*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + 1/R2 + 1/R3;
        Vnew = Vd - b*fd/den;
        fn = p + Vnew/R2 + Vnew/R3 + 2*Is * sinh(Vnew/(eta*Vt));
        if (abs(fn) > abs(fd))
            b = b/2;
        else
            Vd = Vnew;
            b = 1;
        end
        fd =  p + Vd/R2 + Vd/R3 + 2*Is * sinh(Vd/(eta*Vt));
        iter = iter + 1;
    end
    
    % Step 2: Calculate Output
    Vo(n,1) = Vd + Vi(n,1);
    
    % Step 3: Update State Variables
    x1 = (2/R1)*(Vi(n,1)/G1 + x1*R4/G1) - x1;
    x2 = (2/R2)*(Vd) - x2;
end

% Waveforms
ttt = 200;
plot(t(1:ttt),Vi(1:ttt),t(1:ttt),Vo(1:ttt));
axis([t(1) t(ttt) -2 2]);
%plot(t,Vi,t,Vo);