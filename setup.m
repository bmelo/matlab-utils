function setup()

fdir = fileparts(mfilename('fullpath'));

addpath( fullfile(fdir,'components') );
utils.path.includeSubdirs( {'components', 'wrappers'} );