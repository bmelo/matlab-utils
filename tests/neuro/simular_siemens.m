dirIn  = 'C:\20120723.HOEFLE.2172012';
dirOut = 'C:\HOEFLE';

TR = 2; %em segundos
numSlices = 30;

numSerie = 1;
while true
    %Lendo cada série
    strSerieFiles = sprintf('*_%06d_*.dcm', numSerie);
    files = dir( fullfile(dirIn, strSerieFiles) );
    if isempty(files)
        break;
    end
    
    disp(['****  Inicio Serie ' num2str(numSerie) ' ****']);
    
    %Movendo todos os arquivos da série
    for k=1:length(files)
        fidIn = fopen( fullfile(dirIn, files(k).name), 'r' );
        dados = fread(fidIn);
        fclose(fidIn);
        
        fidOut = fopen( fullfile(dirOut, files(k).name), 'w' );
        fwrite(fidOut, dados);
        fclose(fidOut);
        disp( [fullfile(dirOut, files(k).name) '  -- last generated'] );
        pause( TR/numSlices ); %Intervalo de tempo entre a aquisição das imagens
    end
    
    disp('FIM DA SERIE --------'); disp(' ');disp(' ');
    
    numSerie = numSerie+1;
    input('Digite ENTER para continuar...'); %pause(20); %Tempo de 60segundos entre as séries
end

disp('... Finished!');