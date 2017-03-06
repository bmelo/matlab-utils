function out = corrigeSubPastas( dirRaiz, pattern, ignorar )

if nargin<2
    pattern = '';
end
if nargin<3
    ignorar='';
end

out.corrigidas = cell(0);
out.naoCorrigidas = cell(0);

subPastas = dir( fullfile(dirRaiz, [pattern '*']) );
for k=1:length(subPastas)
    if( ~subPastas(k).isdir | any(strcmp(subPastas(k).name, {'.', '..', ignorar})) )
        continue
    end
    subPasta = fullfile(dirRaiz, subPastas(k).name);
    if corrigePasta( subPasta )
        out.corrigidas{end+1} = subPasta;
    else
        fLog = fopen( 'errors.log', 'a' );
        fprintf( fLog, '### Diretorio %s não corrigido!\n\n', subPasta);
        fclose(fLog);
        fprintf('### Diretorio %s não corrigido!\n\n', subPasta);
        out.naoCorrigidas{end+1} = subPasta;
    end
end

end