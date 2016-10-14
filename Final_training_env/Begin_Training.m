function [Training_Data,model,P] = Begin_Training(COM,No_of_Trials,No_of_Classes,wait_for_cue,cue_time,trial_duration,end_duration)

%%Initilize variables
fs=250;  %sampling rate
Trial_samples=fs*trial_duration;
Training_Data=zeros(No_of_Trials*No_of_Classes*(Trial_samples-fs),7);%To delete 1 second of initial data


%%To Generate random sequence for training
sequence=[];
cue_images={'foot.png','multiplication.png','box.png'};
for n=1:No_of_Trials
    sequence=cat(2,sequence,randperm(No_of_Classes));
end

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
%&Set Figure
figure;
x0=100;y0=100;width=400;height=400;
set(gcf,'units','points','position',[x0,y0,width,height])

%%Begin Trial
for n=1:No_of_Trials*No_of_Classes
    fprintf('Trial No. %d of %d\n',n,No_of_Trials*No_of_Classes);
    imshow(imresize(imread('start.jpg'),[width height]));
    pause(wait_for_cue);
    imshow(imresize(imread('go.png'),[width height]));
    pause(cue_time);
    imshow(imresize(imread(cue_images{sequence(n)}),[width height]));
    
    t=1;
    x=zeros(Trial_samples,7);
    fscanf(arduino); %To clear serial buffer
    while(t <= Trial_samples )  

       a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
       a = textscan(a, '%f', 'Delimiter',',');
       a = cell2mat(a)';
       if(size(a,2)==9)
                x(t,:)=[a(2),a(3),a(5),a(6),a(8),a(9),sequence(n)];  %To select 6 channels and last column for sequence type 
       else
           if(t>1)
                x(t,:)=x(t-1,:);
           end
       end
       t=t+1;
       assignin('base','x',x);
    end
   
    x=x(fs+1:end,:);
    Training_Data((n-1)*size(x)+1:(n)*size(x),:)=x;

%     for epoch=1:trial_duration-1
%         for channel=1:6
%             temp=st(x((epoch-1)*fs+1:epoch*fs,channel));
%             temp2=pec(temp(2:40,:),5,1);
%             Features((trial_duration-1)*(n-1)+epoch,5*channel-4:5*channel)=[mean(temp2),max(temp2),mean(sqrt(std(temp(2:40,:)))),max(sqrt(std(temp(2:40,:)))),min(sqrt(std(temp(2:40,:))))];
%         end
%         Features((trial_duration-1)*(n-1)+epoch,end)=sequence(n);
%     end
    imshow(imresize(imread('end.png'),[width height]));
    pause(end_duration);
end

[Features,label]=CSP_features(Training_Data);
model=classify_svm(Features,label);
end

