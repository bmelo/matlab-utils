classdef ProjectSPM < handle & GenericModel
    
    properties(Constant=true)
        %Colocar componentes aqui
        compDcm2nii = Dcm2nii();
    end
    
    properties (Access = public)        
        %Preproc
        tr = 2;
        nslices = 22;
        voxelSize = [3 3 3];
        smoothing = [6 6 6];
        
        %FirstLevel
        conditions;
        paramModulation;
        contrastes;
        filter = 128;
        units = 'scans';
        midLevel = {};
        regressores = false;
        multipleReg = {};
        outrosRegressoresPrefix = '';
        replicarContrastes = true;
        midLevelUnified = true; %Informa se os midlevels devem ser salvos em um unico arquivo
        
        %Entrada de dados
        subjects; %Identificador dos sujeitos que serão analisados
        subjectActual;
        prefixSubj; %Para formar o nome das pastas de cada sujeito (SUBJ001, SUBJ002)
        tamPadSubj; %Quantidade de números na identificação de cada sujeito
        prefixSes;
        tamPadSes;
        pathSessions = {}; %Se definido, os parametros acima não são usados
        
        %Outros
        rawDir    = '';
        baseDir   = '';
        folderPre = 'PROC_DATA';
        folderFL  = 'OUTPUT';
        folderFLF = 'FIRST_LEVEL_FIXED';
        folderSL  = 'ANALYSIS';
    end
    
    properties (Access = private)
        processamento;
        procParameters;
    end
    
    %% Abaixo estão as funções que podem ser invocadas pelos scripts
    methods (Access = public)
        regressores = getRegressores(obj);
        
        function obj = ProjectSPM()
            obj.subjectActual = Subject('', '');
        end
        
        %Prepara o objeto
        function obj = initialize(obj)
            %Check path sessions
            if isempty(obj.pathSessions)
                obj.pathSessions = cell(obj.numSessions,1);
                for k=1:obj.numSessions
                    obj.pathSessions{k} = sprintf(['%s%0' num2str(obj.tamPadSes) 'd'], obj.prefixSes, k);
                end
            end
        end
        
        function contrastesNorm = getContrastesNames(obj)
            FL = FirstLevel(obj);
            contrastesNorm = FL.getContrastesNames(6);
        end
        
        function subjs = getAllSubjects(obj, varargin)
            subjs = {};
            for nsub=obj.subjects
                subject = Subject('', obj.inDir);
                obj.setSubject(nsub, subject);
                subjs{end+1} = obj.subjectActual;
            end
        end
        
        function dcm2nii(obj)
            tempSubjActual = obj.subjectActual.code;
            for k=1:length(obj.subjects)
                obj.setSubject(obj.subjects(k));
                dirIn = fullfile(obj.rawDir, obj.subjectActual.label);
                dirOut = fullfile(obj.inDir, obj.subjectActual.label);
                fprintf('\n\nConvertendo imagens DICOM > NIFTI - Subject %s\nDir In:  %s\nDir Out: %s\n', obj.subjectActual.label, dirIn, dirOut );
                tic;
                evalc( 'obj.compDcm2nii.exec( dirIn, dirOut, obj.pathSessions );' ); %Desta forma o output não é colocado no matlab
                toc;
            end
            obj.setSubject(tempSubjActual);
        end
        
        function clean(obj, varargin)
            curdir = pwd;
            obj.subjectActual = Subject('', obj.inDir);
            pattern = 'rf*nii arf*nii warf*nii ruf*nii aruf*nii waruf*nii swaruf*nii daruf*nii wdaruf*nii fM*nii';
            if ~isempty(varargin)
                pattern = varargin{1};
            end
            for nsub=obj.subjects
                obj.setSubject(nsub);
                for j=1:obj.numSessions
                    cd( obj.subjectActual.getSesDir(j) );
                    eval(['delete ' pattern]); 
                end
            end
            cd(curdir);
            fprintf('Limpeza de imagens realizada! (%s)\n', pattern);
        end
        
        function processarPreproc(obj, varargin)
            obj.setProcParameters(varargin);
            obj.processar( 'Preproc' );
        end
        
        function processarFirstLevel(obj, varargin)
            obj.setProcParameters(varargin);
            obj.processar( 'FirstLevel' );
        end
        
        function processarFirstLevelFixed(obj, varargin)
            obj.setProcParameters(varargin);
            obj.processar( 'FirstLevelFixed' );
        end
        
        function processarFirstLevelContrasts(obj)
            for nsub = obj.subjects
                obj.processamento = FirstLevel(obj);
                obj.setSubject(nsub);
                obj.processamento.subject = obj.subjectActual;
                obj.processamento.processar(1);
            end
        end
        
        function processarSecondLevel(obj, varargin)
            obj.setProcParameters(varargin);
            obj.processamento = SecondLevel(obj);
            obj.secondLevelSettings();
            for con = obj.procParameters.cons
                obj.processamento.subject = [];
                obj.processamento.contraste = con;
                obj.processamento.contrasteName = obj.procParameters.consNames{con};
                obj.processamento.processar();
                obj.processamento.checkErros();
            end
            obj.processamento.delete();
        end
        
        %Executa cada processo com todos os subjects p/ depois mudar de processo
        function execBatch(obj)
            obj.batch();
        end
              
        %Executa todos processos por subject p/ depois mudar de subject
        function execBatchIndividualmente(obj)
            allSubjects = obj.subjects;
            for k=1:length(allSubjects)
                obj.subjects = allSubjects(k);
                obj.batch();
            end
            obj.subjects = allSubjects;
        end
        
        %Executa o plano para o second level
        function execSecondLevel(obj)
            obj.secondLevel();
        end
    end
    
    methods (Static = true)
      data = importXls(xlsFile, tipo, varargin)
    end
    
    methods (Access = protected)
        function ajustaConditions(obj)
        end
        
        function secondLevel(obj)
        end
        
        function batch(obj, varargin)
            obj.processarPreproc();
            obj.processarFirstLevel();
            %obj.processarSecondLevel();
        end
        
        function setSubject(obj, numSubj, varargin)
            if(isnumeric(numSubj))
                code = sprintf(['%s%0' num2str(obj.tamPadSubj) 'd'],obj.prefixSubj,numSubj); %Identificador do sujeito (SUBJ001)
            else
                code = numSubj;
            end;
            if ~isempty(varargin)
                obj.subjectActual = varargin{1};
            end
            obj.subjectActual.pathRoot = obj.inDir;
            obj.subjectActual.setCode(code);
            obj.subjectActual.num = numSubj;
            obj.subjectActual.pathSessions = obj.pathSessions;
            obj.subjectActual.prefixSes = obj.prefixSes;
            obj.subjectActual.tamPadSes = obj.tamPadSes;
            obj.subjectActual.sessions = obj.numSessions;
        end
        
        function setProcParameters(obj, parametros)
            for k = find(cellfun(@iscell, parametros))
                parametros{k} = parametros(k);
            end
            if ~isempty(parametros)
                obj.procParameters = struct(parametros{1:end});
            end
        end
        
        function preprocSettings(obj, varargin)
            obj.processamento.subject = obj.subjectActual;
            %Tratando forma Unificada ou Não
            if( isfield( obj.procParameters , 'unificado') )
                obj.processamento.unifiedRealign = obj.procParameters.unificado;
            end
            %Tratando prefixo inicial
            if( isfield( obj.procParameters , 'prefixoInicial')  )
                obj.processamento.prefixoAtual =  obj.procParameters.prefixoInicial;
            elseif obj.processamento.unifiedRealign
                obj.processamento.prefixoAtual = 'u';
            end
            
            if( isfield( obj.procParameters , 'prefixoRaw')  )
                obj.processamento.prefixoRaw = obj.procParameters.prefixoRaw;
            end
            %Tratando ordem de processamentos
            if( isfield( obj.procParameters , 'etapas')  )
                obj.processamento.ordem = obj.procParameters.etapas;
            end
        end
        
        function firstLevelSettings(obj)
            obj.processamento.subject = obj.subjectActual;
            %Tratando entradas
            if( isfield( obj.procParameters , 'prefix') )
                obj.processamento.prefixFirstLvlImgs = obj.procParameters.prefix;
            end
            if( isfield( obj.procParameters , 'regressores') )
                obj.processamento.regressores = obj.procParameters.regressores;
            end
            obj.ajustaConditions();
            obj.processamento.conditions = obj.conditions;
        end
        
        function secondLevelSettings(obj)
            obj.processamento.subject = obj.subjectActual;
            %Tratando entradas
            if( isfield( obj.procParameters , 'folder') )
                obj.processamento.folder = obj.procParameters.folder;
            end
            if( isfield( obj.procParameters , 'groups') )
                obj.processamento.groups = obj.procParameters.groups;
            end
            obj.processamento.subjects = obj.getAllSubjects();
        end
        
        function firstLevelFixedSettings(obj)
            %Tratando entradas
            if( isfield( obj.procParameters , 'prefix') )
                obj.processamento.prefixFirstLvlImgs = obj.procParameters.prefix;
            end
            if( isfield( obj.procParameters , 'regressores') )
                obj.processamento.regressores = obj.procParameters.regressores;
            end
            obj.ajustaConditions();
            obj.processamento.conditions = obj.conditions;
            
            if( isfield( obj.procParameters , 'folder') )
                obj.processamento.folder = obj.procParameters.folder;
            end
            obj.processamento.subjects = obj.getAllSubjects();
        end
        
        function processar(obj, processamento)
            % processo todos os sujeitos de uma vez
            if strcmp( processamento, 'FirstLevelFixed' )
                obj.processamento = FirstLevelFixed(obj);
                obj.firstLevelFixedSettings();
                obj.processamento.processar();
                obj.processamento.checkErros();
                obj.processamento.delete();
            else
                for nsub=obj.subjects %Percorre todos os sujeitos
                    obj.setSubject(nsub);
                    switch( processamento )
                        case 'Preproc'
                            obj.processamento = Preproc(obj);
                            obj.preprocSettings();
                        case 'FirstLevel'
                            obj.processamento = FirstLevel(obj);
                            obj.firstLevelSettings();
                        otherwise
                            return;
                    end
                    obj.processamento.processar();
                    obj.processamento.checkErros();
                    obj.processamento.delete();
                end
            end
        end
    end
    
end