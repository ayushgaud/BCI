%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dost2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Returns the discrete-orthonormal Stockwell coefficients 
% of a given 2-dimensional signal. The signal should be a matrix of size (2^d x 2^k).
%
% Code by: U. Battisti and L. Riba 
% July, 02 2014
%
%
% References:
% [1]   R.G. Stockwell, "Why use the S-Transform", Pseudo-differential 
%       operators partial differential equations and time-frequency 
%       analysis, vol. 52 Fields Inst. Commun., pages 279--309, 
%       Amer. Math. Soc., Providence, RI 2007;
% [2]   R.G. Stockwell, "A basis for efficient representation of the
%       S-transform", Digital Signal Processing, 17: 371--393, 2007;
% [3]   Y. Wang and J. Orchard, "Fast-discrete orthonormal 
%       Stockwell transform", SISC: 31:4000--4012, 2009;
% [4]   Y. Wang, "Efficient Stockwell transform with applications to 
%       image processing", PhD thesis, University of Waterloo, 
%       Ontario Canada, 2011;
% [5]   U. Battisti, L.Riba, "Window-dependent bases for efficient 
%       representation of the Stockwell transform", 2014
%       http://arxiv.org/abs/1406.0513.
%
%
% Inputs:
% "input_signal" - matrix of data to be transformed.
%
% Outputs:
% "dost_coefficients"     - the matrix of the dost coefficients of 
%                           the given signal. It is a matrix of 
%                           complex numbers. The time-frequency meaning 
%                           of the coefficients and their arrangement is 
%                           explained in [4].
%
%
% Additional details:
% Copyright (c) by U. Battisti and L. Riba
% $Revision: 1.0 $  
% $Date: 2014/07/02  $


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dost2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% this function computes the dost coefficients of a 2-dimensional signal.
% It works using the dost on rows and columns.
%

function dost_coefficients = dost2(input_signal)

dost_coefficients = dost(dost(input_signal).').';

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% this function computes the 1-dimensional discrete orthonormal Stockwell 
% coefficients of a given time series
%
function dost_coefficients = dost(time_series)
% time_series should be a column vector, if not we take its transpose
if isrow(time_series) == 1
    time_series = time_series';
else
end    

% look at the number of rows of the input
size_time_series = size(time_series);
rows_time_series = size_time_series(1);

% inizialize the output (same output size as the input). 
dost_coefficients = zeros(size_time_series);

% partition of the frequency space, see details in the 
% band_width_partitioning function explanation below.
[number_of_freq_bands, band_widths] = band_width_partitioning(rows_time_series);

% compute the Fourier transform of the input using the fft. More details on
% this can be found on the Fourier function explanation below.
Fx = Fourier(time_series);

% compute the inverse Fourier transform of the cutted Fourier transform
% of the input signal 
counter = 0;
for ll = 1:number_of_freq_bands
    % choose the bandwidth you are interested in and call it 
    % frequency_width_cutter 
	frequency_width_cutter = band_widths(ll);
    % cut all the Fourier coefficients Fx in the frequency band 
    % counter + 1: counter + frequency_width_cutter
	cut_Fx = Fx(counter + 1: counter + frequency_width_cutter, : );
    % perform the inverse Fourier transform just on the selected frequency 
    % band. 
    % Notice that you have to pay attention on the length of the cut_Fx.
    % If it is just 1 we do not do nothing, otherwise we take the inverse 
    % Fourier transform. 
    if frequency_width_cutter == 1
            dost_coefficients(counter + 1 : counter + frequency_width_cutter , : ) = cut_Fx;
    else        
        dost_coefficients(counter + 1 : counter + frequency_width_cutter , : ) = iFourier(cut_Fx);
    end
    % update the starting position for the band
    counter = counter + frequency_width_cutter;
end
%
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% this function computes the Fourier transform of a given vector using the
% fft function built-in in MatLab. It produces a 
% normalized Fourier transform, i.e. norm(y) = norm(x). 
%
function y = Fourier(x)

% FFT fast Fourier transform
y = (1./sqrt(length(x))) .*  fftshift( fft( ifftshift(x) ) );

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iFourier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% this function computes the inverse Fourier transform of a given vector 
% using the ifft function built-in in MatLab. It produces a 
% normalized output, i.e. norm(y) = norm(x).
%
function y = iFourier(x)

% iFFT inverse fast Fourier transform
y = sqrt(length(x)) .* fftshift( ifft( ifftshift(x) ) );

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% band_width_partitioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dyadic partioning of the frequencies, example:
% samples = 16,
% number_of_freq_band = 10;
% band_widths = [1, 4, 2, 1, 1, 1, 2, 4].
% 
% Inputs:
% "samples" - length of the 1-dimensional signal we are analyzing;
%
% Outputs:
% "number_of_freq_bands"  - number of different frequency band on which we 
%                           are partitioning the time-frequency space; 
% "band_widths"           - vector (of length number_of_freq_bands) of all 
%                           the frequency bandwidths. The bandwidths are
%                           ordered from negative to positive frequencies.
%
function [number_of_freq_bands, band_widths] = band_width_partitioning(samples)

max_band_width_exponent = log2(samples)-2;
positive_band_width_exponents = 0:max_band_width_exponent;
band_width_powers =[0,fliplr(positive_band_width_exponents),0,positive_band_width_exponents];

band_widths = 2.^band_width_powers;
number_of_freq_bands = length(band_widths);
end


