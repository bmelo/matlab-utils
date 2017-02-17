matlabbatch{1}.spm.spatial.normalise.write.subj.matname = { fullfile( preproc_dir, 'ANAT', [ anat_file(1:end-4) '_seg_sn.mat']) };
matlabbatch{1}.spm.spatial.normalise.write.subj.resample{1,1} = fullfile( preproc_dir, 'ANAT', anat_file );
matlabbatch{1}.spm.spatial.normalise.write.subj.resample{2,1} = fullfile( preproc_dir, 'ANAT', ['c1' anat_file] );
matlabbatch{1}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.write.roptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.roptions.vox = [1 1 1];
matlabbatch{1}.spm.spatial.normalise.write.roptions.interp = 5;
matlabbatch{1}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = 'w';
