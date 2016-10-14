function [Training_Data] = read_buffer(No_of_Trials,No_of_Classes,wait_for_cue,cue_time,trial_duration,end_duration)
%Function to predict output based on trained model

x=[];
cfg=[];
% set the default configuration options
if ~isfield(cfg, 'dataformat'),     cfg.dataformat = [];      end % default is detected automatically
if ~isfield(cfg, 'headerformat'),   cfg.headerformat = [];    end % default is detected automatically
if ~isfield(cfg, 'eventformat'),    cfg.eventformat = [];     end % default is detected automatically
if ~isfield(cfg, 'blocksize'),      cfg.blocksize = 1;        end % in seconds
if ~isfield(cfg, 'overlap'),        cfg.overlap = 0;          end % in seconds
if ~isfield(cfg, 'channel'),        cfg.channel = 'all';      end
if ~isfield(cfg, 'bufferdata'),     cfg.bufferdata = 'last';  end % first or last
if ~isfield(cfg, 'readevent'),      cfg.readevent = 'no';     end % capture events?
if ~isfield(cfg, 'jumptoeof'),      cfg.jumptoeof = 'no';     end % jump to end of file at initialization
if ~isfield(cfg, 'demean'),         cfg.demean = 'yes';          end % baseline correction

if ~isfield(cfg, 'dataset') && ~isfield(cfg, 'header') && ~isfield(cfg, 'datafile')
  cfg.dataset = 'buffer://localhost:1972';
end

% translate dataset into datafile+headerfile
cfg = ft_checkconfig(cfg, 'dataset2files', 'yes');
cfg = ft_checkconfig(cfg, 'required', {'datafile' 'headerfile'});

% ensure that the persistent variables related to caching are cleared
clear ft_read_header

% start by reading the header from the realtime buffer
hdr = ft_read_header(cfg.headerfile, 'headerformat', cfg.headerformat, 'cache', true, 'retry', true);

% define a subset of channels for reading
cfg.channel = ft_channelselection(cfg.channel, hdr.label);
chanindx    = match_str(hdr.label, cfg.channel);
nchan       = length(chanindx);
if nchan==0
  error('no channels were selected');
end

% determine the size of blocks to process
blocksize = round(cfg.blocksize * hdr.Fs);
overlap   = round(cfg.overlap*hdr.Fs);

if strcmp(cfg.jumptoeof, 'yes')
  prevSample = hdr.nSamples * hdr.nTrials;
else
  prevSample = 0;
end
count = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the general BCI loop where realtime incoming data is handled
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Initilize variables
fs=250;  %sampling rate
Trial_samples=fs*trial_duration;
Training_Data=zeros(No_of_Trials*No_of_Classes*(Trial_samples-fs),7);%To delete 1 second of initial data

%%To Generate random sequence for training
sequence=[];
cue_images={'foot.png','right.png','left.png'};
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
    imshow(imresize(imread('go.png'),[width height]));
    pause(cue_time);
    imshow(imresize(imread(cue_images{sequence(n)}),[width height]));
    
    t=1;
    x=zeros(Trial_samples-fs,7);
      % determine number of samples available in buffer
      temp=[];
    while(size(temp,1)~=Trial_samples)
        hdr = ft_read_header(cfg.headerfile, 'headerformat', cfg.headerformat, 'cache', true);

      % see whether new samples are available
      newsamples = (hdr.nSamples*hdr.nTrials-prevSample);

      if newsamples>=blocksize

        % determine the samples to process
        if strcmp(cfg.bufferdata, 'last')
          begsample  = hdr.nSamples*hdr.nTrials - blocksize + 1;
          endsample  = hdr.nSamples*hdr.nTrials;
        elseif strcmp(cfg.bufferdata, 'first')
          begsample  = prevSample+1;
          endsample  = prevSample+blocksize ;
        else
          error('unsupported value for cfg.bufferdata');
        end

        % this allows overlapping data segments
        if overlap && (begsample>overlap)
          begsample = begsample - overlap;
          endsample = endsample - overlap;
        end

        % remember up to where the data was read
        prevSample  = endsample;
        count       = count + 1;
        fprintf('processing segment %d from sample %d to %d\n', count, begsample, endsample);

        % read data segment from buffer
        dat = ft_read_data(cfg.datafile, 'header', hdr, 'dataformat', cfg.dataformat, 'begsample', begsample, 'endsample', endsample, 'chanindx', chanindx, 'checkboundary', false);
        temp=[temp;dat'];    
        end
    end
        x=temp(fs+1:end,:);
        Training_Data((n-1)*size(x)+1:(n)*size(x),:)=[x,repmat(sequence(n),Trial_samples-fs,1)];
        imshow(imresize(imread('end.png'),[width height]));
        pause(end_duration);
    end
end