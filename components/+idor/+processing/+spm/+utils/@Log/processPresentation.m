function [conditions start_time_seg] = processPresentation( obj, def )
%PROCESS Summary of this function goes here
%   Detailed explanation goes here

%preparing data
first_pulse = find( strcmp( obj.EventType, 'Pulse' ), 1 );
difftime = (obj.Time - obj.Time(first_pulse));
obj.def = def;
obj.timereal = difftime/10000; %Computing the time (first entry in time is the first pulse and needs to be substracted from all other times,

% outputs
conditions = struct( 'names', [] , 'onsets', [], 'durations', [] );
start_time_seg = obj.Time(first_pulse)/10000;

for k=1:length(def)
    %% treat condition k
    % find onsets
    type_matches = obj.get_matches(  {def(k).pres_type}, obj.EventType );
    
    % find all code matches
    code_matches = obj.get_matches( def(k).pres_codes, obj.Code );
    
    % require to match type and one of the codes
    onset_matches = type_matches & code_matches;
    
    conditions.names{k} = def(k).spm_name;
    conditions.onsets{k} = obj.timereal( onset_matches );
    conditions.durations{k} = obj.calculateDurations(k, onset_matches);
    conditions = limpaOnsets( conditions );
    if isfield( def(k), 'spm_pmod' ) && ~isempty( def(k).spm_pmod )
        conditions.pmod(k) = obj.parametrics(k);
    end
    
end

end

function conditions = limpaOnsets(conditions)

dur = conditions.durations{end};
conditions.onsets{end}(dur == -1) = [];
conditions.durations{end}(dur == -1) = [];

end