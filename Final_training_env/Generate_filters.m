function [ Hd ] = Generate_filters( No_of_filt,order,Fs)
%Program to generate bankof filters
tic
for num_banks=1:No_of_filt
        d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',order,(num_banks*4)-1,num_banks*4,(num_banks+1)*4,((num_banks+1)*4)+1,Fs);
        Hd{num_banks}=design(d);
end
toc
end

