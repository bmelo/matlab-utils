spm_dir = '/dados3/SOFTWARES/Blade/toolbox_IDOR/spm12/spm12';

remove_from_path( 'spm8' )
addpath( spm_dir );
remove_from_path( 'fieldtrip' );

clear classes;
spm fmri;

addpath(genpath('/dados3/SOFTWARES/Blade/toolbox_IDOR/processingUtils/'));
cfg_util('addapp', 'idor_cfg');