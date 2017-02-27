function [f power] = fft_signal( data, fs )

x = data;
m = length(x);          % Window length
n = pow2(nextpow2(m)-1);  % Transform length
y = fft(x,n);           % DFT
f = (0:n-1)*(fs/n);     % Frequency range
power = y.*conj(y)/n;   % Power of the DFT%

end