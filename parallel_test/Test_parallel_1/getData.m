function [ ] = getData( arg_struct )
%dunction to get samples of given Samples
Samples=arg_struct.x; 
COM=arg_struct.y; 
arduino=serialOpen(COM);
fid=fopen('data.txt','w');
fprintf(arduino,'x');
pause(0.1);
if (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
t=1;
x=zeros(Samples,9);
x(:,1)=linspace(1,Samples,Samples);
pause(0.2);
while(t <= Samples )  
 
   a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
   a = cell2mat(textscan(a, '%d', 'Delimiter',','))';
   if ~isempty(a) || size(a,2)==9
       x(t,2:9)=a(2:9);
   else
       if(t>1)
           x(t,2:9)=x(t-1,2:9);
       end
   end
   fprintf(fid,'%d,%d,%d,%d,%d,%d,%d,%d,%d\n',x(t,:));
   t=t+1;
   a=0;  %Clear the buffer
end
fclose(fid);
fprintf(arduino,'s');


end


