classdef PRJ_TEST < handle & ProjectSPM 
    %PRJ_TEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Atributos específicos do projeto
    end
    
    methods (Access = public)
        function obj=PRJ_TEST()
            
            obj.numSessions = 1; %Quantidade de RUNs

            obj.baseDir = 'C:\Documents and Settings\sebastian\Desktop\TEST';
            obj.rawDir = 'C:\Documents and Settings\sebastian\Desktop\TEST\RAW_DATA';
            
            obj.prefixSubj = 'SUBJ'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
            obj.tamPadSubj = 3; %Quantidade de números na identificação de cada sujeito
            obj.numSessions = 3; %Quantidade de RUNs
%             obj.prefixSes = 'RUN'; %Irá ser usado caso o atributo pathSessions esteja vazio
%             obj.tamPadSes = 2;
            obj.pathSessions = {'fMRI_EXE', 'fMRI_IMAG_1P', 'fMRI_IMAG_3P'};
            
            obj.subjects = 5;
            
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
            obj.contrastes = FirstLevel.importContrastsXls( '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\processingSPM\docs\CONTRAST_TEST.xlsx' );

            obj.replicarContrastes = false;
            
            obj.filter = 128;
            
        end
    end
    
    methods (Access = protected)
                
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
        end
    end
end
   

