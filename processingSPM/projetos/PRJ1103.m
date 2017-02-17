classdef PRJ1103 < handle & ProjectSPM
    properties
        %Atributos específicos do projeto
        NFB = [];
    end
    
    methods (Access = public)
        function obj=PRJ1103()
            %Definindo atributos herdados
            obj.baseDir = 'C:\Documents and Settings\bmelo\Desktop\PRJ1103';
            obj.rawDir = 'C:\Documents and Settings\bmelo\Desktop\PRJ1103\RAW_DATA';
            %Config
            obj.code = 'PRJ1103';
            obj.description = 'Projeto Neurofeedback Afiliativo';
            
            %Input
            obj.subjects = [
                18 21 23 25 26 27 28 29 31 34 35 38 48 52 ...
                20 22 24 30 32 33 36 37 39 40 41 43 49 50
                ]; %Identificador dos sujeitos que serão analisados
            
            obj.prefixSubj = 'CTL'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
            obj.tamPadSubj = 3; %Quantidade de números na identificação de cada sujeito
            obj.numSessions = 4; %Quantidade de RUNs
            obj.prefixSes = 'RUN';
            obj.tamPadSes = 2;
            
            %Output
            obj.folderPre = 'PREPROC_DATA';
            obj.folderFL = 'FIRST_LEVEL';
            obj.folderSL = 'SECOND_LEVEL';
            obj.prefixProj = ''; %Caso queira distinguir a pasta do projeto no diretorio de saida
            obj.pathSessions = {'fMRI_NFB_RUN1_PRJ1103_*', 'fMRI_NFB_RUN2_PRJ1103_*', 'fMRI_NFB_RUN3_PRJ1103_*', 'fMRI_NFB_RUN4_PRJ1103_*'};
            
            %Preproc
            obj.tr = 2;
            obj.nslices = 22;
            obj.voxelSize = [3 3 3];
            obj.smoothing = [6 6 6];
            
            %FirstLevel
            obj.conditions = { ...
                'NEUTRO', 1:37:296, 15; ...
                'TERNURA', [53  90 201 238], 22; ...
                'ORGULHO', [16 127 164 275], 22; ...
                };
            obj.contrastes = { ...
                'NEUTRO',   [1 0 0]; ...
                'ORGULHO',  [0 0 1]; ...
                'TERNURA',  [0 1 0]; ...
                'ORGULHO - NEUTRO',  [-1 0 1]; ... %[-1 0 1.364]; ...
                'TERNURA - NEUTRO',  [-1 1 0]; ...%[-1 1.364 0]; ...
                'ORGULHO - TERNURA', [0 -1 1]; ...
                'TERNURA - ORGULHO', [0 1 -1]; ...
                'ORGULHO + TERNURA - NEUTRO', [-2 1 1]; ...%[-1.467 1 1]; ...
                };
            obj.filter = 448;
            
            obj.midLevel = {
                'RUN01',  [1 0 0 0]; ...
                'RUN02',  [0 1 0 0]; ...
                'RUN03',  [0 0 1 0]; ...
                'RUN04',  [0 0 0 1]; ...
                'RUN04 - RUN02',  [0 -1 0 1]; ...
                'RUN02 - RUN04', [0 1 0 -1]; ...
                'RUN04 - RUN01', [-1 0 0 1]; ...
                'RUN01 - RUN04', [1 0 0 -1]; ...
                '(RUN02 RUN03 RUN04)', [0 1 1 1]; ...
                '(RUN02 RUN03 RUN04) - RUN01', [-3 1 1 1]; ...
                'ALL', [1 1 1 1]; ...
                };
            
            %% NFB01
            obj.NFB(1).subjects = [18 21 23 25 26 27 28 29 31 34 35 38 48 52];
            obj.NFB(1).neutro.onsets = 1:37:296;
            obj.NFB(1).neutro.duracao = 15;
            obj.NFB(1).ternura.onsets = [53 90 201 238];
            obj.NFB(1).ternura.duracao = 22;
            obj.NFB(1).orgulho.onsets = [16 127 164 275];
            obj.NFB(1).orgulho.duracao = 22;
            
            %% NFB02
            obj.NFB(2).subjects = [20 22 24 30 32 33 36 37 39 40 41 43 49 50];
            obj.NFB(2).neutro.onsets = 1:37:296;
            obj.NFB(2).neutro.duracao = 15;
            obj.NFB(2).ternura.onsets = [16 127 164 275];
            obj.NFB(2).ternura.duracao = 22;
            obj.NFB(2).orgulho.onsets = [53 90 201 238];
            obj.NFB(2).orgulho.duracao = 22;
        end
    end
    
    methods (Access = protected)
        
        function batch(obj, varargin)
            %{
            obj.inDir = fullfile(obj.baseDir, obj.folderPre); %Diretório raiz das pastas dos sujeitos
            spm fmri;
            %% Preproc normal
            obj.dcm2nii();
            obj.processarPreproc();
            %% Preproc unificado
            obj.dcm2nii();
            obj.processarPreproc( 'unificado', 1, 'etapas', {'realign', 'slicetiming', 'detrend', 'normalization', 'smooth'} );
            %% Preproc unificado aplicando detrend
			spm('quit');
            %obj.processarPreproc( 'unificado', 1, 'prefixoInicial', 'aru', 'etapas', {'detrend','normalization','smooth'} );
            %}
            
            %% Executando análises de First Level
            obj.inDir = fullfile(obj.baseDir, 'PROC_DATA');
            %% Análise normal
            %{
            obj.description = 'Analise Normal';
            obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'NORMAL');
            obj.processarFirstLevel();
            %% Análise com detrend
            obj.description = 'Analise com Detrend';
            obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'DETREND');
            obj.processarFirstLevel('prefix', 'swdaruf*');
            %}
            %% Análise com detrend e regressores
            obj.description = 'Analise com Detrend e com Regressores';
            obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'DETREND+REGRESSORES');
            %obj.processarFirstLevel('prefix', 'swdaruf*', 'regressores', true);
            obj.processarFirstLevelContrasts(); %Corrigindo bug
            
            
        end
        
        function secondLevel(obj)
            %% Second Level
            %Identificador dos sujeitos que serão analisados
            obj.subjects = [ 18 20:41 43 48:50 52 ];
            cons = [4:7 28:31 36:39 52:55 68:71 76:79 84:87]; %Contrastes que serão trabalhados
            feed.val    = [21 22 25 26 27 30 31 32 36 38 40 41 49 52];
            feed.name   = 'FEEDBACK';
            noFeed.val  = [18 20 23 24 28 29 33 34 35 37 39 43 48 50];
            noFeed.name = 'NOFEED';
            %Analise NORMAL
            consNames = obj.getContrastesNames();
            obj.description = 'Analise Normal';
            obj.inDir  = fullfile(obj.baseDir, obj.folderFL, 'NORMAL\<SUBJECT>\SPM.MAT + CONTRASTES');
            obj.outDir = fullfile(obj.baseDir, obj.folderSL, 'NORMAL');
            %obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK', 'groups', feed );
            %obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'NOFEED', 'groups', noFeed );
            %obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK x NOFEED', 'groups', {feed; noFeed} );
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'ALL', 'groups', [feed noFeed] );
            
            %{
            %Analise com DETREND
            obj.description = 'Analise com Detrend';
            obj.inDir  = fullfile(obj.baseDir, obj.folderFL, 'DETREND\<SUBJECT>\SPM.MAT + CONTRASTES');
            obj.outDir = fullfile(obj.baseDir, obj.folderSL, 'DETREND');
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK', 'groups', feed );
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'NOFEED', 'groups', noFeed );
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK x NOFEED', 'groups', {feed; noFeed} );
            
            %Analise com DETREND+REGRESSORES
            obj.description = 'Analise com Detrend e com Regressores';
            obj.inDir  = fullfile(obj.baseDir, obj.folderFL, 'DETREND+REGRESSORES\<SUBJECT>\SPM.MAT + CONTRASTES');
            obj.outDir = fullfile(obj.baseDir, obj.folderSL, 'DETREND+REGRESSORES');
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK', 'groups', feed );
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'NOFEED', 'groups', noFeed );
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK x NOFEED', 'groups', {feed; noFeed} );
            %}
        end
        
        function ajustaConditions(obj)
            obj.conditions = struct();
            if find(obj.NFB(1).subjects == obj.subjectActual.num)
                nNFB = [1 2 1 2];
            else
                nNFB = [2 1 2 1];
            end
            for nses=1:obj.numSessions
                obj.conditions.sess(nses).cond(1).name = 'NEUTRO';
                obj.conditions.sess(nses).cond(1).onset = obj.NFB( nNFB(nses) ).neutro.onsets;
                obj.conditions.sess(nses).cond(1).duration = obj.NFB( nNFB(nses) ).neutro.duracao;
                obj.conditions.sess(nses).cond(2).name = 'TERNURA';
                obj.conditions.sess(nses).cond(2).onset = obj.NFB( nNFB(nses) ).ternura.onsets;
                obj.conditions.sess(nses).cond(2).duration = obj.NFB( nNFB(nses) ).ternura.duracao;
                obj.conditions.sess(nses).cond(3).name = 'ORGULHO';
                obj.conditions.sess(nses).cond(3).onset = obj.NFB( nNFB(nses) ).orgulho.onsets;
                obj.conditions.sess(nses).cond(3).duration = obj.NFB( nNFB(nses) ).orgulho.duracao;
            end
        end
    end
end