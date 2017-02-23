function sessions = log_to_spm( logfiles )

for f=1:length(logfiles )

    logfile = logfiles{f};
    
    conditions = log_to_condition( logfiles{f}, def )

    names = conditions.names;
    onsets = conditions.onsets;
    durations = conditions.durations;

    if isfield( conditions, 'pmod' )
        pmod = conditions.pmod;
    else
        pmod = struct( 'name', {''}, 'param', {}, 'poly', {} ); 
    end

    %%
    sessions(f).names = names;
    sessions(f).onsets = onsets;
    sessions(f).durations = durations;
    
end

end