function [Training_Data,Features,model,P] = Begin_Training(COM,No_of_Trials,No_of_Classes,wait_for_cue,cue_time,trial_duration,end_duration)

%%Initilize variables
fs=250;  %sampling rate
Trial_samples=fs*trial_duration;
Training_Data=zeros(No_of_Trials*No_of_Classes*(Trial_samples-fs),7);%To delete 1 second of initial data
Features=zeros(35*No_of_Classes,6);
%entropy=zeros(1,((Trial_samples-fs)/2)+1);
%variance=zeros(1,((Trial_samples-fs)/2)+1);

%%Initialize bandpass filter
% d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2',200,0.02,0.032,0.16,0.172);
% Hd = design(d,'equiripple');

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

%For multiclass CSP features

path(path,'C:\Users\Ayush\OneDrive\Documents\BCI\Matlab_Training_Env/SVM');
path(path,'C:\Users\Ayush\OneDrive\Documents\BCI\Matlab_Training_Env/CSP/MulticlassCSP');

d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');

TrainingData=Training_Data;
class1=filter(Hd,detrend(TrainingData((TrainingData(:,7)==1),1:6),0));
class2=filter(Hd,detrend(TrainingData((TrainingData(:,7)==2),1:6),0));
class3=filter(Hd,detrend(TrainingData((TrainingData(:,7)==3),1:6),0));

co_mat=zeros(3,6,6);
co_mat(1,:,:)=cov(class1);
co_mat(2,:,:)=cov(class2);
co_mat(3,:,:)=cov(class3);

P=MulticlassCSP(co_mat,6);

classtrain=horzcat(class1',class2',class3');
train=spatFilt(classtrain,P,6)';
feat=zeros(35,6);
for iter=1:3
    temp=abs(fft(train(1+size(class1,1)*(iter-1):size(class1,1)*(iter),:),250));
    feat(1+35*(iter-1):35*iter,:)=temp(6:40,:);
end

label=horzcat(ones(size(feat,1)/3,1)',2*ones(size(feat,1)/3,1)',3*ones(size(feat,1)/3,1)')';
model=TrainSVM(feat,label);

fprintf('Training Completed\n');
close;
% model=TrainSVM(Features(:,1:end-1),Features(:,end));
% a=simlssvm(model,Features(:,1:end-1));
% while sum(a==Features(:,end))/size(Features,1)<=0.75
%     model=TrainSVM(Features(:,1:end-1),Features(:,end));
%     a=simlssvm(model,Features(:,1:end-1));
% end
% fprintf('Classifier Trained with accuracy %d\n',sum(a==Features(:,end))/size(Features,1));
end

