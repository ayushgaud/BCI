function [arduino] = serialOpen( COM )
%Function to open serial port
instrreset;
arduino=serial(COM,'BaudRate',500000);
set(arduino, 'InputBufferSize', 512); %number of bytes in inout buffer
fopen(arduino);
pause(3);

while (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
pause(2);
disp('Running');




