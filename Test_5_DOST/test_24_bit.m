function test_24_bit(cfg)


instrreset

arduino=serial('COM1','BaudRate',115200);
set(arduino, 'InputBufferSize', 256); %number of bytes in inout buffer
fopen(arduino);
%headers

raw=[];
packetsize = 39;

raw = cat(2, raw, rem);

raw=fread(arduino,75,'uint8');


begbyte   = find(raw(1:end-1)==hex2dec('c0') & raw(2:end)==hex2dec('a0')) ;
begbyte   = begbyte(1)+1;
endbyte   = begbyte+packetsize;

% trim the junk at the beginning
rem = raw(endbyte+1:end);
raw = raw(begbyte:endbyte-1);
while(1)


temp=fread(arduino,77-length(raw),'uint8');
raw = cat(1, rem, temp);

if ~isa(raw, 'uint8')
  raw = uint8(raw);
end

begbyte   = find(raw(1:end-1)==hex2dec('c0') & raw(2:end)==hex2dec('a0')) ;
begbyte   = begbyte(1)+1;
endbyte   = begbyte+packetsize;

% trim the junk at the beginning
rem = raw(endbyte+1:end);
raw = raw(begbyte:endbyte-1);

dat=to_dec(raw);

end
end