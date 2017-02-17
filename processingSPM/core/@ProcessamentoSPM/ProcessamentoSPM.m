classdef ProcessamentoSPM < handle & GenericModel
    
    properties
        subject; %Precisa ser objeto da classe Subject
    end
    
    properties(SetAccess = protected)
        matlabbatch;
        curdir = pwd;
        contrastesMid;
        naoProcessados = [];
        logfile = [];
        jobs = [];
        posfixNameScript = '';
        startTime = [];
        finishTime;
        cluster;
    end
    
    methods (Access = private)  
        % Verifica se todos os diretórios existem
        function checkDirs(obj)
            for nses=1:obj.numSessions
                if ~isempty( obj.subject )
                    if isempty( obj.subject.getSesDir(nses) ) %Se diretorio do RUN nao existir, processamento do sujeito será ignorado
                        obj.error = MException('FirstLevel:DirInexistente', 'Não foi possível encontrar o diretório da sessão: %s', obj.subject.getSesDir(nses));
                    end
                end
            end
        end
    end
    
    methods (Access = protected)
        %Retorna o tipo da classe que está sendo utilizada no processamento
        function out=codeProc(obj)
            out = class(obj);
        end
        
        function logSucesso(obj, msg, varargin)
            if nargin==3
                fullLogFileName = varargin{1};
            else    
                fullLogFileName = fullfile(obj.outDir,['execucao_' obj.logfile]);
            end
            ProcessamentoSPM.escreveLog( fullLogFileName, msg );
            fprintf('Log de execução ''%s'' atualizado!\n', fullLogFileName);
        end
        
        function logErro(obj, msg)
            fullLogFileName = fullfile(obj.outDir, 'errors.log');
            sid = '';
            if ~isempty( obj.subject )
                sid = sprintf('%s', obj.subject.label);
            end
            msg = sprintf('---- ERRO SUJEITO %s | %s\n%s', sid, obj.codeProc, msg);
            ProcessamentoSPM.escreveLog( fullLogFileName, msg );
            fprintf('Log de erro ''%s'' atualizado!\n', fullLogFileName);
        end
        
        function execFinished(obj)
            if obj.openSPM && ~obj.parallel
                spm('quit');
            end
            
            if obj.parallel
              obj.cluster.submitJob();
            end

            obj.finishTime = now;
            if ~isempty(obj.subject)
                textTime = sprintf('%s - %s - %s\nTempo total: %s\n', obj.code, obj.codeProc, obj.subject.label, obj.tempoTotal());
            else
                textTime = sprintf('%s - %s\nTempo total: %s\n', obj.code, obj.codeProc, obj.tempoTotal());
            end
            if obj.loggar
                obj.logSucesso( textTime , fullfile(obj.outDir,'execution_time.log'));
            end
            disp(textTime);
            diary off;
            clc;
        end
        
        function processar = checkDataToProcess(obj)
            processar = 1;
            try
                obj.checkDirs();
            catch Er
                obj.error = MException('Processamento:CheckDirs', 'Ocorreu algum problema na verificação de pastas do sujeito %s', obj.subject.label);
                obj.error = obj.error.addCause(Er);
                processar = 0;
            end
        end
        
        function out = checkRewrite(obj, filename)
            out = obj.rewrite || ~isdir(filename);
        end
        
        function files = selectAllFiles(obj, pattern, varargin)
            %Retorna todos os arquivos de um determinado sujeito e que
            %atende ao pattern. sSubjDir precisa estar definida!
            files = cell(1,obj.numSessions);
            if ~isempty(varargin{1}) %Para tratar output
                unified = varargin{1};
            end
            for nses=1:obj.numSessions
                dirSesSubj = obj.subject.getSesDir(nses);
                if unified %Todos os arquivos ficarão em um único vetor
                    files{1} = [files{1}; Preproc.selectFilesDir(dirSesSubj, pattern)];
                else
                    files{1,nses} = Preproc.selectFilesDir(dirSesSubj, pattern);
                end
            end;
            files = files(~cellfun('isempty',files)); %Limpa dados desnecessários
            if unified & ~isempty(files)
                files = files{1};
            end
        end
        
        function executar(obj, dirOut, matlabbatch, varargin)
            checar = 0;
            if ~isempty(varargin)
                checar = varargin{1};
            end
            %Caso tenha que fazer a checagem de reescrita
            if checar && obj.checkRewrite( dirOut )
                if isdir(dirOut)
                    try
                        rmdir(dirOut, 's');
                    catch
                        warning('could not remove directory')
                    end
                end
            end
            %Verifica se o diretório de saída existe, caso contrário o cria
            if ~isdir(dirOut)
                mkdir(dirOut);
            end
            %Trata exportacao de SCRIPTS
            if obj.export
                if ~isempty(obj.subject) %Second Level não possui subject
                    filename = [obj.code '-' obj.codeProc '-' obj.subject.code obj.posfixNameScript '.mat'];
                else
                    filename = [obj.code '-' obj.codeProc obj.posfixNameScript '.mat'];
                end
                if ~isdir( fullfile( dirOut, 'SCRIPTS') )
                    mkdir( fullfile( dirOut, 'SCRIPTS') );
                end
                save(fullfile( dirOut, 'SCRIPTS', filename ), 'matlabbatch');
            end
            %Executa o processamento
            if ~obj.onlyExportScripts
                if ~obj.parallel
                    spm_jobman('run', {matlabbatch});
                else
                    obj.cluster.addTask( 0, @spm_jobman, 1, {'run', matlabbatch} );
                end
            end
        end
        
    end
    
    methods(Access=protected, Static=true)
        function out = selectFilesDir(dirImgs, pattern)
            imagens = dir(fullfile(dirImgs,pattern)); %lista as imagens que serão usadas no processamento
            out = cell(size(imagens,1),1); %Pre-aloca espaço para imagens
            for j=1:size(imagens,1) %Percorre todas as imagens encontradas e insere no array
                out{j} = fullfile(dirImgs,imagens(j).name);
            end;
        end
    end
    
    methods(Access = private, Static=true)
        function escreveLog(filename, msg)
            file = fopen( filename, 'a');
            if file
                fprintf(file, '%s', msg );
                fclose(file);
            end
        end
    end
    
    methods (Access = public)
        function processar(obj)
            clc;
            obj.startTime = now;
            if(obj.parallel) %Inicializa o cluster
              obj.cluster = Parallel( 'sge_spm' );
              obj.cluster.addJob();
            end
            if ~strcmp(class(obj), 'SecondLevel') && ~strcmp(class(obj), 'FirstLevelFixed')
                if isempty(obj.subject)
                    obj.error = MException(sprintf('%s:WithoutSubject',class(obj)), 'O Sujeito do processamento não foi especificado.');
                    return;
                end
                if ~isdir(obj.subject.fullPath)
                    mkdir(obj.subject.fullPath);
                end
                diary( fullfile(obj.subject.fullPath, [datestr(now,'yyyy-mm-dd_HH-MM-SS') '.output.txt']) );
            else
                if ~isdir(obj.outDir)
                    mkdir(obj.outDir);
                end
                diary( fullfile(obj.outDir, [datestr(now,'yyyy-mm-dd_HH-MM-SS') '.output.txt']) );
            end
            %Verifica se o SPM deve ser aberto
            if obj.openSPM && ~obj.parallel
                spm('fmri');
                spm_jobman('initcfg');
            end
        end
        
        function obj = ProcessamentoSPM()
            obj.logfile = [datestr(now, 'yyyymmdd_HHMMSS') '.log'];
        end            
        
        function out = tempoTotal(obj)
            out = datestr(obj.finishTime-obj.startTime, 13);
        end
        
        function checkErros(obj)
            if ~isempty(obj.error) %Tratamento de erros!
                disp('Processamento finalizado com erros!');
                obj.logErro(obj.error.getReport());
                disp(obj.error.getReport());
                for k=1:length(obj.error.cause)
                    disp(obj.error.cause{k}.getReport());
                end
                ER = obj.error;
                obj.error = [];
                if obj.stopIfError
                    throw(ER);
                end
            end
        end
        
        function delete(obj) %Método destruidor do objeto
            cd(obj.curdir); %Volta ao diretório de trabalho
            obj.checkErros();
            if obj.logoff
                system('shutdown -l');
                return;
            end
        end
    end
    
end