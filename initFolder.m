function initFolder( dirRoot, rec )
if( ~exist('rec', 'var') ); rec = false; end;

addpath( dirRoot );
if( exist( fullfile(dirRoot, 'init.m'), 'file' ) )
    run( fullfile(dirRoot, 'init.m') );
end

end