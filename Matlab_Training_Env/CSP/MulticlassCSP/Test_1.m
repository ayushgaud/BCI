load('TrainingData.mat');
path(path,'C:\Users\Ayush\OneDrive\Documents\BCI\Matlab_Training_Env/SVM');

d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');

% for epoch=1:size(TrainingData,1)/512
%    TrainingData(1+512*(epoch-1):512*(epoch),1:6)=normc(TrainingData(1+512*(epoch-1):512*(epoch),1:6).*repmat(kaiser(512,0.05),1,6));    
% end

class1=filter(Hd,detrend(TrainingData((TrainingData(:,7)==1),1:6)));
class2=filter(Hd,detrend(TrainingData((TrainingData(:,7)==2),1:6)));
class3=filter(Hd,detrend(TrainingData((TrainingData(:,7)==3),1:6)));

% a=zeros(400-5,30,3);
%     
%     a(:,:,1)=Create_feature(class1);
%     a(:,:,2)=Create_feature(class2);
%     a(:,:,3)=Create_feature(class3);
%     
% test=[a(:,:,1);a(:,:,2);a(:,:,3)];
% label=horzcat(ones(395,1)',2*ones(395,1)',3*ones(395,1)')';
co_mat=zeros(3,6,6);
co_mat(1,:,:)=cov(class1);
co_mat(2,:,:)=cov(class2);
co_mat(3,:,:)=cov(class3);

P=MulticlassCSP(co_mat,6);

classtrain=horzcat(class1',class2',class3');
train=spatFilt(classtrain,P,2)';
feat=zeros(35,6);
for iter=1:3
    temp=abs(fft(train(1+size(class1,1)*(iter-1):size(class1,1)*(iter),:),512));
    feat(1+35*(iter-1):35*iter,:)=temp(6:40,:);
end

label=horzcat(ones(size(feat,1)/3,1)',2*ones(size(feat,1)/3,1)',3*ones(size(feat,1)/3,1)')';
model=TrainSVM(feat,label);

mdl=fitcecoc(feat,label);
fprintf('Classifier Trained with accuracy %d\n',sum(predict(mdl,feat)==label)/size(feat,1)*100);

feat_new=zeros(35*size(train,1)/512,6);
for epoch=1:size(train,1)/512
    temp=abs(fft(train(1+512*(epoch-1):512*(epoch),:),250));
    feat_new(35*(epoch-1)+1:35*epoch,:)=temp(6:40,:);
end
% feat_new=feat_new';
label_new=horzcat(ones(size(feat_new,1)/3,1)',2*ones(size(feat_new,1)/3,1)',3*ones(size(feat_new,1)/3,1)')';
model=TrainSVM(feat_new,label_new);