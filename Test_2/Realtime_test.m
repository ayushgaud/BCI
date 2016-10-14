%% Script to load data in real time 
clear all;
close all;
%Bandpass filter of 5Hz to 43 Hz
Channel_length=6;
Training_samples=1000;

d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');

Object=serialOpen('COM16');

rawData=getData(Training_samples,Object); %To get initial 250 consicutive samples

channelData=[rawData(:,2),rawData(:,3),rawData(:,5),rawData(:,6),rawData(:,8),rawData(:,9)]; %To select 6 channels
filtered_data=filter(Hd,channelData);

parfor k=1:Channel_length
    Features(:,k,:)=Create_feature(filtered_data(:,k));
end
Features=reshape(Features,size(Features,1),24);
serialClose(Object);
