if ~(exist('spm','file'))
    addpath(genpath(fullfile(matlabroot, 'toolbox', 'spm8')));
    savepath;
end

p = mfilename('fullpath');
seps = strfind( p, filesep );
path_only = p(1:seps(end));

addpath(path_only)
addpath(fullfile(path_only, 'core'))
addpath(fullfile(path_only, 'projetos'))
addpath(fullfile(path_only, 'tests'))
addpath(fullfile(path_only, 'vendors'))