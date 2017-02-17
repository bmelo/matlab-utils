classdef PRJ1203 < handle & ProjectSPM
    properties
        %Atributos específicos do projeto
        type;
    end
    
    methods (Access = public)
        function obj=PRJ1203()
            %Definindo atributos herdados
            obj.baseDir = 'C:\Documents and Settings\bmelo\Desktop\PRJ1203';
            obj.rawDir = 'C:\Documents and Settings\bmelo\Desktop\PRJ1203\RAW_DATA';
            %Config
            obj.code = 'PRJ1203';
            obj.description = 'Projeto Cooperação Social';
            obj.type = 'CG'; % CE (Certainty Equivalence) or CG (Chicken Game)
            
            %Input
            obj.subjects = 7:11; %Identificador dos sujeitos que serão analisados
            
            obj.prefixSubj = 'SUBJ'; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
            obj.tamPadSubj = 3; %Quantidade de números na identificação de cada sujeito
            obj.numSessions = 4; %Quantidade de RUNs
            obj.prefixSes = 'RUN';
            obj.tamPadSes = 2;
            %obj.pathSessions = {'*_RUN1_*01', '*_RUN2_*01', '*_RUN3_*01', '*_RUN4_*01', '*_RUN5_*01'};
            
            %Output
            obj.folderPre = 'PREPROC_DATA';
            obj.folderFL = 'FIRST_LEVEL';
            obj.folderSL = 'SECOND_LEVEL';
            obj.prefixProj = ''; %Caso queira distinguir a pasta do projeto no diretorio de saida
            
            %Preproc
            obj.tr = 2;
            obj.nslices = 36;
            obj.voxelSize = [3 3 3];
            obj.smoothing = [6 6 6];
            
            %FirstLevel
            obj.units = 'secs';
            %Conditions - Name | Onsets | Duration
            obj.conditions = { ...
                'RISK DECISION', [], 4; ...
                %'NOT HIGH RISK DECISION', [], 4; ...
                'SECURE DECISION', [], 4; ...
                %'NOT VERY SECURE DECISION', [], 4; ...
                %'RIGHT HAND', [], 1;
                %'LEFT HAND',  [], 1;
                };
            
            %Contrats - Name | Contrast
            obj.contrastes = {
                'RISK - SECURE', [1 -1 0 0];
                'SECURE - RISK', [-1 1 0 0];
                %'HIGH RISK - SECURE', [1 0 -1 -1];
                %'VERY SECURE - RISK', [-1 -1 1 0];
                %'HIGH RISK - RISK E SECURE', [1 -1 -1 -1];
                %'VERY SECURE - RISK E SECURE', [-1 -1 1 -1];
                %'HIGH RISK - NOT HIGH RISK', [1 -1 0 0];
                %'VERY SECURE - NOT VERY SECURE', [0 0 1 -1];
                %'NOT HIGH RISK - HIGH RISK', [-1 1 0 0];
                %'NOT VERY SECURE - VERY SECURE', [0 0 -1 1];
                'RIGHT - LEFT', [0 0 1 -1];
                'LEFT - RIGHT', [0 0 -1 1];
                };
            if strcmp(obj.type, 'CG')
                obj.contrastes = {
                    'HAWK - DOVE', [1 -1 0 0 0];
                    'DOVE - HAWK', [-1 1 0 0 0];
                    'HAWK - DOVE (POS FEED)', [0 0 1 -1 0];
                    'DOVE - HAWK (POS FEED)', [0 0 -1 1 0];
                    };
            end;
            
            obj.filter = 128;
            
            %Linha abaixo é essencial!
            obj.initialize();
        end
    end
    
    methods (Static = true)
        %Funções em arquivos externos
        onsets = determinarOnsets( condition, log, varargin);
        onsets = determinarOnsetsCE( condition, log, varargin);
        onsets = determinarOnsetsCG( condition, log, varargin);
        out = lerLog(fullfilepath, varargin);
        out = attentionDecrease( totalPoints, maxV, minV, stablePointsB, stablePointsE );
        report( logFile, varargin );
    end
    
    methods (Access = protected)
        function batch(obj, varargin)
            %%{
            obj.inDir = fullfile(obj.baseDir, obj.folderPre); %Diretório raiz das pastas dos sujeitos
            %% Preproc normal
            %obj.dcm2nii();
            %obj.processarPreproc();
            %% Preproc unificado
            %obj.dcm2nii();
            %obj.processarPreproc( 'unificado', 1, 'etapas', {'realign', 'slicetiming', 'normalization', 'smooth'} );
            %% Preproc unificado aplicando detrend
            %obj.processarPreproc( 'unificado', 1, 'prefixoInicial', 'aru', 'etapas', {'detrend','normalization','smooth'} );
            %}
            
            %%{
            %% Executando análises de First Level
            obj.inDir = fullfile(obj.baseDir, obj.folderPre);
            %% Análise normal
            %%{
            %obj.description = 'Analise Normal';
            obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'NORMAL');
            %obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'POS-FEEDBACK');
            obj.processarFirstLevel();
            %% Análise com detrend
            %obj.description = 'Analise com Detrend';
            %obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'DETREND-SECS');
            %obj.processarFirstLevel('prefix', 'swdaruf*');
            %}
            %% Análise com detrend e regressores
            %obj.description = 'Analise com Detrend e com Regressores';
            %obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'DETREND+REGRESSORES');
            %obj.processarFirstLevel('prefix', 'swdaruf*', 'regressores', true);
            %obj.processarFirstLevelContrasts(); %Corrigindo bug
            
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
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK', 'groups', feed );
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'NOFEED', 'groups', noFeed );
            obj.processarSecondLevel( 'cons', cons, 'consNames', consNames, 'folder', 'FEEDBACK x NOFEED', 'groups', {feed; noFeed} );
            %}
        end
        
        function ajustaCondCE(obj)
            obj.ajustaSubject;
            %% Lendos CEs e definindo pontos altos
            CEs = xlsread(obj.subjectActual.params.pathCE);
            indiceAlto = .375;
            
            CEs(:,3) = CEs(:,2)*(1+indiceAlto);
            CEs(:,4) = CEs(:,2)*(1-indiceAlto);
            
            %% Ajustando as condições
            tempConds = {
                'RISK DECISION', [], 4;
                'SECURE DECISION', [], 4;
                'RIGHT HAND', [], 1;
                'LEFT HAND',  [], 1;
                'STOP', 7.5:20:600, 11.5;
                };
            obj.conditions = struct();
            for nses=1:obj.numSessions
                %% Lendo arquivos de Log
                log = PRJ1203.lerLog( obj.subjectActual.params.pathLogs{nses} );
                for ncond = 1:length(tempConds)
                    obj.conditions.sess(nses).cond(ncond).name = tempConds{ncond,1};
                    if strcmp( tempConds{ncond,1}, 'STOP' )
                        obj.conditions.sess(nses).cond(ncond).onset = tempConds{ncond,2};
                    else
                        obj.conditions.sess(nses).cond(ncond).onset = PRJ1203.determinarOnsetsCE(tempConds{ncond,1}, log, CEs, true);
                    end
                    obj.conditions.sess(nses).cond(ncond).duration = tempConds{ncond,3};
                end
            end
            obj.gerarRegressores();
        end
        
        function ajustaCondCG(obj)
            obj.ajustaSubject;
            %% Ajustando as condições
            tempConds = {
                'HAWK', [], 6;
                'DOVE', [], 6;
                'HAWK-POS', [], 4;
                'DOVE-POS', [], 4;
                'STOP', 12:20:500, 9;
                };
            obj.conditions = struct();
            for nses=1:obj.numSessions
                %% Lendo arquivos de Log
                log = PRJ1203.lerLog( obj.subjectActual.params.pathLogs{nses}, obj.type );
                for ncond = 1:length(tempConds)
                    obj.conditions.sess(nses).cond(ncond).name = tempConds{ncond,1};
                    if strcmp( tempConds{ncond,1}, 'STOP' )
                        obj.conditions.sess(nses).cond(ncond).onset = tempConds{ncond,2};
                    else
                        obj.conditions.sess(nses).cond(ncond).onset = PRJ1203.determinarOnsetsCG(tempConds{ncond,1}, log, true);
                    end
                    obj.conditions.sess(nses).cond(ncond).duration = tempConds{ncond,3};
                end
            end
            %obj.gerarRegressores();
        end
        
        function ajustaSubject(obj)
            rawSDir = fullfile(obj.rawDir, obj.subjectActual.code);
            if strcmp(obj.type, 'CE')
                obj.subjectActual.params.pathCE = fullfile(rawSDir, 'CE.xls');
            end;
            for nses=1:obj.numSessions
                obj.subjectActual.params.pathLogs{nses} = fullfile(rawSDir, [obj.pathSessions{nses} '.txt'] );
            end
        end
        
        function ajustaConditions(obj)
            eval( ['obj.ajustaCond' obj.type '();'] );
        end
    end
    
    methods(Access = public)
        
        function gerarRegressores(obj, totalTrials)
            if ~exist('totalTrials', 'var')
                totalTrials = 50;
            end
            duration = 5; %Em scans
            cPerc = 3; cValo = 4; cType = 7; cPuls = 8; %Colunas do arquivo de log
            for nsub=obj.subjects %Percorre todos os sujeitos
                obj.setSubject(nsub); %Prepara o sujeito
                obj.ajustaSubject(); %Colocar dados no atributo params
                CEs = xlsread( obj.subjectActual.params.pathCE ); %Resgata pontos CEs
                
                %Gerando regressores de Risco e Segurança
                for cond = {'RISK', 'SECURE'} %4 = Risk and 3 = Secure
                    for nses=1:obj.numSessions %Percorre todas as sessões definindo quais são os regressores e gerando os arquivos
                        filename = fullfile(obj.rawDir, obj.subjectActual.code, ['REG_' cond{1} '_' obj.subjectActual.getSes(nses) '_CEs.txt']);
                        valores = zeros(1, totalTrials);
                        log = PRJ1203.lerLog( obj.subjectActual.params.pathLogs{nses} );
                        limiar = 0.5;
                        for ce=1:length(CEs)
                            %indices = [-Inf 1-limiar:limiar/2:1+limiar Inf];
                            %indices( indices==1 ) = [];
                            %indices = indices*CEs(ce,2);
                            indices = [-Inf CEs(ce,2)-limiar:limiar:CEs(ce,2)+limiar Inf];
                            indices( indices==CEs(ce,2) ) = [];
                            tam = length(indices);
                            for k = 1:tam-1
                                if strcmp(cond{1}, 'RISK')
                                    posicoes = log{cType}==4 & log{cPerc}==(CEs(ce,1)/100) & log{cValo}>indices(k) & log{cValo}<=indices(k+1);
                                    valores(posicoes) = k;
                                else
                                    posicoes = log{cType}==3 & log{cPerc}==(CEs(ce,1)/100) & log{cValo}>indices(k) & log{cValo}<=indices(k+1);
                                    valores(posicoes) = tam-k;
                                end
                            end
                        end
                        %disp( length(find(valores)) );
                        valScans = arrayfun(@(x)([repmat(x,1,duration) repmat(0,1,3)]),valores,'UniformOutput', false);
                        valScans = [valScans{:}]; %Concatena todos os números
                        dlmwrite( filename, valScans', 'newline', 'pc' );
                    end
                end
            end
        end
        
    end
end