function update_docs()
% UPDATE_DOCS Function to update documentation for this library
curdir = pwd;
output = fullfile('./docs/html');

cd ..;
addpath( fullfile(pwd, '..', 'vendors', 'm2html') );
rmdir(output, 's');
m2html('mfiles', '.', 'htmldir', output, ...
    'recursive','on', 'global','on', ...
    'template','frame', 'index','menu');

cd(curdir);

end