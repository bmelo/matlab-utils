%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%%
matlabbatch{1}.spm.spatial.smooth.data = get_scans_concatenated( preproc_dir, nrun, nvol, ['war' run_file_prefix], run_file_suffix );
matlabbatch{1}.spm.spatial.smooth.fwhm = smooth;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
