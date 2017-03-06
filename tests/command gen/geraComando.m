function out = geraComando( params )
out = replaceTags( params.COMANDO, params );
end

%Função que substitui as TAGS
function out = replaceTags( inTxt, params )
out = inTxt;
[matches, tokens] = regexp(inTxt, '\{([\w\d_]+)\}', 'match', 'tokens'); %Extrai itens para serem substituidos
for k=1:length(tokens)
  trocar = matches{k};
  valor = replaceTags( params.( tokens{k}{1} ), params );
  out = strrep( out, trocar, valor );
end

end