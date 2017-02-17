models = { 'MOV_CUE_AND_SQUEEZE_MOTOR' };
models = { 'MOV_EFFORT_SEP_CUE_AND_SQUEEZE' };
models = { 'MOV_EFFORT_SEP_CSO' };

%models( [1] ) = [];

for m=1:length(models)
    
model_name = models{m}

datadir = fullfile( '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL', model_name );

destdir = fullfile( '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIXED_EFFECT/CLEAN' , model_name );

subjs = [2 4 5 8 9 11 12 15];

for s=1:length(subjs)
    
    tmp = load( fullfile( datadir, sprintf('SUBJ%03i',subjs(s)),'BATCH_FIRST_LEVEL.mat' ) );
    
    if s == 1
        matlabbatch = tmp.matlabbatch;
    else
        nses = length(matlabbatch{1}.spm.stats.fmri_spec.sess);
        nsesB = length(tmp.matlabbatch{1}.spm.stats.fmri_spec.sess);
        inds = nses +1 : nses + nsesB;
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(inds) = tmp.matlabbatch{1}.spm.stats.fmri_spec.sess;
    end
    
end

tmp_destdir = fullfile( destdir, ['SUBJS' sprintf('_%i', subjs) ] );
if ~isdir( tmp_destdir ), mkdir( tmp_destdir ), end

outfile = fullfile( tmp_destdir, 'SPM.mat' );

matlabbatch{1}.spm.stats.fmri_spec.dir{1}   = tmp_destdir;
matlabbatch{2}.spm.stats.fmri_est.spmmat{1} = outfile;
    
tmp = load( fullfile( datadir, sprintf('SUBJ%03i',subjs(1)),'BATCH_CONTRAST.mat' ) );

tmp.matlabbatch{1}.spm.stats.con.spmmat{1} = outfile;

disp( ['RUNNING FIXED EFFECTS FOR SUBJECTS ' sprintf( ' %i', subjs ) ] );
save( fullfile( tmp_destdir, 'FIXED_FIRST_LEVEL.mat'), 'matlabbatch' );
spm_jobman('run',matlabbatch);

disp( ['RUNNING CONTRASTS FOR FIXED EFFECTS FOR SUBJECTS ' sprintf( ' %i', subjs ) ] );
matlabbatch = tmp.matlabbatch;
save( fullfile( tmp_destdir, 'FIXED_BATCH_CONTRAST.mat'), 'matlabbatch' );
spm_jobman('run',matlabbatch);

end