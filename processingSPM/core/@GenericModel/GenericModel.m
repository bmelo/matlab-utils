classdef GenericModel < handle
    % GENERICMODEL Classe criada para fornenecer os atributos e m�todos gen�ricos e que fazem parte de todos os processamentos.
    % Uma altera��o nesta classe ir� replicar em todos os processamentos
    
    properties
        %Config
        code;
        description;
        error;
        
        %Ajustes de processamento
        logoff = 0; %Efetua o logoff quando o processamento for encerrado
        rewrite = 1; %Sobrescreve os arquivos
        parallel = 0; %Para processar em paralelo
        export = 1; %Informa se os scripts ser�o exportados para serem abertos no matlab
        loggar = 1; %Escreve arquivos de log @todo
        openSPM = 1; %Verifica se o spm deve ou n�o ser aberto
        onlyExportScripts = 0; %Informa que apenas quer gerar os scripts
        stopIfError = 0;
        
        %Input
        inDir; %Diret�rio raiz das pastas dos sujeitos
        numSessions; %Quantidade de RUNs
        
        %Output
        outDir;
        prefixProj; %Caso queira distinguir a pasta do projeto no diretorio de saida
    end
    
    methods
        function populateData(obj, objPai)
            atribs = properties(obj);
            for k=1:length(atribs)
                if find( strcmp(atribs{k}, properties(objPai)) )
                    eval(['obj.' atribs{k} ' = objPai.' atribs{k} ';']);
                end
            end
        end
    end
    
    methods(Static = true)
        centralizaTexto( texto, largura );
        escreveTitulo( titulo );
    end
    
end

