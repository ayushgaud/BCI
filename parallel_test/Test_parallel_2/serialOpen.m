function [arduino] = serialOpen( COM )
%Function to open serial port

arduino=serial(COM,'BaudRate',115200);
set(arduino, 'InputBufferSize', 256); %number of bytes in inout buffer

fopen(arduino);
pause(3);


while (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
pause(2);

disp('Initialized');



