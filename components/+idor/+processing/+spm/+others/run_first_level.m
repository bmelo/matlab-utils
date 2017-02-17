function run_first_level( config )

for m = 1:length(config.model)

    for s=1:length(config.subjs)

        %% set parameters first level
        subdir_name = config.model(m).name ;
        if config.mov_regressor 
            subdir_name = ['MOV_' subdir_name ];
        end
        
        if config.resp_regressor
            subdir_name = ['RESP_' subdir_name ];
        end
                
        dest_dir = fullfile( config.proc_base, 'STATS', 'FIRST_LEVEL',  subdir_name );
        preproc_dir = fullfile( config.preproc_base, sprintf('%s%03i', config.subj_prefix, config.subjs(s) ) );
        nrun = config.nrun;
        nvol = config.nvol;
        preproc_prefix = config.first_level_preproc_prefix;
        run_file_prefix = config.run_file_prefix;
        run_file_suffix = config.run_file_suffix;
        
        dest_dir_subj = fullfile( dest_dir, sprintf('%s%03i', config.subj_prefix, config.subjs(s) ) );
        
        %% get conditions
        sessions = [];
        for r=1:length(config.files)
            logfile = fullfile( config.logdir, sprintf('%s%03i', config.subj_prefix, config.subjs(s)), sprintf('%s%03i-%s', config.subj_prefix, config.subjs(s), config.files{r} ) );

            [conditions start_time_seg] = log_to_condition( logfile, config.model(m).def );
            
            sessions(r).names       = conditions.names;
            sessions(r).onsets      = conditions.onsets;
            sessions(r).durations   = conditions.durations;
            sessions(r).regcontrast = struct('name', {}, 'columns', {});
            if isfield( conditions, 'pmod' )
                sessions(r).pmod        = conditions.pmod;
            else
                sessions(r).pmod = [];
            end
            
            if isfield( config.model(m), 'regressor_function_handle' ) && ~isempty( config.model(m).regressor_function_handle )
                [sessions(r).regfile name columns] = config.model(m).regressor_function_handle( config.logdir, sprintf('%s%03i', config.subj_prefix, config.subjs(s)), r, start_time_seg, config.nvol, preproc_dir );
                
                sessions(r).regcontrast(end+1).name = name;
                sessions(r).regcontrast(end).columns = columns;
            else
                sessions(r).regfile = '';
            end
            
            if config.mov_regressor 
                reg_dest_dir = fullfile( preproc_dir, sprintf( 'RUN%i', r) );
                mov_file = fullfile( reg_dest_dir, sprintf('rp_%s%i%s.txt', config.run_file_prefix, r, run_file_suffix) ); 
                sessions(r).regfile = join_regressor( sessions(r).regfile, mov_file );
                
                sessions(r).regcontrast(end+1).name = 'MOV';
                sessions(r).regcontrast(end).columns = 6;
            end

            %% RESPIRATION
            if config.resp_regressor
                reg_dest_dir = fullfile( preproc_dir, sprintf( 'RUN%i', r) );
                
                subjid = sprintf('%s%03i', config.subj_prefix, config.subjs(s) );
                logfile = fullfile( config.physlogdir, subjid, sprintf( '%s_RUN%i.log', subjid, r) );
                
                [resp_file name columns] = create_resp_regressor(logfile, nvol, config.ncorte, config.TR, reg_dest_dir ); 
                
                sessions(r).regfile = join_regressor( sessions(r).regfile, resp_file );
                
                sessions(r).regcontrast(end+1).name = name;
                sessions(r).regcontrast(end).columns = columns;
            end

        end
        
        disp( dest_dir_subj );
        
        %% execute first level
        if ~config.only_recalculate_contrasts
            clear matlabbatch;
            first_level_spec_and_estimate;
            spm_jobman('run',matlabbatch);
            save( fullfile( dest_dir_subj, 'BATCH_FIRST_LEVEL.mat'), 'matlabbatch' );
        end
        
        %% execute contrasts;
        clear matlabbatch;
        model = config.model(m);
        contrast;
        spm_jobman('run',matlabbatch);
        save( fullfile( dest_dir_subj, 'BATCH_CONTRAST.mat'), 'matlabbatch' );
        
        

    end
end