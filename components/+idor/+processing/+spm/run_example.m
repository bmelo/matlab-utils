%% configurations 

config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base        = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
config.nrun = 3;
config.nvol = 210;
config.ncorte = 40;
config.TR = 2;
config.TA = 1.675;
config.TA = config.TA - (config.TA/config.ncorte);
config.smooth = [6 6 6];
config.export_from_raw_data = 1;

config.runs_prefix = { 'FMRI__RUN1_PRJ1016*', 'FMRI__RUN2_PRJ1016*', 'FMRI__RUN3_PRJ1016*' }; 
config.run_file_prefix = 'FMRIRUN';
config.run_file_suffix = 'PRJ1016SENSE';

config.anat_prefix = '3D_T1_PRJ1016*';
config.anat_file = '3DT1PRJ1016SENSE.nii';

%% subjects
config.subj_prefix = 'SUBJ';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = [2:4 8:23]; %8 12 - Problemas
do_preprocessing = 0; % 0 ou 1;
do_first_level   = 0;
config.only_recalculate_contrasts = 0;
do_second_level  = 1;
config.mov_regressor = 1;
config.resp_regressor = 0;

%% configure paths
spm_dir = fileparts( which( 'spm' ) );
addpath( genpath( fullfile( config.dir_base, 'SCRIPTS') ) );
spm fmri

%% PREPROCESSING
if do_preprocessing
    preprocessing
end
    
%% inicializar uma vez o struct
config.model = get_supraliminar_model_simple();

%% FIRST LEVEL
if do_first_level
    config.logdir = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/LOG_PRESENTATION/fMRI';
    config.files = { 'Priming1.log', 'Priming2.log', 'Priming3.log'};
    config.first_level_preproc_prefix = 'swar';
    
    config.HPF = 128;
    
    run_first_level( config );
    
end

if do_second_level
    config.sec.g1 = [2:4 8 10:17 19:23];
    config.sec.g2 = [];
    config.sec.name = 'ALL_[SEM 9 18]';

    run_second_level( config );
end
