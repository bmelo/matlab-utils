spm_dir = '/dados3/SOFTWARES/Blade/toolbox_IDOR/spm12/spm12';

remove_from_path( 'spm' )
addpath( spm_dir );
remove_from_path( 'fieldtrip' );

clear classes;
spm fmri;