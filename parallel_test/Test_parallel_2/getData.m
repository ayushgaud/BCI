function [ x ] = getData( arg_struct )
%dunction to get samples of given Samples
Samples=arg_struct.x; 
COM=arg_struct.y; 
arduino=serialOpen(COM);
fprintf(arduino,'x');
pause(0.1);
if (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
t=1;
fprintf(Object,'3');
pause(1);
fprintf(Object,'6');
pause(1);
x=zeros(Samples,9);
x(:,1)=linspace(1,Samples,Samples);
pause(0.2);
while(t <= Samples )  
 try
   a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
   a = cell2mat(textscan(a, '%d', 'Delimiter',','))';
   if ~isempty(a) || size(a,2)==9
       x(t,2:9)=a(2:9);
   else
       if(t>1)
           x(t,2:9)=x(t-1,2:9);
       end
   end
   temp=[x(t,2),x(t,3),x(t,5),x(t,6),x(t,8),x(t,9)];
   labSend(temp,2,t);
   t=t+1;
   a=0;  %Clear the buffer
 end

end

fprintf(arduino,'s');
fclose(arduino);

end


