function [Features,label]=psd_features(training)
d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');

classes={'class1','class2','class3'};

for class=1:3
    classes{class}=training((training(:,7)==class),1:6);
end
%%Filter signal
for class=1:3
    for epoch=1:size(classes{class},1)/1000
        classes{class}(1000*(epoch-1)+1:1000*epoch,:)=normc(filter(Hd,detrend(classes{class}(1000*(epoch-1)+1:1000*epoch,:))));
        
    end
end
%%Compute CSP filter coefficients
% co_mat=zeros(3,6,6);
% classtrain=[];
% for class=1:3
%     co_mat(class,:,:)=cov(classes{class});
% end
% P=MulticlassCSP(co_mat,6);

%%Computing Features
f_len=250;
f_overlap=10;

Features=zeros((length(classes{class})/f_overlap-(f_len/f_overlap))*3,15*size(classes{class},2));
close all
tic
for class=1:3
    for i=1:length(classes{class})/f_overlap-(f_len/f_overlap)
        Window=classes{class}(f_overlap*(i-1)+1:f_overlap*(i-1)+f_len,:);
        temp=abs(fft(Window,250));
        for feat=1:15
            Features(i+(length(classes{class})/f_overlap-(f_len/f_overlap))*(class-1),1+6*(feat-1):6*feat)=mean(temp(5+(feat*2)-1:5+feat*2,:));
        end
    end
    toc
end

    
label=horzcat(ones(size(Features,1)/3,1)',2*ones(size(Features,1)/3,1)',3*ones(size(Features,1)/3,1)')';

%%plot
% for class=1:3
%     figure;
%     temp=abs(fft(classes{class},250));
%     plot(temp(1:40,:));
% end
end