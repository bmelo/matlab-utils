function [ fname ] = basename( file_path )
%BASENAME Returns filename with extension
%   Extracts filename (with extension) of a path

[~, fname ext] = fileparts( file_path );
fname = [fname ext];

end

