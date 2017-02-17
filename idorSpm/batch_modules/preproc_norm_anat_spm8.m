%%%%%%%Coregristration anatomy to mean, estimate only %%%%%%%%%%%%

clear matlabbatch;
coregristration_ana_mean
files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_COREG_ANA_MEAN.mat');
files(end).matlabbatch = matlabbatch;
files(end).message = sprintf( 'Coregristration anatomy to mean for subject: %s\n%s\n', name_subj{i}, preproc_dir);

%%%%%%%Coregristration mean and all images to T1 (in order to move images to the MNI space)%%%%%%%%%%%%

clear matlabbatch;
coregistration_T1
files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_COREG_T1.mat');
files(end).matlabbatch = matlabbatch;
files(end).message = sprintf( 'Coregistration all images to T1 (MNI space) for subject: %s\n%s\n', name_subj{i}, preproc_dir);

normpdf = correctFilename( sprintf('cor_%s.pdf', name_subj{i} ) );
files(end).execs = {'idor.utils.ps2pdf_alt( ''psfile'', [''spm_'' datestr(now, ''yyyymmmdd'') ''.ps''], ''pdffile'', ''' normpdf ''');'};

%%%%%%% Segmentation anatomy %%%%%%%%%%%%

clear matlabbatch;
segmentation
files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_SEGMENTATION.mat');
files(end).matlabbatch = matlabbatch;
files(end).message = sprintf( 'Segmentation anatomy for subject: %s\n%s\n', name_subj{i}, preproc_dir);

%%%%%%% Normalization functional images (using parameters from segmentation) %%%%%%%%%%%%

clear matlabbatch;
normalize_functional
files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_NORM_FUNCT.mat');
files(end).matlabbatch = matlabbatch;
files(end).message = sprintf( 'Normalization functional images for subject: %s\n%s\n', name_subj{i}, preproc_dir);

%%%%%%% Normalization anatomy (using parameters from segmentation) %%%%%%%%%%%%
clear matlabbatch;
normalize_structural
files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_NORM_STRUCT.mat');
files(end).matlabbatch = matlabbatch;
files(end).message = sprintf( 'Normalization structural images for subject: %s\n%s\n', name_subj{i}, preproc_dir );

