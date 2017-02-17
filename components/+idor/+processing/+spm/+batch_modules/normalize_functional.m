matlabbatch{1}.spm.spatial.normalise.write.subj.matname = { fullfile( preproc_dir, 'ANAT', [ anat_file(1:end-4) '_seg_sn.mat']) };
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = get_scans_concatenated( preproc_dir, nrun, nvol, ['ar' run_file_prefix], run_file_suffix );
matlabbatch{1}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.write.roptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.roptions.vox = [3 3 3];
matlabbatch{1}.spm.spatial.normalise.write.roptions.interp = 5;
matlabbatch{1}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = 'w';
