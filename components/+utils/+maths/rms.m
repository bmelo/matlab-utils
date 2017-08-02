function [ rms_val ] = rms( data, dir )
%RMS - Do RMS calculation
%   Inputs: data, dir (dimension, default 1)
if nargin < 2, dir = 1; end

n = size( data, dir);
rms_val = sqrt( sum( data.^2, dir ) / n );

end

