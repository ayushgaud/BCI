function [ ] = readBuffer( model ,handles,no_of_tests)
%Function to predict output based on trained model
Hd=evalin('base','Hd');
wind=hanning(250);
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
tic
for l=1:no_of_tests

  % determine number of samples available in buffer
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

    if(size(x,2)~=250)
        x=[x dat];
        
    else
        data=filter(Hd,x');
        for k=1:6                               %Channel length = 6
            %data(:,k)=data(:,k).*wind;
            s_transformed=dost(data(:,k));
            Window(:,k) =(((std(s_transformed))))';
            plot(abs(s_transformed));
        end
        x=x(:,end-199:end);
        Xt=Window;
        Y=simlssvm(model,Xt);
        prediction= mode(Y);
        set(handles,'String',strcat('Output=',num2str(prediction),' Test Case No.=' ,num2str(l),''));
        drawnow();
    end
  end
end
toc
end