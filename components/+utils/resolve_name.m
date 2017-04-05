function filename = resolve_name(filename)
% RESOLVE_NAME - returns file/folder that can be found by the pattern
%   returns the first found

import utils.resolve_names;

if( ~exist(filename, 'file') )
    dirFs = resolve_names( filename );
    if( ~isempty(dirFs) )
        filename = dirFs{1};
    end
end