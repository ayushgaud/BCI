function [ Features ] = acquireData( Training_samples)
%%Function to acquire data in real time
Hd=evalin('base','Hd');
COM=evalin('base','COM');
Channel_length=evalin('base','Channel_length');
funList = {@getData,@Create_feature};
struct data1 data2
data1.x=Training_samples;
data2.x=Training_samples;
data1.y=COM;
data2.y=Hd;
data2.z=Channel_length;

data={data1 data2};
spmd 
    labBarrier
    funList{labindex}(data{labindex})
end

end

