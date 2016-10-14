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
   b=cell2mat(a);
   if(size(b,1)==9)
        x(t,:,:)=cell2mat(a);
        
   else if(t>=2)
        x(t,:,:)=x(t-1,:,:);
       end
   end
   t=t+1;
   a=0;  %Clear the buffer
   assignin('base','x',x);
end
x=evalin('base','x');
y=reshape(x,9,length)';

fprintf(arduino,'s');


end


