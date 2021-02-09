

clear; clc; close all;
Fs = 48000;
Ts = 1/Fs;

C1 = .22e-6; 
R1 = Ts/(2*C1);

C2 = .22e-6; 
R2 = Ts/(2*C2);

C3 = .22e-6; 
R3 = Ts/(2*C3);

C4 = 1*10^-6;
R4 = Ts/(2*C4);

R5 = 220;
R6 = 1000; 
R7 = 1000;  
R8 = 220;

R9 = 1000;
potOut = 1; % [0.000001 - 1] (-120 dB to 0 dB)
R10 = 100e3 * (1-potOut);
R11 = 100e3 * potOut;

pot = .05; %[0.0001-.9999]
for pot = 0.01:.1:.99
    
    P1 = 20000*pot;
    P2 = 20000*(1-pot);

    % Grouped resistances
    G2 = 1 + R2/P1 + R5/P1; %%
    G3 = 1 + R3/P2 + R8/P2; %%
    Gx = 1 + R7/(G3*P2); %% 
    Gz = (1/R1 + 1/R6 + 1/(G2*P1)); %%
    Go = (1 + R10/R11 + R9/R11 + R4/R11); %%
    Gr = 1 + P1/R2 + R5/R2; %%
    Gs = 1 + P2/R3 + R8/R3; %%
    
    % States
    x1 = 0;
    x2 = 0;
    x3 = 0;
    x4 = 0;

    b0 = Gx/(Go*R6*Gz);
    b1 = Gx/(Go*Gz);
    b2 = Gx*R2/(G2*Gz*Go*P1);
    b3 = -R3*R7/(Go*G3*P2);
    b4 = -R4/Go;

    Vi = [1;zeros(4095,1)];
    N = length(Vi);
    Vo = zeros(N,1);
    for n=1:N
       Vo(n,1) = b0*Vi(n,1) + b1*x1 + b2*x2 + b3*x3 + b4*x4;
       vx = Vi(n,1)/(R6*Gz) + x1/Gz + x2*R2/(G2*Gz*P1);
       %vy = vx * (1+R7/(G3*P2)) - R3*R7/(G3*P2)*x3;
       x1 = (2/R1)*(vx) - x1;
       x2 = (2/R2)*(vx/Gr + x2*(P1+R5)/Gr) - x2;
       x3 = (2/R3)*(vx/Gs + x3*(P2+R8)/Gs) - x3;
       x4 = 2*Vo(n,1)/R11 + x4;

    end

    [H,F] = freqz(Vo,1,4096,Fs);
    plot(F , 20*log10(abs(H)));
    %semilogx(F , 20*log10(abs(H)));
    hold on;
end
axis([0 20000 -30 2]);
hold off;


