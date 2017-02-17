function exec_procs( config )

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end

if config.do.preprocessing
    preprocessing( config );
end

%% FIRST LEVEL
if config.do.first_level
    run_first_level( config );
end

if config.do.second_level
    run_second_level( config );
end

if config.do.extract_betas
    extract_betas( config );
end