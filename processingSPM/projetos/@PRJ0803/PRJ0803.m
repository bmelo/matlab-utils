classdef PRJ0803 < handle & ProjectSPM
  properties
    %Atributos específicos do projeto
    parModFile = '';
  end
  
  methods (Access = public)
    function obj=PRJ0803()
      %Config
      obj.code = 'PRJ0803';
      obj.description = '';
      obj.units = 'secs';
      obj.parallel = true;
      
      %Input
      obj.baseDir = '/dados1/PROJETOS/PRJ0803_AFILIACAO/03_PROCS/PROC_DATA/';
      obj.baseDir = 'C:\Documents and Settings\bmelo\Desktop\Pastas Desktop\PROCESSAMENTOS\PRJ0803\SUBJECTS\';
      obj.rawDir = 'C:\Documents and Settings\bmelo\Desktop\PRJ1205\RAW_DATA';
      obj.subjects = 1:2; %Identificador dos sujeitos que serão analisados
      
      obj.prefixSubj = 'ATC'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
      obj.tamPadSubj = 3; %Quantidade de números na identificação de cada sujeito
      %           obj.numSessions = 4; %Quantidade de RUNs
      %           obj.prefixSes = 'RUN'; %Irá ser usado caso o atributo pathSessions esteja vazio
      %           obj.tamPadSes = 2;
      obj.pathSessions = {'RUN01', 'RUN02', 'RUN03', 'RUN04'};
      
      %Output
      obj.folderPre = 'PREPROC_DATA';
      obj.folderFL = 'SUBJECTS';
      obj.folderSL = 'SECOND_LEVEL';
      obj.prefixProj = ''; %Caso queira distinguir a pasta do projeto no diretorio de saida
      
      obj.inDir = fullfile( obj.baseDir, obj.folderFL );
      obj.outDir = fullfile( obj.baseDir, obj.folderFL );
      
      %Preproc
      obj.tr = 2;
      obj.nslices = 46;
      obj.voxelSize = [3 3 3];
      obj.smoothing = [6 6 6];
	  duration = 6;
      
      %FirstLevel
      obj.conditions = { ...
        {...
        'PROX', [11.25 33.79 45.06 124.01 157.87 169.16 203.15 225.73 259.59 270.87 293.45 304.73 361.17 372.45 428.89 451.46 474.03 519.18 553.04], duration;
        'SELF', [0 56.33 78.87 90.15 101.44 112.73 180.58 191.87 237.01 248.3 316.02 327.31 349.88 383.74 395.03 417.6 462.75 485.32 496.61 507.89 541.75], duration;
        },...
        {...
        'PROX', [22.54 33.83 67.69 90.26 112.83 124.12 135.41 146.69 225.7 236.99 248.27 293.42 338.57 394 428.86 440.15 451.43 462.72 507.87 519.15], duration;
        'SELF', [11.25 45.11 56.4 101.55 169.27 180.55 191.84 203.13 259.56 282.13 304.71 315.99 349.85 372.43 383.71 417.57 474.01 496.58 530.44 541.73], duration;
        },...
        {...
        'PROX', [22.54 56.4 67.69 78.97 101.55 112.83 146.69 157.98 248.27 270.85 315.99 338.57 349.85 361.14 383.71 417.57 428.86 451.43 485.29 519.15 530.44], duration;
        'SELF', [0 33.83 45.11 124.12 180.55 191.84 203.13 225.7 236.99 259.56 282.13 293.42 372.43 406.29 440.15 496.58 507.87 541.73 553.01], duration;
        },...
        {...
        'PROX', [33.84 45.13 67.7 135.42 146.71 158 169.28 237 248.29 282.15 304.72 316.01 327.3 406.3 428.88 474.02 496.6 507.88 519.17 541.74], duration;
        'SELF', [11.27 22.56 78.99 90.28 101.56 112.85 180.57 203.14 214.43 225.72 270.86 293.44 349.87 372.44 383.73 395.02 440.16 451.45 462.74 553.03], duration;
        },...
        };
      
      %Modulação Paramétrica
      obj.parModFile = '/dados1/PROJETOS/PRJ0803_AFILIACAO/03_PROCS/SCRIPTS/Entitativity_BM/SPM_parametric.xls';
      obj.parModFile = 'Z:\PRJ0803_AFILIACAO\03_PROCS\SCRIPTS\Entitativity_BM\SPM_parametric.xls';
      %obj.paramModulation = obj.importXls(parModFile, 'parametricModulation', 4:6);
      
      % Contrasts
      obj.replicarContrastes = true;
      obj.contrastes = { ...
        'PROX', [1 0 0 0 0 0 0 0]; ...
        'SELF', [0 0 0 0 1 0 0 0]; ...
        'PROX-SELF', [1 0 0 0 -1 0 0 0]; ...
        };
      obj.filter = 128;
    end
  end
  
  methods (Access = protected)
    
    function batch(obj, varargin)      
      %% Análise normal
      obj.description = 'Analise Normal';
      obj.contrastes = { ...
        'PROX', [0 1 0 0]; ...
        'SELF', [0 0 0 1]; ...
        'PROX-SELF', [0 1 0 -1]; ...
        };
      %BLOCO autobio
      obj.outDir = fullfile('/usr/local/MATLAB_SGE/1ST_LEVEL_PB/AUTOBIO');
      obj.outDir = fullfile('C:\Documents and Settings\bmelo\Desktop\AUTOBIO');
      obj.paramModulation = obj.importXls(obj.parModFile, 'parametricModulation', 4);
      obj.processarFirstLevel('prefix', 'dswtrf*img');
    end
    
  end
end