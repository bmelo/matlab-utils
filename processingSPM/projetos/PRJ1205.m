classdef PRJ1205 < handle & ProjectSPM
    properties
        %Atributos específicos do projeto
    end
    
    methods (Access = public)
        function obj=PRJ1205()
            %Config
            obj.code = 'PRJ1205';
            obj.description = 'Sense Tatil';
            
            %Input
            obj.baseDir = 'C:\Documents and Settings\bmelo\Desktop\PRJ1205\';
            obj.rawDir = 'C:\Documents and Settings\bmelo\Desktop\PRJ1205\RAW_DATA';
            obj.subjects = [8 10 11]; %Identificador dos sujeitos que serão analisados
            
            obj.prefixSubj = 'SUBJ'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
            obj.tamPadSubj = 3; %Quantidade de números na identificação de cada sujeito
            obj.numSessions = 2; %Quantidade de RUNs
%             obj.prefixSes = 'RUN'; %Irá ser usado caso o atributo pathSessions esteja vazio
%             obj.tamPadSes = 2;
            obj.pathSessions = {'MAO_DIR', 'MAO_ESQ'};
            
            %Output
            obj.folderPre = 'PREPROC_DATA';
            obj.folderFL = 'FIRST_LEVEL';
            obj.folderSL = 'SECOND_LEVEL';
            obj.prefixProj = ''; %Caso queira distinguir a pasta do projeto no diretorio de saida
            
            obj.inDir = fullfile( obj.baseDir, obj.folderPre );
            obj.outDir = fullfile( obj.baseDir, obj.folderFL );
            
            %Preproc
            obj.tr = 2;
            obj.nslices = 40;
            obj.voxelSize = [3 3 3];
            obj.smoothing = [6 6 6];
            
            %FirstLevel
            obj.conditions = { ...
                { 
                   'REST', 1:20:100, 10;
                   'SENSE_DIR', 11:20:100, 10;
                },...
                { 
                   'REST', 1:20:100, 10; 
                   'SENSE_ESQ', 11:20:100, 10;
                }...
            };
 
            % Contrasts
            obj.replicarContrastes = false;
            obj.contrastes = { ...
                'MEXE',   [1 0 1 0]; ...
                'MEXE-PARA',  [1 -1 1 -1]; ...
                'MAO_DIR - MAO_ESQ',  [1 0 -1 0]; ...
                'MAO_ESQ - MAO_DIR',  [-1 0 1 0]; ...
            };
            obj.filter = 128;
        end
    end
    
    methods (Access = protected)
        
        function batch(obj, varargin)
            obj.inDir = fullfile(obj.baseDir, obj.folderPre); %Diretório raiz das pastas dos sujeitos
            %% Preproc normal
            obj.dcm2nii();
            obj.processarPreproc();
            %% Preproc unificado
            %obj.dcm2nii();
            %obj.processarPreproc( 'unificado', 1, 'etapas', {'realign', 'slicetiming', 'detrend', 'normalization', 'smooth'} );
            %% Preproc unificado aplicando detrend
            %obj.processarPreproc( 'unificado', 1, 'prefixoInicial', 'aru', 'etapas', {'detrend','normalization','smooth'} );
            
            %% Executando análises de First Level
            %obj.inDir = fullfile(obj.baseDir, obj.folderPre);            
            %% Análise normal
            obj.description = 'Analise Normal';
            obj.outDir = fullfile(obj.baseDir, obj.folderFL);
            %obj.processarFirstLevel();
            %{
            %% Análise com detrend
            %obj.description = 'Analise com Detrend';
            %obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'DETREND');
            %obj.processarFirstLevel('prefix', 'swdaruf*');
            %% Análise com detrend e regressores
            obj.description = 'Analise com Detrend e com Regressores';
            obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'DETREND+REGRESSORES');
            obj.processarFirstLevel('prefix', 'swdaruf*', 'regressores', true);
            %}
        end
        
        %% Esquema para executar o Second Level
        function secondLevel(obj)
        end
        
        function ajustaConditions(obj)
        end
    end
end