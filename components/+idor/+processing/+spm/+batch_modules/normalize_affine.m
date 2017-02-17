%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source = { get_mean_fMRI( preproc_dir, run_file_prefix, run_file_suffix ) };
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = get_scans_concatenated( preproc_dir, nrun, nvol, ['ar' run_file_prefix], run_file_suffix );

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template = {'/dados3/SOFTWARES/Blade/toolbox_IDOR/spm8/templates/EPI.nii,1'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = {'/dados3/SOFTWARES/Blade/toolbox_IDOR/spm8/apriori/brainmask.nii,1'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -50
                                                             78 76 85];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [3 3 3];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = 'w';
