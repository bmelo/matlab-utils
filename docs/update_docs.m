function update_docs()
% UPDATE_DOCS Function to update documentation for this library
curdir = pwd;

cd ../..
addpath( fullfile(pwd, 'm2html') );
m2html('mfiles', 'matlab-utils', 'htmldir','matlab-utils/docs/html', ...
    'recursive','on', 'global','on', ...
    'template','frame', 'index','menu');

cd(curdir);

end