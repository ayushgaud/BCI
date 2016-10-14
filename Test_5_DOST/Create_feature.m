function [ Output_Windowed ] = Create_feature( Channel_Data )
%This function creates features by performing windowing on the I/P data
%% Define frame length and overlapping
f_len=250;
f_overlap=50;

Output_Windowed=zeros(length(Channel_Data)/(f_overlap)-4,1);
%% Calculate Window
for k=1:length(Channel_Data)/f_overlap-(f_len/f_overlap)+1
    Window=Channel_Data(f_overlap*(k-1)+1:f_overlap*(k-1)+f_len);
    Output_Windowed(k)=(std(dost(Window)))';
end
end

