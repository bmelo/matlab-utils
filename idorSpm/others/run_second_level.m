function run_second_level( config )

for m = 1:length(config.model)

    subdir_name = config.model(m).name ;
    if config.mov_regressor 
        subdir_name = ['MOV_' subdir_name ];
    end

    if config.resp_regressor
        subdir_name = ['RESP_' subdir_name ];
    end

    for ci=1:length(config.model(m).contrast)

        contrast_name = strrep( config.model(m).contrast(ci).name, '>' , '-' );

        dest_dir = fullfile( config.proc_base, 'STATS', 'SECOND_LEVEL',  subdir_name, config.sec.name, contrast_name );
        if ~isdir(dest_dir), mkdir(dest_dir), end
        cd ( dest_dir );

        disp (['Second level for Design: ', subdir_name, ' and contrast: ', contrast_name, '. Results written to: ', contrast_name]); 

        subjs = config.sec.g1;
       
        clear matlabbatch;
        ttest_spm_flex;
        spm_jobman('run',matlabbatch);
    end
    

end

end


