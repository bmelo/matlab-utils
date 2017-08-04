function [ outstr ] = strjoin( strings, delimiter )
%STRJOIN - merge strings using a delimiter
%   Detailed explanation goes here

if nargin<2, delimiter = ','; end

outstr = strings{1};
for k=2:length(strings)
    outstr = [outstr delimiter strings{k}];
end

end

