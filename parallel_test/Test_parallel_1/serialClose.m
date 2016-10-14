function [ ] = serialClose(arduino)
%Finction to stop data and close serial port

pause(1);
fprintf(arduino,'s');
fclose(arduino);
clear arduino;
disp('Port Closed');
end

