function out = resolve_names( pattern )
% RESOLVE_NAMES - returns files/folders that can be found by the pattern
%
%
import utils.resolve_names;

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
    
    fullFind = fullfile( fileparts(baseDir), dirFs(k).name );
    %% Faz a varredura recursiva ou não
    if length(pts) > 1 && any(baseDir == '*')
        childFinds = resolve_names( fullfile( fullFind, pts{2:end} ) );
        if ~islogical(childFinds) && ~isempty(childFinds) 
            for n = 1:length( childFinds )
                finds{end+1} = childFinds{n};
            end
        end
    else
        finds{end+1} = fullFind;
    end
end
out = finds;