function print_fig( varargin )
%PRINT_FIG Print figure using function print
%   Detailed explanation goes here

% Default parameters 
filename = varargin{1};
if ~ischar( filename )
    filename = varargin{2};
end

% Checking if dir exists
fdir = fileparts(filename);
if ~isempty(fdir) && ~isdir(fdir)
    mkdir(fdir);
end

[~, ~, ext] = fileparts(filename);
varargin{end+1} = ['-d' strrep(ext,'.','')];

% Generating image
print(varargin{:});

end

