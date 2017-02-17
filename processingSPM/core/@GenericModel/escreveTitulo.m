function escreveTitulo( titulo )

if iscell(titulo) %Verifica se foi passado dado do tipo cell
    titulo = char(titulo);
end
sizeT = length(titulo); %Calcula o tamanho do texto
larg = max(72, (sizeT+4)); %Calcula a largura máxima
fprintf( '\n%s\n', repmat('#',1,larg) ); %Escreve a barra superior
for k=1:size(titulo,1)
    GenericModel.centralizaTexto( titulo(k,:), larg );
end
fprintf( '%s\n\n', repmat('#',1,larg) );

end

