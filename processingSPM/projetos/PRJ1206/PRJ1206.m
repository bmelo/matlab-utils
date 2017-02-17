classdef PRJ1206 < handle & ProjectSPM
    properties
        %Atributos específicos do projeto
    end
    
    methods (Access = public)
        function obj=PRJ1206()
            %Config
            obj.code = 'PRJ1206';
            obj.description = 'Projeto Blindness';
            
            %Input        
            obj.baseDir = 'C:\Documents and Settings\sebastian\Desktop\TEST_PROCESSAMENTO\fMRI\';
            obj.rawDir = 'C:\Documents and Settings\sebastian\Desktop\TEST_PROCESSAMENTO\fMRI\RAW_DATA';
            %obj.subjects = 5; %Identificador dos sujeitos que serão analisados
            
            obj.prefixSubj = 'SUBJ'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
            obj.tamPadSubj = 3; %Quantidade de números na identificação de cada sujeito
            obj.numSessions = 3; %Quantidade de RUNs
%             obj.prefixSes = 'RUN'; %Irá ser usado caso o atributo pathSessions esteja vazio
%             obj.tamPadSes = 2;
            obj.pathSessions = {'fMRI_EXE', 'fMRI_IMAG_1P', 'fMRI_IMAG_3P'};
            
            %Output
            obj.folderPre = 'PREPROC_DATA';
            obj.folderFL = 'STATS_SINGLE_SUBJECT';
            obj.folderFLF = 'STATS_MULTIPLE_SUBJECT';
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
                'EXE',    11:20:200, 10; ...
                '1P',    211:20:400, 10; ...
                '3P',    411:20:600, 10; ...
            };
 
            % Contrasts
            obj.contrastes = FirstLevel.importContrastsXls( '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\processingSPM\docs\PRJ1206_REST.xlsx' );


            obj.filter = 128;
            
            obj.midLevel = {
                'EXE',  [1 0 0]; ...
                '1P',  [0 1 0]; ...
                '3P',  [0 0 1]; ...
                };
            
            
        end
    end
    
    methods (Access = protected)
        function batch(obj, varargin)
            
            %% Executando análises de First Level
            %obj.inDir = fullfile(obj.baseDir, obj.folderPre);
            %% Análise normal
            if 0 
                obj.description = 'Analise Normal';
                obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'NORMAL_REST');
                obj.processarFirstLevel();
            else
                
                obj.description = 'First Level Fixed';
                obj.midLevel = 1;
                obj.outDir = fullfile(obj.baseDir, obj.folderFLF, ['NORMAL_REST' sprintf( '_%i', obj.subjects )] );
                obj.processarFirstLevelFixed();
            end
%             %% Análise com Regressores
%             obj.description = 'Analise com Regressores';
%             obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'NORMAL+REGRESSORES');
%             obj.processarFirstLevel();


            
        end
        
        function ajustaConditions(obj)
            condNames = {'EXE','1P','3P'};
            for nses=1:obj.numSessions
                obj.conditions.sess(nses).cond(1).name = condNames{nses};
                obj.conditions.sess(nses).cond(1).onset = 11:20:200;
                obj.conditions.sess(nses).cond(1).duration = 10;
                obj.conditions.sess(nses).cond(2).name = 'REST';
                obj.conditions.sess(nses).cond(2).onset = 21:20:200;
                obj.conditions.sess(nses).cond(2).duration = 10;
            end

%             if obj.procUnified
%                 obj.conditions.sess(2).cond(1).onset = obj.conditions.sess(2).cond(1).onset+200;
%                 obj.conditions.sess(3).cond(1).onset = obj.conditions.sess(3).cond(1).onset+400;
%             end
        end
    end
end