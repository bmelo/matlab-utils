function mean_fMRI = get_mean_fMRI( preproc_dir, run_file_prefix, run_file_suffix )

r=1;
mean_fMRI = fullfile( preproc_dir, sprintf( 'RUN%i', r) , sprintf( 'mean%s%s.nii', run_file_prefix, run_file_suffix ) );

if( ~exist('mean_fMRI', 'file') )
    files = dir( mean_fMRI );
    mean_fMRI = fullfile( fileparts(mean_fMRI), files(1).name );
end
    
end