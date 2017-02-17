
model = get_cue_model();
model = get_cue_and_effort_model();

%% transform
logdir = '/dados1/PROJETOS/OUTROS/PRJXXXX_FUTEBOL/03_PROCS/PRESENTATION_LOG/TEST_FINAL';
logfiles = { ...
    'TEST-1Run.log', ...
    'TEST-2Run.log', ...
    'TEST-3Run.log', ...
    };

for f=1:length(logfiles)

    logfile = logfiles{f};
    
    conditions = log_to_condition( fullfile(logdir, logfile), model.def )

    names = conditions.names;
    onsets = conditions.onsets;
    durations = conditions.durations;

    if isfield( conditions, 'pmod' )
        pmod = conditions.pmod;
    else
        pmod = struct( 'name', {''}, 'param', {}, 'poly', {} ); 
    end

    [a b] = fileparts( logdir );
    design_dir = fullfile( a, 'SPM_DESIGNS', model.name );  
    if ~isdir( design_dir ), mkdir( design_dir ), end

    save( fullfile( design_dir, [logfile(1:end-4) '_' model.name '_conditions.mat']), 'names', 'onsets', 'durations', 'pmod' );

    %%
    sessions(f).names = names;
    sessions(f).onsets = onsets;
    sessions(f).durations = durations;
    
    
end

spec_dir = design_dir;
num_scans = 250;

design_only_template
% design_template

save( fullfile( design_dir, [logfile(1:4) '_' model.name '_design.mat']), 'matlabbatch' );


