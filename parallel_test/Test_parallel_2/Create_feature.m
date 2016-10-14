function [ Output_Windowed ] = Create_feature( arg_struct)
%This function creates features bx performing windowing on the I/P data
%% Define frame length and overlapping
Samples=arg_struct.x; 
d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');
Channel_length=arg_struct.y;
f_len=250;
f_overlap=50;
Output_Windowed=zeros(Samples/(f_overlap)-4,4,Channel_length);
%%Get initial samples
flag=1;
x=zeros(f_len,6);
p=1;

while p<=f_len-f_overlap
  
            x(p,:)=labReceive(1,flag);
            flag=flag+1;
            p=p+1;
            
end
%%Get f_len data from file 
for k=1:Samples/(f_overlap)-4
p=1;
while flag<=Samples && p<=f_overlap
     
            x(200+p,:)=labReceive(1,flag);
            flag=flag+1;
            p=p+1;

end
%% Calculate Window
for channel=1:6
    
    Window=x(:,channel).*kaiser(f_len);
    filtered_Window=filter(Hd,Window);
    Output_Windowed(k,1,channel)=(mean(sqrt(std(st(filtered_Window)))))';
    Output_Windowed(k,2,channel)=(std((std(st(filtered_Window)))))';
    Output_Windowed(k,3,channel)=(kurtosis((std(st(filtered_Window)))))';
    Output_Windowed(k,4,channel)=(skewness((std(st(filtered_Window)))))';

end
x(1:200,:)=x(51:250,:);
end
Output_Windowed=reshape(Output_Windowed,size(Output_Windowed,1),24);
end



