function [ jsondecode ] = loadjson( filepath )
%LOADJSON Summary of this function goes here
%   Detailed explanation goes here

% Removing index for volumes used by SPM
filepath = regexprep(filepath, '(,\d)*$', '');

% Removing file extension
filepath = regexprep(filepath, '\.\w+(\.gz|zip|rar|7z)*$', '');

% Extracting data (jsonlab library)
jsondecode = loadjson( [filepath '.json'] );

end

