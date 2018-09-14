run('vendors/matlab-utils/libsetup.m');
import neuro.art.art_batch

datadir = '/dados1/PROJETOS/PRJ1708_TDAH_OBESO/03_PROCS/PROC_DATA/fMRI/STATS/FIRST_LEVEL/MOV_MODEL_4';
artdir  = '/dados1/PROJETOS/PRJ1708_TDAH_OBESO/03_PROCS/PROC_DATA/fMRI/STATS/ART_6PARAMS/MODEL_4';

subdir = [];

subjs = 1:48;
ignoreSubjs = [22 39 42];
for s = setdiff(subjs, ignoreSubjs)
    name = sprintf('S1708%03d', s );
    disp(fullfile(datadir, name, '*/SPM.mat'))
    spmFiles = utils.resolve_names( fullfile(datadir, name, 'SPM.mat') );
    disp(spmFiles)
    for spmFile = spmFiles
        spmFile = spmFile{1};
        [~, subjdir] = fileparts( fileparts( spmFile ) );
        artsubdir = fullfile( artdir, subjdir);
        
        fprintf( '\n### %s ###\n', subjdir);
        fprintf( '   %s\n\n', subjdir, spmFile );
        
        art_batch( {spmFile}, {artsubdir}, s, 3, 9 );
        %   art_batch_IDOR( {spmFile}, {artsubdir}, sid, 2, 9 );
        
        close all
    end
end