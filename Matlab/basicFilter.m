% basicFilter.m

Fs = 48000;
Ts = 1/Fs;
f = 15000;
t = [0:Ts:1].';
x = sin(2*pi*f*t);

% Filter coefficients
b0 = 0.5;
b1 = -0.5;

N = length(x);

% State variable
s1 = 0; 

for n = 1:N
   
    % y[n] = 0.5 * x[n] + 0.5 * x[n-1]
    y(n,1) = b0 * x(n,1) + b1 * s1;
    s1 = x(n,1);
    
end

% Waveform
plot(t,x,t,y);

% Frequency Response
b = [b0 b1];

B0 = 1/3;
B1 = 1/3;
B2 = 1/3;
s1 = 0;
s2 = 0;
for n = 1:N
   
    % y[n] = 0.5 * x[n] + 0.5 * x[n-1]
    y(n,1) = B0 * x(n,1) + B1 * s1 + B2 * s2;
    s2 = s1;
    s1 = x(n,1);
    
end


B = [B0 B1 B2];
freqz(B);

%%% IIR 
a1 = 0.5;
s1 = 0;
for n = 1:N
    
   y(n,1) = b0 * x(n,1) + a1 * s1;
   s1 = y(n,1);
    
end

b = b0;
a = [1 -a1];
freqz(b,a);





