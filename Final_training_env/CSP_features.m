function [feat_new,label,PTranspose]=CSP_features(training,Hd,PTranspose)
% d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,30,35,250);
% d.Stopband1Constrained = true; d.Astop1 = 1;
% d.Stopband2Constrained = true; d.Astop2 = 1;
% %d = fdesign.lowpass('Fp,Fst,Ap,Ast',40,45,1,40,250);
order=100;
Fs=250;
f_len=250;
f_overlap=10;
% d = fdesign.bandpass('N,Fp1,Fp2,Ap', 20, 8, 30, 1, 250);
% Hd = design(d);
   
if(nargin==2)
    classes={'class1','class2'};
    for class=1:2
        classes{class}=training((training(:,7)==class),1:6);
    end
    feat_new=zeros((length(classes{class})/f_overlap-(f_len/f_overlap))*2,size(classes{class},2)*9);
    PTranspose=zeros(size(classes{1},2),size(classes{1},2),9);
    %%Filter signal
    for num_banks=1:9
        tic
        d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',order,(num_banks*4)-1,num_banks*4,(num_banks+1)*4,((num_banks+1)*4)+1,Fs);
        Hd=design(d);
        for class=1:2
            for epoch=1:size(classes{class},1)/250
                classes{class}(250*(epoch-1)+1:250*epoch,:)=(detrend(classes{class}(250*(epoch-1)+1:250*epoch,:)));

            end
            classes{class}=filter(Hd,classes{class});
        end

    
    %%Compute CSP filter coefficients

    [PTranspose(:,:,num_banks)] = CSP(classes{1}',classes{2}');

    classtrain= horzcat(classes{1}',classes{2}');

    train = spatFilt(classtrain,PTranspose(:,:,num_banks),6)';

    for class=1:2
        classes{class}=train(1+(size(train,1)/2)*(class-1):(size(train,1)/2)*class,:);
    end



%%Computing Features

Features=zeros((length(classes{class})/f_overlap-(f_len/f_overlap))*2,size(classes{class},2));
        for class=1:2
            for i=1:length(classes{class})/f_overlap-(f_len/f_overlap)
                Window=classes{class}(f_overlap*(i-1)+1:f_overlap*(i-1)+f_len,:);
                Features(i+(length(classes{class})/f_overlap-(f_len/f_overlap))*(class-1),1:6)=log(1+mean(Window.^2));
            end
        end
    feat_new(:,(num_banks-1)*size(Features,2)+1:num_banks*size(Features,2))=Features;
    toc*(9-num_banks)
    for class=1:2
        classes{class}=training((training(:,7)==class),1:6);
    end
    end
    label=horzcat(ones(size(Features,1)/2,1)',2*ones(size(Features,1)/2,1)')';
    
end
if(nargin==3)
    feat_new=zeros((length(training)/f_overlap-(f_len/f_overlap)),size(training,2)*9);
    %%Filter signal
    for num_banks=1:9
        training_new=filter(Hd{num_banks},detrend(training));
        training_new = spatFilt(training_new',PTranspose(:,:,num_banks),6)';
        Features=zeros((length(training_new)/f_overlap-(f_len/f_overlap)),size(training_new,2));

        for i=1:length(training_new)/f_overlap-(f_len/f_overlap)
        Window=training_new(f_overlap*(i-1)+1:f_overlap*(i-1)+f_len,:);
        Features(i,1:6)=log(1+mean(Window.^2));
        label=[];
        end
        feat_new(:,(num_banks-1)*size(Features,2)+1:num_banks*size(Features,2))=Features;
    end
end
end
