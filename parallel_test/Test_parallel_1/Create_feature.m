function [ Output_Windowed ] = Create_feature( arg_struct)
%This function creates features bx performing windowing on the I/P data
%% Define frame length and overlapping
Samples=arg_struct.x; 
Hd=arg_struct.y;
Channel_length=arg_struct.z;
f_len=250;
f_overlap=50;
Output_Windowed=zeros(length(Samples)/(f_overlap)-4,4,Channel_length);
pause(5);
fid=fopen('data.txt','r');
%%Get initial samples
flag=0;
x=zeros(f_len,6);
p=1;
while flag<10 && p<=f_len-f_overlap
     if ~feof(fid)   
            temp=fgets(fid);
            temp=textscan(temp,'%f', 'Delimiter',',');
            temp=cell2mat(temp)';
            temp=[temp(:,2),temp(:,3),temp(:,5),temp(:,6),temp(:,8),temp(:,9)];
            x(p,:)=temp;
            p=p+1;
     else 
            flag=flag+1;
            pause(0.01)
     end
end
%%Get f_len data from file 
for k=1:Samples/(f_overlap)-4
p=1;
while flag<10 && p<=f_overlap
     if ~feof(fid)   
            temp=fgets(fid);
            temp=textscan(temp,'%f', 'Delimiter',',');
            temp=cell2mat(temp)';
            temp=[temp(:,2),temp(:,3),temp(:,5),temp(:,6),temp(:,8),temp(:,9)];
            x(200+p,:)=temp;
            p=p+1;
     else 
            flag=flag+1;
            pause(0.01)
     end
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
fclose(fid);
Output_Windowed=reshape(Output_Windowed,size(Output_Windowed,1),24);
assignin('base','Output_Windowed',Output_Windowed);
end


