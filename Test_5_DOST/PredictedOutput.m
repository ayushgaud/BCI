function [ prediction] = PredictedOutput( model ,COM,handles,no_of_tests)
%Function to predict output based on trained model
Hd=evalin('base','Hd');
Window=zeros(5,6);
arduino=serialOpen(COM);
fprintf(arduino,'x');
pause(0.1);
if (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
t=1;
while(t <= 200 )  
 
   a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
   a = textscan(a, '%f', 'Delimiter',',');
   a = cell2mat(a)';
   x(t,:)=[a(2),a(3),a(5),a(6),a(8),a(9)]; 
   t=t+1;
   a=[];  %Clear the buffer
   assignin('base','x',x);
end
t=1;
x=evalin('base','x');
tic
for l=1:no_of_tests
while(t <= 50 )   
   a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
   a = textscan(a, '%f', 'Delimiter',',');
   a = cell2mat(a)';
   if(size(a,2)==9)
            x(200+t,:)=[a(2),a(3),a(5),a(6),a(8),a(9)];  %To select 6 channels  
   else
            x(200+t,:)=x(200+t-1,:);
   end
   t=t+1;
   a=[];  %Clear the buffer
   assignin('base','x',x);
end
t=1;


data = filter(Hd,x);
x=x(end-199:end,:);

    for k=1:6                               %Channel length = 6
         s_transformed=dost(data(:,k));
%         Window(rem(l,5)+1,k) =(std(s_transformed))';
           plot(abs(s_transformed));
          Window(rem(l,5)+1,k)=Create_feature(data(:,k));
     end
    % data_fft=abs(fft(data));
    % plot(data_fft(1:60,:));
    
if rem(l,5)==0    
    Xt=Window;
    assignin('base','Xt',Xt);
    Y=simlssvm(model,Xt)
    prediction= mode(Y);
    set(handles.text1,'String',strcat('Output=',num2str(prediction),' Test Case No.=' ,num2str(l),''));
    Window=zeros(5,6);
end
drawnow();
end
toc
end

