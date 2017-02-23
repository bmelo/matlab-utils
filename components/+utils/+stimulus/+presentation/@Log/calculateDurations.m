function [ durations ] = calculateDurations( obj, k, onset_matches )
%CALCULATEDURATIONS Summary of this function goes here
%   calculate durations
def = obj.def(k);
hasFix = isfield( def, 'spm_fix_duration' ) && ~isempty( def.spm_fix_duration );
hasTermination = isfield( def, 'pres_termination_codes' ) && ~isempty( def.pres_termination_codes );

if hasTermination
    [~, ~, offset_matches] = obj.getTerminations();
    durations = zeros(sum(onset_matches),1);
    idx_on  = find( onset_matches ); %Ocorrências da condição
    idx_end = find( offset_matches );
    filterValue = isfield( def, 'pres_termination_valueCheck' );
    
    %Ir� remover itens que n�o sejam do tipo determinado
    if filterValue 
        ok_matches = offset_matches & obj.get_matches( def.pres_termination_valueCheck, obj.Code ); %casos que correspondem ao resultado esperado
        idx_ok = find( ok_matches );
    end
    
    %Resgata as dura��es
    for k = 1:length(idx_on)
        m = idx_on(k);
        % subtract for every onset time the offset time
        idx_diff = idx_end - m;
        
        % remove negative time differences
        idx_diff( idx_diff <= 0 ) = [];
        
        % take minimal positive value
        if isempty( idx_diff )
            % take last time of experiment if no offset is found
            warning('no termination event found');
            %durations(m) = obj.timereal(end) - obj.timereal( idx_on(m) );
        else
            m_end = min(idx_diff+m); %Volta ao valor original para resgatar tempo
            isOk = ~filterValue || any( idx_ok == m_end ); %Avisa que se encaixa e que ir� usar este onset
            if( ~isOk )
                durations(k) = -1; %Flag para remo��o de onset
            elseif( hasFix )
                durations(k) = def.spm_fix_duration; %Usa tempo fixo
            else
                durations(k) = obj.timereal( m_end ) - obj.timereal( m ); %Calcula dura��o
            end
        end
    end
else
    % use fix duration for onsets
    durations = def.spm_fix_duration * ones(sum(onset_matches),1);
end

end