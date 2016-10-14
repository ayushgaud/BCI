function [x] = f2()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for k=1:10
    x=labReceive(1,k)
end
   assignin('base','x',x);
end

