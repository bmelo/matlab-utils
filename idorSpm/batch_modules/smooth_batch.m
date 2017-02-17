%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%%
matlabbatch{1}.spm.spatial.smooth.data = get_scans_concatenated( config, preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix, current_prefix );
matlabbatch{1}.spm.spatial.smooth.fwhm = smooth;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
