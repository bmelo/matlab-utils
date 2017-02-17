function init()
    p = mfilename('fullpath');
    seps = strfind( p, filesep );
    path_only = p(1:seps(end));

    addpath(path_only);
    addpathsubdirs(path_only, {'core', 'MASKS', 'model_definitions', 'regressor_utils', 'utils'});
    addpath( genpath( fullfile( path_only, 'batch_modules' ) ) );
end

function addpathsubdirs( pathD, subdirs)
    for k=1:length(subdirs)
        addpath(fullfile(pathD,subdirs{k}));
    end
end