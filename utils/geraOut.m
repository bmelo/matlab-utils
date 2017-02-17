function geraOut( fullfilename, data)

addpath('/dados3/SOFTWARES/PESQUISA/MATLAB/SCRIPTS_IDOR/bruno/vendors/xlwrite');
[~, filename, ext] = fileparts(fullfilename);
ext(1) = []; %Remove o ponto da extensão
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
if( isnumeric(data) && (ceil(data) == floor(data)) )
    format = '%d';
elseif( isnumeric(data) )
    format = '%.4f';
end
out = sprintf(format, data);
end

function txt(fullfilename, data)
fid = fopen(fullfilename, 'w');
nTR = length(data); %Number Total of Rows
for nR=1:nTR
    if( isempty(data{:,nR}) )
        fprintf(fid,'\r\n');
        continue;
    end
    nTC = length( data{:,nR} ); %Number Total of Columns
    for nC=1:length( data{:,nR} )
        if( nC == length(data{:,nR}) )
            format = '%s';
        else
            format = '%s\t';
        end
        fprintf(fid, format, toTxt(data{:,nR}{nC}) );
    end
    if( nR~= nTR ) %Pula linha, caso não seja a última
        fprintf(fid, '\r\n');
    end
end
fclose(fid);
end

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

function xlsSavePlanilha( fullfilename, planilha, data )
    planilha = regexp(planilha,'^.{1,30}', 'match'); %Limita o tamanho da string
    for nR=1:length(data)
        if( isempty(data{:,nR}) ); continue; end;
        warning off;
        xlwrite(fullfilename, data{:,nR}, planilha, sprintf('A%d',nR));
        warning on;
    end
end

function csv(fullfilename, data)

for nR=1:length(data)
    if( isempty(data{:,nR}) ); continue; end;
    dlmwrite(fullfilename, data{:,nR},'-append','delimiter',',', 'newline', 'pc');
end

end