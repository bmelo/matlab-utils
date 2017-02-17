matlabbatch{1}.spm.spatial.coreg.estimate.ref = {fullfile(spm_dir,'templates/T1.nii,1')};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {fullfile( preproc_dir, 'ANAT', anat_file )};
matlabbatch{1}.spm.spatial.coreg.estimate.other = get_scans_concatenated( config, preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix, 'ar');
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];