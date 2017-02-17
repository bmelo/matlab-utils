function [ runDir ] = get_run_dir( config, nRun )
%GET_RUN_DIR returns the right name for the run with number nRun

if( isfield(config, 'runs_dir') && iscell( config.runs_dir ) )
    runDir = config.runs_dir{nRun};
else
    %if( iscell( config.runs_prefix ) )
    %    runDir = config.runs_prefix{nRun};
    %else
    runDir = sprintf( 'RUN%d', nRun);
end

end

