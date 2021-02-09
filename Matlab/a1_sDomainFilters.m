% sDomainFilters.m
clear; close all;
% Remember: 
%         b0 + b1 z^-1 ...
% H[z] = ----------------
%          a0 + a1 z^-1 ...
%
% b = [b0 , b1 , ...] "numerator"
% a = [a0, a1, ...  ] "denominator"

% H(s)
f = 1;
num = f;        %  1
den = [1, f];   % s + 1
freqs(num,den);
figure;
w = [.01:.01:10];
H = 1./(1j*w + 1); % s = 1j*w
subplot(2,1,1);
loglog(w,abs(H)); % amplitude
subplot(2,1,2);
semilogx(w,angle(H)*180/pi); % phase









