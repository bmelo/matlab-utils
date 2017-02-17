classdef PRJ1008_TVEP < handle & ProjectSPM
    properties
        %Atributos específicos do projeto
    end
    
    methods (Access = public)
        function obj=PRJ1008_TVEP()
            %Config
            obj.code = 'PRJ1008_TVEP';
            obj.description = 'Projeto Blindness';
            
            %Input        
            obj.baseDir = 'C:\Documents and Settings\sebastian\Desktop\PRJ1008_TVEP\';
            obj.rawDir = 'C:\Documents and Settings\sebastian\Desktop\PRJ1008_TVEP\RAW_DATA\';
            obj.subjects = 9; %Identificador dos sujeitos que serão analisados
            
            obj.prefixSubj = 'SUBJ'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
            obj.tamPadSubj = 3; %Quantidade de números na identificação de cada sujeito
            obj.numSessions = 1; %Quantidade de RUNs
%             obj.prefixSes = 'RUN'; %Irá ser usado caso o atributo pathSessions esteja vazio
%             obj.tamPadSes = 2;
            obj.pathSessions = {'RUN1'};
            
            %Output
            obj.folderPre = 'PREPROC_DATA';
            obj.folderFL = 'STATS';
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
                'SENTIR', 211:20:400, 10; ...
                'IMAG',   411:20:600, 10; ...
            };
 
            % Contrasts
%            obj.contrastes = FirstLevel.importContrastsXls( '\\172.19.1.180\Users$\sebastian\My Documents\MATLAB\processingSPM\docs\PRJ1008.xlsx' );

%             obj.contrastes = { ...
%                 'EXE',   [1 0 0]; ...
%                 'ORGULHO',  [0 0 1]; ...
%                 'TERNURA',  [0 1 0]; ...
%                 'ORGULHO - NEUTRO',  [-1 0 1]; ... %[-1 0 1.364]; ...
%                 'TERNURA - NEUTRO',  [-1 1 0]; ...%[-1 1.364 0]; ...
%                 'ORGULHO - TERNURA', [0 -1 1]; ...
%                 'TERNURA - ORGULHO', [0 1 -1]; ...
%                 'ORGULHO + TERNURA - NEUTRO', [-2 1 1]; ...%[-1.467 1 1]; ...
%                 };
            obj.filter = 128;
            
        end
    end
    
    methods (Access = protected)
        
        function batch(obj, varargin)
            
            obj.inDir = fullfile(obj.baseDir, obj.folderPre); %Diretório raiz das pastas dos sujeitos
            spm fmri;
            %% Preproc normal
            obj.dcm2nii();
            obj.processarPreproc();
        end
        
        function ajustaConditions(obj)
            condNames = {'EXE','SENTIR','IMAG'};
            for nses=1:obj.numSessions
                obj.conditions.sess(nses).cond(1).name = condNames{nses};
                obj.conditions.sess(nses).cond(1).onset = 11:20:200;
                obj.conditions.sess(nses).cond(1).duration = 10;
            end

%             if obj.procUnified
%                 obj.conditions.sess(2).cond(1).onset = obj.conditions.sess(2).cond(1).onset+200;
%                 obj.conditions.sess(3).cond(1).onset = obj.conditions.sess(3).cond(1).onset+400;
%             end
        end
    end
end