% newtonRaphson.m
clear; clc; close all;
% https://www.youtube.com/watch?v=PIPiv6gn_Ls&t=419s

% Solving a nonlinear equation with no analytic solution
% Newton-Raphson Numerical Method

%  f(x) : x^3 + 2*x - 2 = 0
% f'(x) : 3*x^2 + 2 

% x(n+1) = x(n) - f(x)/f'(x)


% Example 1: YouTube Video
N = 50;
x = 2;
for n = 1:N
    num = x^3 + 2*x - 2;
    den = 3*x^2 + 2;
    x = x - num/den;
end
x;

t = [-1:.001:2];
plot(t,t.^3 + 2*t - 2);

% Example 2: Cubic Distortion
%  f(x) : x - (1/3)*x^3 = 0
% f'(x) : 1 - (3/3)*x^2 

% x(n+1) = x(n) - f(x)/f'(x)
N = 10;
x = 0.7; % Problems when x > 0.77 (Multiple zero crossings in plot)
for n = 1:N
    num = x - (1/3)*x^3;
    den = 1-(x^2);
    x = x - num/den;
end
x;

t = [-1:.001:2];
plot(t,t - (1/3)*t.^3);


% Example 3: Arctan Distortion
%  f(x) : arctan(x) = 0
% f'(x) : 1/(1+x^2) 
N = 10;
x = 1; 
for n = 1:N
    num = atan(x);
    den = 1/(1+x^2);
    x = x - num/den;
end
x;

t = [-1:.001:2];
plot(t,atan(t));


% Example 4: Tanh Distortion
%  f(x) : tanh(x) = 0
% f'(x) : 1-tanh(x)^2
N = 10;
x = 0.9; % Problems when x > 1 
for n = 1:N
    num = tanh(x);
    den = 1-tanh(x)^2;
    x = x - num/den;
end
x;

t = [-1:.001:2];
plot(t,tanh(t));


% Example 4: Diode Equation
%  f(x) : Is * exp(Vd/(eta*Vt) - 1) = 0
% f'(x) : Is/(eta*Vt) * exp(Vd/(eta*Vt))
Vt = .0253;
eta = 1.68;
Is = 10e-6;

N = 50;
x = 1; % Vd = x
for n = 1:N
    num = Is * (exp(x/(eta*Vt)) - 1);
    den = Is/(eta*Vt) * exp(x/(eta*Vt));
    x = x - num/den;
end
x; % this is "essentially" zero

t = [-0.5:.001:0.5];
plot(t,Is * (exp(t/(eta*Vt)) - 1));