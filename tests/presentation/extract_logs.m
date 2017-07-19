import utils.stimulus.presentation.Log;

m_dir = fileparts( mfilename('fullpath') );

run( fullfile(m_dir, 'vendors/matlab-utils/libsetup.m') );

cd(m_dir);
logs_pattern = fullfile( 'logs/*/*EST.log' );

logs = utils.resolve_names( logs_pattern );

%% Treating each log file
for k = 1:length(logs)
    
    disp(logs{k});
    log = Log( logs{k} );
    idxs = log.getMatches(struct('pres_type', 'Picture|Response', 'pres_codes', '*'));
    
    % Extracting information
    onsets  = (log.Time(idxs) - log.Time(1))/10000;
    codes   = log.Code(idxs);
    types   = log.EventType(idxs);
    
    %% Dataset setup
    classes = codes;
    output = {};
    txt = '';
    
    % Identifying classes (particular for this dataset)
    for j = 1:length(classes)
        if regexp(classes{j}, '^\d+$')
            classes{j} = 'Response';
        elseif strfind(classes{j}, 'img')
            classes{j} = regexp(classes{j}, '(?<=val_\d+_).*(?=\]\_jit)', 'match', 'once');
        elseif strfind(classes{j}, 'perg')
            classes{j} = 'Pergunta';
        end
        
        % For exporting
        onsetBR = strrep( sprintf('%.4f', onsets(j)), '.', ',' );
        output{j} = { onsetBR classes{j} codes{j} types{j}};
        txt = [txt sprintf('%s\n', sprintf('%s\t%s\t%s\t%s', output{j}{:}) )];
    end
    
    % Exporting
    [~,outname] = fileparts(logs{k});
    fh = fopen( [outname '.txt'], 'w' );
    fprintf(fh, txt);
    fclose(fh);
end

