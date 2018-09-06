function filename = resolve_name(filename, full)
% RESOLVE_NAME - returns file/folder that can be found by the pattern
%   returns the first found

import utils.resolve_names;

if nargin < 2, full = true; end

if( ~exist(filename, 'file') )
    dirFs = resolve_names( filename, full );
    if( isempty(dirFs) || ~iscell(dirFs) )
        filename =  [];
    else
        filename = dirFs{1};
    end
end