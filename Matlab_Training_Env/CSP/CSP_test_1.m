d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');

class1=filter(Hd,detrend(TrainingData((TrainingData(:,end)==1),1:end-1),0))';
class2=filter(Hd,detrend(TrainingData((TrainingData(:,end)==2),1:end-1),0))';
class3=filter(Hd,detrend(TrainingData((TrainingData(:,end)==3),1:end-1),0))';

[PTranspose] = CSP(class2,class3);

classtrain= horzcat(class2,class3);

train = spatFilt(classtrain,PTranspose,6);

label=horzcat(ones(size(train,2)/2,1)',2*ones(size(train,2)/2,1)')';
