function [ out ] = system_echo( varargin )
%SYSTEM Summary of this function goes here
%   Detailed explanation goes here

cmd = varargin{1};
disp(cmd);
out = system(varargin{:});

end

