function[] = write_buffer(COM)

cfg = [];
if ~isfield(cfg, 'target'),               cfg.target = [];                                  end
if ~isfield(cfg.target, 'headerformat'),  cfg.target.headerformat = [];                     end % default is detected automatically
if ~isfield(cfg.target, 'dataformat'),    cfg.target.dataformat = [];                       end % default is detected automatically
if ~isfield(cfg.target, 'datafile'),      cfg.target.datafile = 'buffer://localhost:1972';  end
if ~isfield(cfg, 'blocksize'),            cfg.blocksize = 1;                                end % in seconds
if ~isfield(cfg, 'channel'),              cfg.channel = ft_senslabel('eeg1020');            end
if ~isfield(cfg, 'fsample'),              cfg.fsample = 250;                                end % in Hz
if ~isfield(cfg, 'speed'),                cfg.speed = 1 ;

cfg.channel        = {'CPz', 'POz', 'Oz','Iz','O1','O2'};                         % list with channel "names"
cfg.blocksize      = 1;                           % seconds
cfg.fsample        = 250;
hdr.Fs          = 250;
hdr.nChans      = 6;
hdr.nSamples = 0;
hdr.nSamplesPre = 0;
hdr.label       = cfg.channel;
chanindx        = 1:6;
count = 0;

instrreset
instrreset
arduino = serial(COM, 'BaudRate', 500000);
arduino.BytesAvailableFcnCount = 1;
arduino.Timeout = 5;
fopen(arduino);
pause(2);
fprintf(arduino,'x');
pause(0.1);
if (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
pause(1);
tic
while(1)
t=1;
x=zeros(50,6);
while(t <= 50 )  
 
   a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
   a = textscan(a, '%f', 'Delimiter',',');
   a = cell2mat(a)';
   if(size(a,2)==9)
            x(t,:)=[a(2),a(3),a(5),a(6),a(8),a(9)];  %To select 6 channels  
   else
       if(t>1)
            x(t,:)=x(t-1,:);
       end
   end
   t=t+1;
   a=[];  %Clear the buffer
   assignin('base','x',x);
end
x=x';
if ~isempty(x)
    count = count + 1;
    fprintf('writing %d channels, %d samples\n', size(x,1), size(x,2));
    if count==1
      % flush the file, write the header and subsequently write the data segment
      ft_write_data(cfg.target.datafile, x(chanindx,:), 'header', hdr, 'dataformat', cfg.target.dataformat, 'chanindx', chanindx, 'append', false);
    else
      % write the data segment
      ft_write_data(cfg.target.datafile, x(chanindx,:), 'header', hdr, 'dataformat', cfg.target.dataformat, 'chanindx', chanindx, 'append', true);
    end
end
end
toc
fprintf(arduino,'s');
serialClose(arduino);
end