function [Training_Data,model,P] = read_buffer(No_of_Trials,No_of_Classes,wait_for_cue,cue_time,trial_duration,end_duration)
%Function to train model
COM='COM1';
% cfg=[];
% % set the default configuration options
% if ~isfield(cfg, 'dataformat'),     cfg.dataformat = [];      end % default is detected automatically
% if ~isfield(cfg, 'headerformat'),   cfg.headerformat = [];    end % default is detected automatically
% if ~isfield(cfg, 'eventformat'),    cfg.eventformat = [];     end % default is detected automatically
% if ~isfield(cfg, 'blocksize'),      cfg.blocksize = 5;        end % in seconds
% if ~isfield(cfg, 'overlap'),        cfg.overlap = 0;          end % in seconds
% if ~isfield(cfg, 'channel'),        cfg.channel = 'all';      end
% if ~isfield(cfg, 'bufferdata'),     cfg.bufferdata = 'last';  end % first or last
% if ~isfield(cfg, 'readevent'),      cfg.readevent = 'no';     end % capture events?
% if ~isfield(cfg, 'jumptoeof'),      cfg.jumptoeof = 'no';     end % jump to end of file at initialization
% if ~isfield(cfg, 'demean'),         cfg.demean = 'yes';          end % baseline correction
% 
% if ~isfield(cfg, 'dataset') && ~isfield(cfg, 'header') && ~isfield(cfg, 'datafile')
%   cfg.dataset = 'buffer://localhost:1972';
% end
% 
% % translate dataset into datafile+headerfile
% cfg = ft_checkconfig(cfg, 'dataset2files', 'yes');
% cfg = ft_checkconfig(cfg, 'required', {'datafile' 'headerfile'});
% 
% % ensure that the persistent variables related to caching are cleared
% clear ft_read_header
% 
% % start by reading the header from the realtime buffer
% hdr = ft_read_header(cfg.headerfile, 'headerformat', cfg.headerformat, 'cache', true, 'retry', true);
% 
% % define a subset of channels for reading
% cfg.channel = ft_channelselection(cfg.channel, hdr.label);
% chanindx    = match_str(hdr.label, cfg.channel);
% nchan       = length(chanindx);
% if nchan==0
%   error('no channels were selected');
% end
% 
% % determine the size of blocks to process
% blocksize = round(cfg.blocksize * hdr.Fs);
% count = 0;

instrreset
if(ispc)
    arduino = serial(COM, 'BaudRate', 500000);
elseif(isunix)
    arduino = serial('ttyUSB0', 'BaudRate', 500000);
end
arduino.BytesAvailableFcnCount = 1;
arduino.Timeout = 5;
fopen(arduino);
pause(2);
fprintf(arduino,'x');
pause(0.1);
if (arduino.BytesAvailable > 0)
    disp(fscanf(arduino));
end
pause(4);
%Empty read 100 lines
for n=1:100     
    fgets(arduino);
end
fprintf('Device Initialized\n');

%%Initilize variables
fs=250;  %sampling rate
Trial_samples=fs*trial_duration;
Training_Data=zeros(No_of_Trials*No_of_Classes*(Trial_samples-fs),7);%To delete 1 second of initial data

%%To Generate random sequence for training
sequence=[];
cue_images={'right.png','left.png','foot.png'};
for n=1:No_of_Trials
    sequence=cat(2,sequence,randperm(No_of_Classes));
end
%&Set Figure
figure;
x0=100;y0=100;width=400;height=400;
set(gcf,'units','points','position',[x0,y0,width,height])

%%Begin Trial
for n=1:No_of_Trials*No_of_Classes
    fprintf('Trial No. %d of %d\n',n,No_of_Trials*No_of_Classes);
    imshow(imresize(imread('start.jpg'),[width height]));
    pause(wait_for_cue);
    imshow(imresize(imread(cue_images{sequence(n)}),[width height]));
    pause(cue_time);
    imshow(imresize(imread('go.png'),[width height]));
    tic
%     hdr = ft_read_header(cfg.headerfile, 'headerformat', cfg.headerformat, 'cache', true);
%     begsample=hdr.nSamples;
%     % see whether new samples are available
%     pause(trial_duration);
%     hdr = ft_read_header(cfg.headerfile, 'headerformat', cfg.headerformat, 'cache', true);
%     if(hdr.nSamples>=begsample+blocksize)
%         endsample=begsample+blocksize;
%     else
%         pause(trial_duration/10);
%         hdr = ft_read_header(cfg.headerfile, 'headerformat', cfg.headerformat, 'cache', true);
%         endsample=begsample+blocksize;
%     end
%     % remember up to where the data was read
%     count       = count + 1;
%     fprintf('processing segment %d from sample %d to %d\n', count, begsample, endsample);
% 
%     % read data segment from buffer
%     dat = ft_read_data(cfg.datafile, 'header', hdr, 'dataformat', cfg.dataformat, 'begsample', begsample+1, 'endsample', endsample, 'chanindx', chanindx, 'checkboundary', false);
%     temp=dat';
    %%Initialize the device for data acquisition
    t=1;
    x=[];
    while(t <= Trial_samples )  

       a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
       a = textscan(a, '%f', 'Delimiter',',');
       a = cell2mat(a)';
       if(size(a,2)==9)
                x(t,:)=[a(2),a(3),a(5),a(6),a(8),a(9)];  %To select 6 channels and last column for sequence type 
       else
           if(t>1)
                x(t,:)=x(t-1,:);
           end
       end
       t=t+1;
       %assignin('base','x',x);
    end
    x=x(fs+1:end,:);
    Training_Data((n-1)*size(x,1)+1:(n)*size(x,1),:)=[x,repmat(sequence(n),Trial_samples-fs,1)];
    imshow(imresize(imread('end.png'),[width height]));
    pause(end_duration);
end
     Hd_banks=Generate_filters(9,100,250);
     [Features,label,P]=CSP_features(Training_Data,Hd_banks);
     model=classify_svm(Features,label);
    %model=[];P=[];
end