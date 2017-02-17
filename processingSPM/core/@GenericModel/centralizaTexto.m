function centralizaTexto( texto, largura )
%CENTRALIZATEXTO Summary of this function goes here
%   Detailed explanation goes here

texto = strtrim(texto);
tam = length(texto);
tamEsp = floor((largura-(tam+4))/2);
sobra = mod((largura-(tam+4)),2);
fprintf( '# %s%s%s #\n', repmat(' ',1,tamEsp), texto, repmat(' ',1,tamEsp+sobra) );

end