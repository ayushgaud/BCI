clear all
close all

load('baseline_10trial_each2500');
load('counting_10trial_each2500.mat');
load('letter_10trial_each2500.mat');
load('multiplication_10trial_each2500.mat');

%bandpass equiripple filter
d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');
Baseline=filter(Hd,baseline_10trial_each2500);
Counting=filter(Hd,counting_10trial_each2500);
Letter=filter(Hd,letter_10trial_each2500);
Multiplication=filter(Hd,multiplication_10trial_each2500);

Baseline=baseline_10trial_each2500;
Counting=counting_10trial_each2500;
Letter=letter_10trial_each2500;
Multiplication=multiplication_10trial_each2500;


Channel_length = size(Baseline,2);
% Define frame length and overlapping
f_len=250;
f_overlap=50;

Features_Baseline=zeros(length(Baseline)/(f_overlap)-4,Channel_length,4);
Features_Counting=zeros(length(Counting)/(f_overlap)-4,Channel_length,4);
Features_Letter=zeros(length(Letter)/(f_overlap)-4,Channel_length,4);
Features_Multiplication=zeros(length(Multiplication)/(f_overlap)-4,Channel_length,4);

%%Create features for each channel
for i=1:Channel_length
    Features_Baseline(:,i,:)=Create_feature(Baseline(:,i));
    Features_Counting(:,i,:)=Create_feature(Counting(:,i));
    Features_Letter(:,i,:)=Create_feature(Letter(:,i));
    Features_Multiplication(:,i,:)=Create_feature(Multiplication(:,i));
end
Features_Baseline=reshape(Features_Baseline,size(Features_Baseline,1),24);
Features_Counting=reshape(Features_Counting,size(Features_Baseline,1),24);
Features_Letter=reshape(Features_Letter,size(Features_Baseline,1),24);
Features_Multiplication=reshape(Features_Multiplication,size(Features_Baseline,1),24);

y=ones(496*4,1);
y(497:end)=y(497:end)+1;
y(993:end)=y(993:end)+1;
y(1489:end)=y(1489:end)+1;

X=[Features_Baseline ;Features_Counting ;Features_Letter ;Features_Multiplication];

