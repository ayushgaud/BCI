% program for mentanl task classification using S-transform on prem data
% After calculting S trans, mean square root value of
% standard deviation is calculated as feature
% This program is for uniformally 10 trials for each subject and each task
% Do not confused by the variables name, theya are taken from another
% program
% No of classes: 4 (basline, multiplication, counting, letter)
%%%%%%% taking 10 trial individually in this programme%%%%%%%
tic
load baseline_10trial_each2500;
load multiplication_10trial_each2500;
load counting_10trial_each2500;
load letter_10trial_each2500;



sub1_basline =baseline_10trial_each2500;
sub1_multiplication=multiplication_10trial_each2500;
sub1_counting=counting_10trial_each2500;
sub1_letter=letter_10trial_each2500;

%%%%%%%%% BASELINE Trial%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Standard deviation based features from S-transform of the channel 1%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_basline_ch1_final(new)=(mean(sqrt(std(stran(sub1_basline(trial:trial+249,1).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 2%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_basline_ch2_final(new)=(mean(sqrt(std(stran(sub1_basline(trial:trial+249,2).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 3%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_basline_ch3_final(new)=(mean(sqrt(std(stran(sub1_basline(trial:trial+249,3).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% pec based features from imf of the channel 4%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_basline_ch4_final(new)=(mean(sqrt(std(stran(sub1_basline(trial:trial+249,4).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 5%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_basline_ch5_final(new)=(mean(sqrt(std(stran(sub1_basline(trial:trial+249,5).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 6%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_basline_ch6_final(new)=(mean(sqrt(std(stran(sub1_basline(trial:trial+249,6).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

sb1_pec_emd_basline_alch_final=[sb1_pec_emd_basline_ch1_final; sb1_pec_emd_basline_ch2_final ;sb1_pec_emd_basline_ch3_final ;sb1_pec_emd_basline_ch4_final ;sb1_pec_emd_basline_ch5_final ;sb1_pec_emd_basline_ch6_final];


%%%%%%%%% multiplication Trial%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Standard deviation based features from S-transform of the channel 1%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_multiplication_ch1_final(new)=(mean(sqrt(std(stran(sub1_multiplication(trial:trial+249,1).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 2%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_multiplication_ch2_final(new)=(mean(sqrt(std(stran(sub1_multiplication(trial:trial+249,2).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 3%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_multiplication_ch3_final(new)=(mean(sqrt(std(stran(sub1_multiplication(trial:trial+249,3).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% pec based features from imf of the channel 4%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_multiplication_ch4_final(new)=(mean(sqrt(std(stran(sub1_multiplication(trial:trial+249,4).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 5%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_multiplication_ch5_final(new)=(mean(sqrt(std(stran(sub1_multiplication(trial:trial+249,5).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 6%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_multiplication_ch6_final(new)=(mean(sqrt(std(stran(sub1_multiplication(trial:trial+249,6).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

sb1_pec_emd_multiplication_alch_final=[sb1_pec_emd_multiplication_ch1_final ;sb1_pec_emd_multiplication_ch2_final ;sb1_pec_emd_multiplication_ch3_final ;sb1_pec_emd_multiplication_ch4_final ;sb1_pec_emd_multiplication_ch5_final ;sb1_pec_emd_multiplication_ch6_final];

%%%%%%%%% COUNTING Trial%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Standard deviation based features from S-transform of the channel 1%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_counting_ch1_final(new)=(mean(sqrt(std(stran(sub1_counting(trial:trial+249,1).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 2%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_counting_ch2_final(new)=(mean(sqrt(std(stran(sub1_counting(trial:trial+249,2).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 3%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_counting_ch3_final(new)=(mean(sqrt(std(stran(sub1_counting(trial:trial+249,3).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% pec based features from imf of the channel 4%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_counting_ch4_final(new)=(mean(sqrt(std(stran(sub1_counting(trial:trial+249,4).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 5%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_counting_ch5_final(new)=(mean(sqrt(std(stran(sub1_counting(trial:trial+249,5).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 6%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_counting_ch6_final(new)=(mean(sqrt(std(stran(sub1_counting(trial:trial+249,6).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

sb1_pec_emd_counting_alch_final=[sb1_pec_emd_counting_ch1_final; sb1_pec_emd_counting_ch2_final ;sb1_pec_emd_counting_ch3_final ;sb1_pec_emd_counting_ch4_final ;sb1_pec_emd_counting_ch5_final ;sb1_pec_emd_counting_ch6_final];

%%%%%%%%% Letter Trial%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Standard deviation based features from S-transform of the channel 1%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_letter_ch1_final(new)=(mean(sqrt(std(stran(sub1_letter(trial:trial+249,1).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 2%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_letter_ch2_final(new)=(mean(sqrt(std(stran(sub1_letter(trial:trial+249,2).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% ST based features from imf of the channel 3%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_letter_ch3_final(new)=(mean(sqrt(std(stran(sub1_letter(trial:trial+249,3).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

%%%%% pec based features from imf of the channel 4%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_letter_ch4_final(new)=(mean(sqrt(std(stran(sub1_letter(trial:trial+249,4).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 5%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_letter_ch5_final(new)=(mean(sqrt(std(stran(sub1_letter(trial:trial+249,5).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end
%%%%% pec based features from imf of the channel 6%%%%%%%%%

trial=1;
fr5trial=1;
new=1;
for trialchange=1:1:10
for j=1:1:46
    
    sb1_pec_emd_letter_ch6_final(new)=(mean(sqrt(std(stran(sub1_letter(trial:trial+249,6).*kaiser(250))))))';
    
    trial=trial+50;
    new=new+1;
    
    end
trial=2500*trialchange;

end

sb1_pec_emd_letter_alch_final=[sb1_pec_emd_letter_ch1_final; sb1_pec_emd_letter_ch2_final ;sb1_pec_emd_letter_ch3_final ;sb1_pec_emd_letter_ch4_final ;sb1_pec_emd_letter_ch5_final ;sb1_pec_emd_basline_ch6_final];


sb1_pec_emd_counting_alch_final=sb1_pec_emd_counting_alch_final';
sb1_pec_emd_multiplication_alch_final=sb1_pec_emd_multiplication_alch_final';
sb1_pec_emd_basline_alch_final=sb1_pec_emd_basline_alch_final';
sb1_pec_emd_letter_alch_final=sb1_pec_emd_letter_alch_final';
toc
