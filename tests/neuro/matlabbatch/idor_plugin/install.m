%{
% Author: Bruno Melo (bruno.raphael@gmail.com)
% Institution: D'Or Institute for Research and Education (IDOR)
% Site: www.idor.org
% License: Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0) 
% Date: 21-dec-2012
%}

matlabbatchDir = fileparts( which('cfg_ui') );
if( isempty( matlabbatchDir ) )
    disp('Matlabbatch not founded! Installation Aborted.');
    return;
end

dirIdorApp = fullfile( matlabbatchDir, 'idor_app' );
if( ~exist(dirIdorApp, 'dir') )
    mkdir( dirIdorApp );
end
if( ~any(strfind(lower(path), lower(dirIdorApp))) )
    addpath(dirIdorApp, '-end');
    savepath;
end
instDir = fileparts(which('cfg_idor_pause.m'));
if ~strcmp(instDir, dirIdorApp)
    copyfile(fullfile(instDir, '*.m'), dirIdorApp);
end

cfg_util('addapp', 'cfg_idor');
cd ..;
cfg_util('initcfg');

disp('IDOR apps for matlabbatch installed!');