function run_first_level( config )

if( ~isfield( config, 'mask' ) )
    config.mask = {'/dados3/SOFTWARES/Blade/toolbox_IDOR/spm8/apriori/brainmask.nii,1'};
end

for m = 1:length(config.model)
    
    for s=1:length(config.subjs)
        %% Defining subject name and preprocdir
        if isnumeric( config.subjs(s) )
            name_subj = get_subjid(config, config.subjs(s));
        else
            name_subj = config.subjs{s};
        end
        preproc_dir = fullfile( config.preproc_base, name_subj );
        % Fixing name_subj and preproc_dir
        if( ~isdir( preproc_dir ) )
            preproc_folder = dir( [preproc_dir '*'] );
            name_subj = preproc_folder(1).name;
            preproc_dir = fullfile( config.preproc_base, name_subj );
        end
        
        %% checking model
        if iscell(config.model)
            model = config.model{m}(config, name_subj);
        else
            model = config.model(m);
        end
        
        % When model is resolved by a function, it can returned multiple
        % models that need to be treated as below
        for nM = 1:length(model)
            prepare_and_run_FL(config, name_subj, model(nM), preproc_dir)
        end
        
    end
end
end


function prepare_and_run_FL( config, name_subj, model, preproc_dir )
import idor.utils.Var;
%% set parameters first level
subdir_name = model.name;
if config.mov_regressor
    subdir_name = ['MOV_' subdir_name ];
end

if config.resp_regressor
    subdir_name = ['RESP_' subdir_name ];
end
dest_dir = fullfile( config.proc_base, 'STATS', 'FIRST_LEVEL',  subdir_name );


nrun = config.nrun;
nvol = config.nvol;
preproc_prefix = config.first_level_preproc_prefix;
run_file_prefix = config.run_file_prefix;
run_file_suffix = config.run_file_suffix;
mov_reg_pat = Var.get(config, 'mov_reg_pat', 'rp_%s.txt');

dest_dir_subj = fullfile( dest_dir, name_subj );

%% get conditions
sessions = [];
for r=1:config.nrun
    run_dir = get_run_dir(config, r);
    if( ~isfield( config, 'presentation' ) || config.presentation)
        logfile = fullfile( config.logdir, sprintf('%s*%s', name_subj, config.files{r} ) );
        logfile = getFilePattern(logfile, 'LAST');
        logHandle = Log( logfile );
        [conditions start_time_seg] = logHandle.processPresentation( model.def, model );
    else
        if length(model.conditions) > 1
            conditions = model.conditions(r);
        else
            conditions = model.conditions(1);
        end
    end
    
    sessions(r).names       = conditions.names;
    sessions(r).onsets      = conditions.onsets;
    sessions(r).durations   = conditions.durations;
    sessions(r).regcontrast = struct('name', {}, 'columns', {});
    sessions(r).pmod        = Var.get( conditions, 'pmod', [] );
    
    if ~isempty( Var.get(model, 'regressor_function_handle', []) )
        [sessions(r).regfile name columns] = model.regressor_function_handle( config.logdir, sprintf('%s%03i', config.subj_prefix, config.subjs(s)), r, start_time_seg, config.nvol, preproc_dir );
        
        sessions(r).regcontrast(end+1).name = name;
        sessions(r).regcontrast(end).columns = columns;
    else
        sessions(r).regfile = '';
    end
    
        %% MOVIMENT
    if config.mov_regressor
        mov_file = fullfile( preproc_dir, run_dir, sprintf(mov_reg_pat, config.run_file_prefix) );
        mov_file = resolve_name( mov_file );
        sessions(r).regfile = join_regressor( sessions(r).regfile, mov_file );
        
        sessions(r).regcontrast(end+1).name = 'MOV';
        sessions(r).regcontrast(end).columns = 6;
    end
    
    %% RESPIRATION
    if config.resp_regressor        
        subjid = sprintf('%s%03i', config.subj_prefix, config.subjs(s) );
        logfile = fullfile( config.physlogdir, subjid, sprintf( '%s_RUN%i.log', subjid, r) );
        
        [resp_file name columns] = create_resp_regressor(logfile, nvol, config.ncorte, config.TR, fullfile(preproc_dir, run_dir) );
        
        sessions(r).regfile = join_regressor( sessions(r).regfile, resp_file );
        
        sessions(r).regcontrast(end+1).name = name;
        sessions(r).regcontrast(end).columns = columns;
    end
    
    %% OUTLIERS ART
    if Var.get(config, 'art_outliers')
        sessions(r).regress.name = 'ART outliers';
        first = (config.nvol * (r-1)) + 1;
        last = config.nvol * r;
        art_outs = Var.get(config.outliers, name_subj, []);
        outliers = zeros( config.nvol, 1 );
        idx = art_outs( art_outs >= first & art_outs<= last ) - (first-1);
        outliers(idx) = 1;
        %Getting outliers
        sessions(r).regress.val = outliers;
    end
    
end

disp( dest_dir_subj );
files = {};

%% execute first level
if ~config.only_recalculate_contrasts
    clear matlabbatch;
    files{end+1} = fullfile( dest_dir_subj, 'BATCH_1_FIRST_LEVEL.mat');
    first_level_spec_and_estimate;
    %% one session (merge all sessions)
    if Var.get(config, 'one_session')
        import idor.processing.spm.batch_modules.firstlevel.oneSession;
        matlabbatch{1}.spm.stats.fmri_spec = oneSession( config, matlabbatch{1}.spm.stats.fmri_spec );
    end
    save( files{end}, 'matlabbatch' );
end

%% execute contrasts;
if ~config.only_estimate
    clear matlabbatch;
    files{end+1} = fullfile( dest_dir_subj, 'BATCH_2_CONTRAST.mat');
    contrast;
    save( files{end}, 'matlabbatch' );
end

if ~config.only_batch_files
    execSpmFiles( files )
end;
end