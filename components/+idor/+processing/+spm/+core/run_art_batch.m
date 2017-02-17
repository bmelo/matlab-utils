arttooldir = '/usr/local/MATLAB/toolbox_IDOR/art_IDOR';
addpath( arttooldir );

datadir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO';
artdir  = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/ART';

subdir = dir( fullfile( datadir, 'SUBJ015*' ) );

for k=1:length(subdir)
   
    spm_file = fullfile(datadir, subdir(k).name, 'SPM.mat');
    artsubdir = fullfile(artdir, subdir(k).name );
    
    sid = num2str( subdir(k).name(5:end) );
    
    art_batch_IDOR( {spm_file}, {artsubdir}, sid, 3, 9 ); 
    
    art_batch_IDOR( {spm_file}, {artsubdir}, sid, 2, 9 ); 
    
end

rmpath( arttooldir );