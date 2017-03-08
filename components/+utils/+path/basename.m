function [ basename ] = basename( file_path )
%BASENAME Returns filename with extension
%   Extracts directory of a path

[~, fname ext] = fileparts( file_path );
basename = [fname ext];

end

