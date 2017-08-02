function geraOut( fullfilename, data)

[~, ~, ext] = fileparts(fullfilename);
if isempty(ext)
    ext = 'txt';
else
    ext(1) = []; %Remove o ponto da extensão
end

if strcmp(ext,'xlsx'); ext='xls'; end;


try
    eval( sprintf('%s(fullfilename, data)', ext) ); %Chama a funcao para aquela extensao
catch e
    fclose all;
    switch e.identifier
        case 'MATLAB:UndefinedFunction'
            error('Tipo de arquivo não reconhecido. [%s]', fullfilename);
        otherwise
            rethrow(e);
    end
end

end

function out=toTxt(data)
format = '%s';

if iscell(data)
    data = cell2mat(data);
end

if isempty(data)
    out = '';
    return;
end

if( isnumeric(data) && (ceil(data) == floor(data)) )
    format = '%d';
elseif( isnumeric(data) )
    format = '%.4f';
end

out = sprintf(format, data);
end

%%%%%%%%%%%%%%%%%
function txt(fullfilename, data)
fid = fopen(fullfilename, 'w');
nTR = size(data, 1); %Number Total of Rows
for nR=1:nTR
    if( isempty(data(nR,:)) )
        fprintf(fid,'\r\n');
        continue;
    end
    nTC = size( data, 2 ); %Number Total of Columns
    for nC = 1:nTC
        if( nC == nTC )
            format = '%s';
        else
            format = '%s\t';
        end
        fprintf(fid, format, toTxt( data(nR,nC) ) );
    end
    if( nR ~= nTR ) %Pula linha, caso não seja a última
        fprintf(fid, '\r\n');
    end
end
fclose(fid);
end

%%%%%%%%%%%%%%%%%
function xls(fullfilename, data)

if iscell(data)
    xlsSavePlanilha( fullfilename, 'Planilha 1', data );
elseif isstruct( data )
    planilhas = fields(data);
    for nP = 1:length(planilhas)
        xlsSavePlanilha( fullfilename, planilhas{nP}, data.(planilhas{nP}) );
    end
end

end

%%%%%%%%%%%%%%%%%
function xlsSavePlanilha( fullfilename, planilha, data )
planilha = regexp(planilha,'^.{1,30}', 'match'); %Limita o tamanho da string
nTR = size(data, 1);
for nR = 1:nTR
    if( isempty( data(nR,:)) ); continue; end;
    warning off;
    try
        xlwrite(fullfilename, data(nR,:), planilha, sprintf('A%d',nR));
    catch e
        xlwrite(fullfilename, data{nR,:}, planilha, sprintf('A%d',nR));
    end
    warning on;
end
end

%%%%%%%%%%%%%%%%%
function csv(fullfilename, data)

nTR = size(data, 1);
for nR = 1:nTR
    if( isempty(data(nR,:)) ); continue; end;
    dlmwrite(fullfilename, data(nR,:),'-append','delimiter',',', 'newline', 'pc');
end

end