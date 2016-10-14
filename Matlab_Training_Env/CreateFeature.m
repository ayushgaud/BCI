Features=zeros(size(training,1)/250,24);
path(path,'.\SVM');
temp1=[];
for h=1:size(training,1)/250
    for channel=1:6
        temp=((st(training(250*(h-1)+1:250*h,channel))));
        temp2=pec(temp(2:40,:),5,1);
        Features(h,(5*channel-4):5*channel)=[mean(temp2),max(temp2),mean(sqrt(std(temp(2:40,:)))),max(sqrt(std(temp(2:40,:)))),min(sqrt(std(temp(2:40,:))))];
    end
    h
    temp1=[temp1;detrend(training(250*(h-1)+1:250*h,1:end-1),0)];
    Features(h,5*channel+1)=training(250*h,channel+1);
end
model=TrainSVM(Features(:,1:end-1),Features(:,end));
a=simlssvm(model,Features(:,1:end-1));
