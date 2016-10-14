function [] = Begin_Testing(P,model,COM,No_of_Trials,wait_for_cue,cue_time,trial_duration,end_duration,result_duration )

%%Initilize variables
fs=250;  %sampling rate
Trial_samples=fs*trial_duration;
cue_images={'foot.png','multiplication.png','box.png'};
%variance=zeros(1,((Trial_samples-fs)/2)+1);
%Features=zeros(4,30);

% %%Initialize bandpass filter
% d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2',200,0.02,0.032,0.16,0.172);
% Hd = design(d,'equiripple');
% 

%%Initialize the device for data acquisition
instrreset
arduino = serial(COM, 'BaudRate', 500000);
arduino.BytesAvailableFcnCount = 1;
arduino.Timeout = 5;
fopen(arduino);
pause(2);
fprintf(arduino,'x');
pause(0.1);
if (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
pause(4);

%Empty read 100 lines
for n=1:100     
    fgets(arduino);
end
fprintf('Device Initialized\n');

%Set Figure
figure;
x0=100;y0=100;width=400;height=400;
set(gcf,'units','points','position',[x0,y0,width,height])

%%Begin Trial
for n=1:No_of_Trials
    imshow(imresize(imread('start.jpg'),[width height]));
    pause(wait_for_cue);
    imshow(imresize(imread('go.png'),[width height]));
    pause(cue_time);
    t=1;
    x=zeros(Trial_samples,6);
    fscanf(arduino); %To clear serial buffer
    while(t <= Trial_samples )  

       a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
       a = textscan(a, '%f', 'Delimiter',',');
       a = cell2mat(a)';
       if(size(a,2)==9)
                x(t,:)=[a(2),a(3),a(5),a(6),a(8),a(9)];  %To select 6 channels and last column for sequence type 
       else
           if(t>1)
                x(t,:)=x(t-1,:);
           end
       end
       t=t+1;
       assignin('base','x',x);
    end
    x=x(fs+1:end,:);
%     for epoch=1:trial_duration-1
%         for channel=1:6
%             temp=st(x((epoch-1)*fs+1:epoch*fs,channel));
%             temp2=pec(temp(2:40,:),5,1);
%             Features((trial_duration-1)*(n-1)+epoch,5*channel-4:5*channel)=[mean(temp2),max(temp2),mean(sqrt(std(temp(2:40,:)))),max(sqrt(std(temp(2:40,:)))),min(sqrt(std(temp(2:40,:))))];   
%         end
%     end
    
    
    temp=abs(fft(spatFilt(x,P,6)',250));
    Features=temp(6:40,:);
    y=mode(simlssvm(model,Features));
    try
        imshow(imresize(imread(cue_images{y}),[width height]));
    catch
        fprintf('Error in classification\n');
    end
    pause(result_duration);
    imshow(imresize(imread('end.png'),[width height]));
    pause(end_duration);
end
close;
end

