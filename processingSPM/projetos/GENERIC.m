classdef GENERIC < handle & ProjectSPM
    
    properties(SetAccess = public)
        %Config
        code = 'ProcGeneric';
        %Input
        inDir = ''; %Diret�rio raiz das pastas dos sujeitos
        subjects = 1:3; %Identificador dos sujeitos que ser�o analisados
        
        prefixSubj = 'SUBJ'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
        tamPadSubj = 3; %Quantidade de n�meros na identifica��o de cada sujeito
        numSessions = 2; %Quantidade de RUNs
        prefixSes = 'RUN';
        tamPadSes = 2;
        
        %Preproc parameters
        tr = 2;
        nslices = 22;
        voxelSize = [3.75 3.75 5];
        smoothing = [7.5 7.5 10];
        
        %First Level
        units = 'secs';
        conditions = {'REST', 'SENSE'};
        contrastes = { ...
            'REST - SENSE',  [1 -1]; ...
            'SENSE - REST',  [-1 1]; ...
        };
        filter = 128;
        
        %Output
        outDir = '';
        prefixProj = ''; %Caso queira distinguir a pasta do projeto no diretorio de saida
    end
    
    methods (Access = protected)
        function ajustaConditions(obj)
        end
    end
end