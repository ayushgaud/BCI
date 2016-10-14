function [Fd]=katznw(series)
% modified code for finding out the katz's fractal dimension
x=series;
len=length(x);
% To find total length of the curve
% As distance between horizontal elements is 1 always for sampling rate
L=0;

for i=1:1:len-1
    d(i)=(sqrt((x(i+1)-x(i))^2+1));
    L=d(i)+L;
    frmxd(i)=(sqrt((x(i+1)-x(1))^2+(i)^2));
end
maxd=abs(max(frmxd));
avgd=mean(d);
%Fd=abs((log10(L/avgd))/(log10(maxd/avgd)));
Fd=(log(len))/(log(len)+(log(maxd/L)));
end