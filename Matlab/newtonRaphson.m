% newtonRaphson.m


% Example 1
% f(x) = x^3 + 2*x - 2
% f'(x) = 3*x^2 + 2

% Initial guess
x = 2
iter = 10;
for i = 1:iter
   
    num = x^3 + 2*x - 2;
    den = 3*x^2 + 2;
    x = x - num/den
    
end


% Example 2
% Initial guess
x = 2;
iter = 10;
i = 1;
% if f(x) = 0 then stop iterations
fx = x^3 + 2*x - 2;
thr = 0.0000001;
while (i < iter && abs(fx) > thr) 
   
    den = 3*x^2 + 2;
    x = x - fx/den;
    i = i + 1;
    fx = x^3 + 2*x - 2;
end
i;

% Example : Diode Equation
Is = 10e-6;
eta = 1.5;
Vt = 0.0254;

x = 1;
iter = 30;
i = 1;
% if f(x) = 0 then stop iterations
fx = Is * (exp(x/(eta*Vt)) - 1);
thr = 0.0000001;
while (i < iter && abs(fx) > thr) 
   
    den = Is/(eta*Vt) * exp(x/(eta*Vt));
    x = x - fx/den;
    i = i + 1;
    fx = Is * (exp(x/(eta*Vt)) - 1);
end
i
fx
x



