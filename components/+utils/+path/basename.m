function [ fname ] = basename( file_path, with_ext )
%BASENAME Returns filename with extension
%   Extracts filename (with extension) of a path
if nargin < 2, with_ext=1; end

[~, fname, ext] = fileparts( file_path );
if with_ext
    fname = [fname ext];
end

end

