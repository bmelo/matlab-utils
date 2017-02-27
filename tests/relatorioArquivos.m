mes = 'Outubro';
fid = fopen( sprintf('arquivos%s.txt', mes) );
Dados = textscan(fid,'%s%s%s%s%s%s%f%s%s%s%s', 'Delimiter',' ', 'MultipleDelimsAsOne', true, 'EmptyValue', -Inf);
fclose(fid);

tamDados = size(Dados);
tamanho = sum(Dados{7});
fprintf( '%s: %.2f GB\n', mes, tamanho/1024/1024/1024 );