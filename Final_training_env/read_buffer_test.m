function [] = read_buffer_test(model,P,trial_duration)
%Function to predict output based on trained model
instrreset
% wheelchair = serial('COM16', 'BaudRate', 115200);
% wheelchair.BytesAvailableFcnCount = 1;
% wheelchair.Timeout = 5;
% fopen(wheelchair);
% pause(2);

COM='COM1';

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
pause(4);
%Empty read 100 lines
for n=1:100     
    fgets(arduino);
end
fprintf('Device Initialized\n');

d = fdesign.bandpass('N,Fp1,Fp2,Ap', 20, 8, 30, 1, 250);
Hd = design(d);
Hd_banks=Generate_filters(9,100,250);

% cfg=[];
% % set the default configuration options
% if ~isfield(cfg, 'dataformat'),     cfg.dataformat = [];      end % default is detected automatically
% if ~isfield(cfg, 'headerformat'),   cfg.headerformat = [];    end % default is detected automatically
% if ~isfield(cfg, 'eventformat'),    cfg.eventformat = [];     end % default is detected automatically
% if ~isfield(cfg, 'blocksize'),      cfg.blocksize = 1;        end % in seconds
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the general BCI loop where realtime incoming data is handled
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Initilize variables
 %sampling rate
f_len=250;
f_overlap=250;
cue_images={'foot.png','right.png','left.png'};


%&Set Figure
% figure(1);
% imshow(imread('both.png'));
% x0=100;y0=100;width=800;height=400;
% set(figure(1),'units','points','position',[x0,y0,width,height])

tic    
%%Begin Trial
x=zeros(2*f_len,6);
for n=1:trial_duration*f_len/f_overlap
        t=1;
        temp=[];
    while(t <= f_overlap )  

       a =fgets(arduino); %reads the data from the serial port and stores it to the matrix a
       a = textscan(a, '%f', 'Delimiter',',');
       a = cell2mat(a)';
       if(size(a,2)==9)
                temp(t,:)=[a(2),a(3),a(5),a(6),a(8),a(9)];  %To select 6 channels and last column for sequence type 
       else
           if(t>1)
                temp(t,:)=temp(t-1,:);
           end
       end
       t=t+1;
       %assignin('base','x',x);
    end
    x=circshift(x,[-f_overlap,0]);
    x(end-f_overlap+1:end,:)=temp;
    if(mean(mean(filter(Hd,detrend(temp)).^2))>=2e10);
       mean(mean(filter(Hd,detrend(temp)).^2))
%        fprintf(wheelchair,'100f');
%        pause(1);
    else
        
        [Features,~,~]=CSP_features(x,Hd_banks,P);
    %     [y]=svmclassify(model,Features);
    %     figure(2);
         [y,score]=predict(model,Features);
    %   
        a=mean((score(:,1)))
         barh(a*10);
%         if a>2
%             fprintf(wheelchair,'100r');
%         elseif a<-2
%             fprintf(wheelchair,'100l');
%         end
        axis([-10,10,0.8,1]);
        set(figure(2),'position',[135,10,1065,100])
        drawnow;
    end
end
end