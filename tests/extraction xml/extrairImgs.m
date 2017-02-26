clc;
filename = 'hrefLINKS.txt';
xmldata = fileread(filename);
urlImgs = regexpi( xmldata, '<img(.*?)src=("|\'')(?<url>.*?)(\2)(.*?)>', 'names' );
%urlImgs = regexpi( xmldata, '<a(.*?)href=("|\'')(http[s]*|ftp)://\S(?<url>.*?)(\2)(.*?)>', 'names' );
%urlImgs = regexpi( xmldata, '<wp:attachment_url>(?<url>.*?)</wp:attachment_url>', 'names' );
%urlImgs = regexpi( xmldata, '<guid (.*?)>(?<url>.*?)</guid>', 'names' );
% coloca tudo em cell, deixa apenas valores unicos e ordena
if isstruct(urls)
    urls = sort( unique( reshape( struct2cell(urlImgs), length(urlImgs), [] ) ) );
else
    urls = urlImgs;
end
dirOutput = 'arquivosLinks';
fh = fopen('extracao.log', 'a');
fprintf(fh, 'INICIO DA EXTRAÇÃO\n\n    DATA: %s\n    ARQUIVO: %s\n\n\n',datestr(now()), filename);
% Varrendo todas as imagens
for k = 1:length(urls)
    url = urls{k};
    if(regexp( url, '(.*)/wp-content/(.*)' ))
        dadosUrl = regexp( url, '(.*)/wp-content/(?<pasta>.*?)/(?<ano>.*?)/(?<mes>.*?)/(?<arquivo>.*)', 'names' );
        dirSaida = fullfile(dirOutput, dadosUrl.pasta, dadosUrl.ano, dadosUrl.mes );
    else
        dadosUrl = regexp( url, '(.*)/(?<arquivo>.*)', 'names' );
        dirSaida = dirOutput;
    end
    if( ~exist(dirSaida, 'dir') )
        mkdir(dirSaida);
    end
    % Baixa o arquivo e salva no diretório correto
    msg = '';
    try
        dadosUrl.arquivo = strrep(dadosUrl.arquivo, '%20', ' ');
        if( ~exist(fullfile(dirSaida, dadosUrl.arquivo), 'file'))
            urlwrite( url, fullfile(dirSaida, dadosUrl.arquivo));
            msg = sprintf( '%s (OK)\n', url);
        else
            %msg = sprintf( '%s (IGNORADO) -> ARQUIVO JÁ EXISTE\n', url);
        end
        
    catch E
        msg = sprintf( '%s (ERRO!!) -> OCORREU ALGUM PROBLEMA NO DOWNLOAD\n', url);
        fprintf( '%s', msg);
    end
    fprintf(fh, '%s', msg);
end
fprintf(fh, '\n\n------------------------\n\n');
fclose(fh);