function run_second_level( config )
execute = ~idor.utils.Var.get( config, 'only_batch_files', false);
files = {};
for m = 1:length(config.model)
    %% checking model
    if iscell(config.model)
        model = config.model{m}(config);
    else
        model = config.model(m);
    end
    
    %% Doing second level
    subdir_name = model.name ;
    if config.mov_regressor 
        subdir_name = ['MOV_' subdir_name ];
    end

    if config.resp_regressor
        subdir_name = ['RESP_' subdir_name ];
    end

    for ci=1:length(model.contrast)

        contrast_name = strrep( model.contrast(ci).name, '>' , '-' );

        dest_dir = fullfile( config.proc_base, 'STATS', 'SECOND_LEVEL',  subdir_name, config.sec.name, contrast_name );
        if ~isdir(dest_dir), mkdir(dest_dir), end
        cd ( dest_dir );
       
        clear matlabbatch;
        ttest_spm_flex;
        files(end+1).name = fullfile( dest_dir, 'BATCH_SL.mat');
        files(end).matlabbatch = matlabbatch;
        files(end).message = sprintf( 'Second level for Design: %s and contrast: %s.\n Results written to: %s\n', subdir_name, contrast_name, dest_dir);
    end
end
execSpmFiles( files, execute );

end


