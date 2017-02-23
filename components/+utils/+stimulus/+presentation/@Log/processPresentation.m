function [conditions start_time_seg] = processPresentation( obj, def, model )
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

if isa(def, 'function_handle')
    conditions = def(obj);
else
    for k=1:length(def)
        obj.defCurrent = def(k);
        %% treat condition k
        % get matches
        [~, ~, onsetM] = obj.getMatches();
        
        conditions.names{k} = def(k).spm_name;
        conditions.onsets{k} = obj.timereal( onsetM );
        conditions.durations{k} = obj.calculateDurations( k, onsetM );
        conditions = limpaOnsets( conditions );
        if isfield( def(k), 'spm_pmod' ) && ~isempty( def(k).spm_pmod )
            conditions.pmod(k) = obj.parametrics(k);
        end
    end
end

if( exist('model','var') && isfield(model, 'afterLogs') )
    conditions = model.afterLogs( conditions );
end

end

function conditions = limpaOnsets(conditions)

dur = conditions.durations{end};
conditions.onsets{end}(dur == -1) = [];
conditions.durations{end}(dur == -1) = [];

end