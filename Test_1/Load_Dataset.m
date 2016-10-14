clear

load('baseline_10trial_each2500');
load('counting_10trial_each2500.mat');
load('letter_10trial_each2500.mat');
load('multiplication_10trial_each2500.mat');

%%bandpass equiripple filter
% d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
% d.Stopband1Constrained = true; d.Astop1 = 30;
% d.Stopband2Constrained = true; d.Astop2 = 30;
% Hd = design(d,'equiripple');
% Baseline=filter(Hd,baseline_10trial_each2500);
% Counting=filter(Hd,counting_10trial_each2500);
% Letter=filter(Hd,letter_10trial_each2500);
% Multiplication=filter(Hd,multiplication_10trial_each2500);

Baseline=baseline_10trial_each2500;
Counting=counting_10trial_each2500;
Letter=letter_10trial_each2500;
Multiplication=multiplication_10trial_each2500;


Channel_length = size(Baseline,2);
% Define frame length and overlapping
f_len=250;
f_overlap=50;

Features_Baseline=zeros(length(Baseline)/(f_overlap),Channel_length);
Features_Counting=zeros(length(Counting)/(f_overlap),Channel_length);
Features_Letter=zeros(length(Letter)/(f_overlap),Channel_length);
Features_Multiplication=zeros(length(Multiplication)/(f_overlap),Channel_length);
tic
%%Create features for each channel
for i=1:Channel_length
    Features_Baseline(:,i)=Create_feature(Baseline(:,i));
    Features_Counting(:,i)=Create_feature(Counting(:,i));
    Features_Letter(:,i)=Create_feature(Letter(:,i));
    Features_Multiplication(:,i)=Create_feature(Multiplication(:,i));
end
toc
% Features_Baseline=reshape(Features_Baseline,500,24);
% Features_Counting=reshape(Features_Counting,500,24);
% Features_Letter=reshape(Features_Letter,500,24);
% Features_Multiplication=reshape(Features_Multiplication,500,24);
% 
 test=[Features_Baseline ;Features_Counting ;Features_Letter ;Features_Multiplication];

