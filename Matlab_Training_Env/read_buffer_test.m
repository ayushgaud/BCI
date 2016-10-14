function [] = read_buffer_test(mdl,trial_duration)
%Function to predict output based on trained model


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
 %sampling rate
f_len=250;
f_overlap=10;
cue_images={'foot.png','right.png','left.png'};


%&Set Figure
figure;
x0=100;y0=100;width=400;height=400;
set(gcf,'units','points','position',[x0,y0,width,height])
imshow(imresize(imread('go.png'),[width height]));
    
%%Begin Trial
for n=1:trial_duration
    x=zeros(5*f_len,6);
      % determine number of samples available in buffer
      temp=[];
    while(size(temp,1)<f_len)
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
        temp=dat';    
     end
    end
        x=circshift(x,[-250,0]);
        x(end-f_len+1:end,:)=temp;
        

        Features=zeros((size(x,1)/f_overlap-(f_len/f_overlap)),15*size(x,2));
        for i=1:size(x,1)/f_overlap-(f_len/f_overlap)
            Window=x(f_overlap*(i-1)+1:f_overlap*(i-1)+f_len,:);
            temp=abs(fft(Window,250));
            for feat=1:15
                Features(i,1+6*(feat-1):6*feat)=mean(temp(5+(feat*2)-1:5+feat*2,:));
            end
        end
        %figure;plot(temp(6:40))
        [predClass,classifScore] = mdl.predict(Features)
        md=mode(str2num(cell2mat(predClass)));
        figure(1);imshow(imresize(imread(cue_images{md}),[width height]));
        tp=sum(classifScore(str2num(cell2mat(predClass))==md,md))/sum(str2num(cell2mat(predClass))==md);
        figure(2);bar(tp);
end
end