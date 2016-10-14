function [ y ] = getData( length,arduino )
%Function to get samples of given length

fprintf(arduino,'x');
pause(0.1);
if (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
t=1;

while(t <= length )  
 
   a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
   a = textscan(a, '%f', 'Delimiter',',');
   x(t,:,:)=a;
   
   t=t+1;
   a=0;  %Clear the buffer
   assignin('base','x',x);
end
x=evalin('base','x');
y=reshape(cell2mat(x),9,length)';

fprintf(arduino,'s');


end


