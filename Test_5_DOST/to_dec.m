function [dec] = to_dec(raw)

dec=double(zeros(raw(2)/4,1));

for j=1:raw(2)/4
    byte=zeros(4,1);
    for i=1:4
        byte(i)=raw(4*(j-1)+i);
    end
    dec(j)=bitor(bitor(bitshift(double(byte(3)),16),bitshift(double(byte(2)),8)),double(byte(1)));
end
gain=12;
V_ref=4.5;
uVpercount=(V_ref/(pow2(2,23)-1)/gain)*1000000;
dec=dec.*uVpercount;
end