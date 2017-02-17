% formato do arquivo:
% nome_col1 nome_col2 ... nome_coln
% dado1 dado2 ... dadon
% dado1 dado2 ... dadon
% ...
% outro formato aceito é somenta dado, nesse caso os nomes serão enumerados
% R1, R2, ... , RN
function [nomes dado_colunas count] = getNomesRegressores( filename, count )

nomes = {};
dado_colunas = [];

if nargin < 2
    count = 0;
end

try
    lines = importdata( filename );
catch
    warning( sprintf('Could not load %s', filename ) );
    return
end

if isstruct( lines ) % caso tenha header
    [res pos] = textscan( lines.textdata{1}, repmat('%s',1,size(lines.data,2)) );
    for k=1:length(res)
        nomes(end+1) = res{k};
    end
     
    dado_colunas = lines.data;
else % caso sem header
    dado_colunas = lines;
    for k=1:size(dado_colunas,2)
        nomes{k} = sprintf('R%i', count );
        count = count + 1;
    end
end

end