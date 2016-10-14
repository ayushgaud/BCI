load('baseline_10trial_each2500');
load('counting_10trial_each2500.mat');
load('letter_10trial_each2500.mat');
load('multiplication_10trial_each2500.mat');

Baseline=Normalize(baseline_10trial_each2500);
Counting=Normalize(counting_10trial_each2500);
Letter=Normalize(letter_10trial_each2500);
Multiplication=Normalize(multiplication_10trial_each2500);
