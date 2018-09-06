function out = resolve_names( pattern, full )
% RESOLVE_NAMES - returns files/folders that can be found by the pattern
%
%
import utils.resolve_names;

if nargin < 2, full = true; end

pts = regexp(pattern, '(?<=\*[^/]*)/(?=.)', 'split');
baseDir = pts{1};
dirFs = dir( baseDir );
finds = {};

if isempty(dirFs)
    out = [];
    return;
end

for k=1:length(dirFs)
    % Ignoring not folders
    if( any( strcmp( dirFs(k).name, {'.', '..'} ) ) )
        continue;
    end
    
    fname = dirFs(k).name;
    if full
        fname = fullfile( fileparts(baseDir), fname );
    end
    %% Faz a varredura recursiva ou não
    if length(pts) > 1 && any(baseDir == '*')
        childFinds = resolve_names( fullfile( fname, pts{2:end} ) );
        if ~islogical(childFinds) && ~isempty(childFinds) 
            for n = 1:length( childFinds )
                finds{end+1} = childFinds{n};
            end
        end
    else
        finds{end+1} = fname;
    end
end
out = finds;