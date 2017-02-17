function [conditions start_time_seg] = log_to_condition( logfile, def )

%reads in the logfile - each column will be a variable, first 5 lines are
%skipped (headerlines):
fid = fopen(logfile);
ret = textscan(fid,'%s %s %s %s %f %f %*[^\n]','delimiter','\t','headerlines',5); 
fclose(fid);
Subject = ret{1};    
Trial = ret{2};
EventType = ret{3};
Code = ret{4};
Time = ret{5};
TTime = ret{6};
% Uncertainty = ret{7}; 
% Duration = ret{8}; 
% Uncertainty = ret{9};

%[Subject Trial EventType Code Time TTime Uncertainty Duration Uncertainty] = textread(logfile,'%s %s %s %s %f %f %f %f %s %*[^\n]','delimiter','\t','headerlines',5); 

conditions = struct( 'names', [] , 'onsets', [], 'durations', [] );
first_pulse = find( strcmp( EventType, 'Pulse' ), 1 );
timereal = (Time-Time(first_pulse))/10000; %Computing the time (first entry in time is the first pulse and needs to be substracted from all other times, 
start_time_seg = Time(first_pulse)/10000;

for k=1:length(def)
   
    %% treat condition k
    
    % find onsets
    type_matches = get_code_matches(  {def(k).pres_type}, EventType );
    
    % find all code matches
    code_matches = get_code_matches( def(k).pres_codes, Code );
    
    % require to match type and one of the codes
    onset_matches = type_matches & code_matches;
    
    %% calculate durations
    if ~isfield( def(k), 'spm_fix_duration' ) || isempty( def(k).spm_fix_duration )
        type_matches = get_code_matches(  def(k).pres_termination_types, EventType );
    
        % find all code matches
        code_matches = get_code_matches( def(k).pres_termination_codes, Code );
        offset_matches = type_matches & code_matches;
        durations = zeros(sum(onset_matches),1);
        
        idx_on  = find( onset_matches );
        
        for m=1:length(idx_on)
            % subtract for every onset time the offset time
            time_diff = timereal( offset_matches ) - timereal( idx_on(m) );
            
            % remove negative time differences
            time_diff( time_diff <= 0 ) = [];
            
            % take minimal positive value 
            if isempty( time_diff )
                % take last time of experiment if no offset is found
                warning('no termination event found')
                durations(m) = timereal(end) - timereal( idx_on(m) );
            else
                durations(m) = min( time_diff );
            end     
        end
    else
        % use fix duration for onsets
        durations = def(k).spm_fix_duration * ones(sum(onset_matches),1);
    end
    
    %% treat parametric modulations
    if isfield( def(k), 'spm_pmod' ) && ~isempty( def(k).spm_pmod )
        for np = 1:length(def(k).spm_pmod)
            if isa( def(k).spm_pmod(np).name, 'function_handle' )
                 conditions.pmod(k) = def(k).spm_pmod(np).name( onset_matches, Code, def(k).spm_pmod(np).str );
            else

                mod_matches = get_code_matches_separate( def(k).pres_codes, Code);
                mod_values = zeros( length( onset_matches ), 1 );
                for c=1:length(def(k).pres_codes)
                    mod_values( mod_matches{c} & onset_matches ) = def(k).spm_pmod(np).values(c);
                end  
                mod_values( ~onset_matches ) = [];

                conditions.pmod(k).name{1} = def(k).spm_pmod(np).name;
                conditions.pmod(k).param{1} = mod_values;
                conditions.pmod(k).poly{1} = def(k).spm_pmod(np).poly;
            end
        end
    else
         % conditions.pmod(k) = ''; struct('name', {}, 'param', {}, 'poly', {});
    end
    
    conditions.names{k} = def(k).spm_name;
    conditions.onsets{k} = timereal( onset_matches );
    conditions.durations{k} = durations;
    
end

end

function code_matches = get_code_matches( codes, Code )

code_matches = ones(length(Code),1) == 0;
for c=1:length(codes)
%    code_matches = [code_matches | strcmp( num2str( codes{c} ), Code )];
    hit = ~cellfun( @isempty, regexp( Code, num2str( codes{c} ) ) );
    code_matches = [code_matches | hit];
end

end

function code_matches = get_code_matches_separate( codes, Code )

for c=1:length(codes)
%    code_matches{c} = strcmp( num2str( codes{c} ), Code );
    code_matches{c}  = ~cellfun( @isempty, regexp( Code, num2str( codes{c} ) ) );
end

end