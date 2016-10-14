function [ Features ] = acquireData( COM )
%%Function to acquire data in real time

Channel_length=evalin('base','Channel_length');
Training_samples=evalin('base','Training_samples');
Hd=evalin('base','Hd');
Object=serialOpen(COM);

rawData=getData(Training_samples,Object); %To get initial 250 consicutive samples
serialClose(Object);
channelData=[rawData(:,2),rawData(:,3),rawData(:,5),rawData(:,6),rawData(:,8),rawData(:,9)]; %To select 6 channels

filtered_data=filter(Hd,channelData);

for k=1:Channel_length
    Features(:,k)=Create_feature(filtered_data(:,k));
end

Features=reshape(Features,size(Features,1),6);

end

