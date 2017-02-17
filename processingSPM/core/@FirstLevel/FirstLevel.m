classdef FirstLevel < handle & ProcessamentoSPM
  
  properties(SetAccess = public)
    %PROJECT NEEDS
    conditions = {};
    paramModulation = {};
    contrastes = {};
    filter = 128;
    units = 'scans'; %scans ou secs
    
    replicarContrastes = true;
    
    %Have defaults
    prefixFirstLvlImgs = 'swarf*';
    midLevel = {};
    regressores = false;
    multipleReg = {};
    outrosRegressoresPrefix = '';
    midLevelUnified = true; %Informa se os midlevels devem ser salvos em um unico arquivo
  end
  
  methods(Access = public)
    %In separated files
    processar(obj, varargin);
    
    function cons = getContrastesNames(obj, varargin)
      nReg = 0;
      cons = {};
      if ~isempty( varargin )
        nReg = varargin{1};
      end
      obj.ajustaContrastes( nReg );
      if obj.possuiMidLevel()
        for k=1:size(obj.contrastesMid,1)
          for j=1:size(obj.contrastesMid{k,2},1)
            cons{end+1} = [obj.contrastesMid{k,1} '_' obj.contrastesMid{k,2}{j,1}];
          end
        end
      else
        cons = obj.contrastes(:,1);
      end
    end
    
    function obj=FirstLevel( varargin )
      obj.openSPM = 0;
      if nargin == 1
        obj.populateData(varargin{1});
      end
    end
  end
  
  methods (Static = true)
    %In separated files
    contrasts = importContrastsXls( xlsFile );
    copySPMDataStat(dirIn, dirOut, varargin);
  end
  
  methods (Access = protected)
    %Faz a contagem de modulações paramétricas de um determinado RUN
    function quant = contarParamsModRun( obj, nses )
      quant = 0;
      if isstruct(obj.paramModulation) %Verifica se deve ou não calcular
        totalCond = length(obj.matlabbatch{1}.spm.stats.fmri_spec.sess(nses).cond);
        for ncond=1:totalCond
          quant = quant + length( obj.matlabbatch{1}.spm.stats.fmri_spec.sess(nses).cond(ncond).pmod );
        end
      end
    end
    
    % Ajusta os contrastes completando com zero e repetindo pela quantidade de RUNs
    function normalizaContrastes(obj, nReg)
      nCond = obj.numConditions();
      for k=1:length(obj.contrastes)
        %Faz a contagem para cada run
        totalCampos = nCond + nReg + obj.contarParamsModRun( 1 );
        
        if length(obj.contrastes{k,2}) > totalCampos
          obj.contrastes{k,2}(totalCampos+1:end) = [];
        elseif length(obj.contrastes{k,2}) < totalCampos
          obj.contrastes{k,2}(end+1:totalCampos) = 0;
        end
        obj.contrastes{k,2} = repmat(obj.contrastes{k,2},1,obj.numSessions);
      end
    end
    
    function num = numConditions(obj)
      if isstruct(obj.conditions)
        num = length(obj.conditions.sess(1).cond);
      else
        num = length(obj.conditions);
      end
    end
    
    function out = possuiMidLevel(obj)
      out = ~isempty(obj.midLevel);
    end
    
    %Verifica os parametros e ajusta para o MidLevel
    function ajustaContrastesMid(obj, nReg) %Ajustar constrastes quando existir midLevel
      nCond = obj.numConditions();
      nTot = nCond+nReg;
      for j=1:length(obj.midLevel)
        if length(obj.midLevel{j,2}) < obj.numSessions
          obj.midLevel{j,2}(end+1:obj.numSessions) = 0;
        end
        obj.contrastesMid{j,1} = obj.midLevel{j,1};
        operadores = zeros(1,nTot*obj.numSessions);
        for k=1:obj.numSessions
          operadores( (k-1)*nTot+1 : k*nTot ) = obj.midLevel{j,2}(k);
        end
        contrastesTemp = obj.contrastes;
        for k=1:length(contrastesTemp)
          contrastesTemp{k,2} = contrastesTemp{k,2}.*operadores;
        end
        obj.contrastesMid{j,2} = contrastesTemp;
      end
    end
    
    function limpaContrastes(obj)
      obj.matlabbatch{3}.spm.stats.con.consess = []; %Limpa os contrastes
    end
    
    function setContrastes(obj, contrastes)
      %% Ajustando os contrastes
      obj.limpaContrastes();
      for k=1:length(contrastes)
        obj.matlabbatch{3}.spm.stats.con.consess{k}.tcon.name = contrastes{k,1};
        obj.matlabbatch{3}.spm.stats.con.consess{k}.tcon.convec = contrastes{k,2};
        obj.matlabbatch{3}.spm.stats.con.consess{k}.tcon.sessrep = 'none';
      end
    end
    
    function addContrastes(obj, prefix, contrastes)
      for k=1:length(contrastes)
        contrastes{k,1} = [prefix '_' contrastes{k,1}];
        obj.addContraste(contrastes(k,:));
      end
    end
    
    function addContraste(obj, contraste)
      obj.matlabbatch{3}.spm.stats.con.consess{end+1}.tcon.name = contraste{1,1};
      obj.matlabbatch{3}.spm.stats.con.consess{end}.tcon.convec = contraste{1,2};
      obj.matlabbatch{3}.spm.stats.con.consess{end}.tcon.sessrep = 'none';
    end
    
    function executarAcoesContrastes(obj, fullOutDir)
      if obj.possuiMidLevel()
        if obj.midLevelUnified %Todos os estudos ficarao em um unico arquivo SPM.mat
          %obj.subject.label = [obj.subject.code '_CONTRASTES'];
          obj.limpaContrastes();
          for k = 1:length(obj.contrastesMid)
            obj.addContrastes(obj.contrastesMid{k,1},obj.contrastesMid{k,2});
          end
          obj.executarContrastes( fullfile(fullOutDir,'SPM.MAT + CONTRASTES'), fullOutDir );
        else  %Cada estudo tera seu diretorio
          for k = 1:length(obj.contrastesMid)
            obj.subject.label = [obj.subject.code '_' obj.contrastesMid{k,1}];
            obj.setContrastes( obj.contrastesMid{k,2} );
            obj.executarContrastes( fullfile(fullOutDir, obj.contrastesMid{k,1} ), fullOutDir );
          end
        end
      end
    end
    
    
    function executarFirstBatch(obj, dirOut)
      %Executando processamento
      if obj.parallel == 0
        if ~isempty( obj.subject )
          GenericModel.escreveTitulo( {sprintf('Executando job do sujeito %s', obj.subject.code), sprintf('Output: %s', dirOut)} );
        end
      end
      obj.matlabbatch{1}.spm.stats.fmri_spec.dir = {dirOut};
      obj.executar(dirOut, obj.matlabbatch, 1, 1);
    end
    
    %Remove os contrastes do batch
    function executarFirstLevel(obj, dirOut)
      %Executando processamento
      if obj.parallel == 0
        if ~isempty( obj.subject )
          GenericModel.escreveTitulo( {sprintf('Executando First Level do sujeito %s', obj.subject.code), sprintf('Output: %s', dirOut)} );
        end
      end
      obj.matlabbatch{1}.spm.stats.fmri_spec.dir = {dirOut};
      jobs = obj.matlabbatch;
      jobs(3) = [];
      obj.executar(dirOut, jobs, 1, 1);
    end
    
    function executarContrastes(obj, dirOut, dirIn)
      %Executando processamento
      [base name] = fileparts(dirOut);
      if obj.parallel == 0
        if ~isempty( obj.subject )
          GenericModel.escreveTitulo( {sprintf('Executando Contraste %s do sujeito %s',name, obj.subject.code), sprintf('Output: %s', dirOut)} );
        end
      end
      
      job = obj.matlabbatch(3); %Copia dados do job
      job{1}.spm.stats.con.spmmat = {fullfile(dirOut, 'SPM.mat')}; %Altera SPM que sera utilizado pelo job
      if obj.parallel
        obj.jobs{2}.createTask(@copySPMDataStat, 0, {dirIn, dirOut, job});
      else
        if ~obj.onlyExportScripts
          FirstLevel.copySPMDataStat(dirIn, dirOut);
        end
        obj.executar(dirOut, job, 0, 1);
      end
    end
    
    function ajustaContrastes(obj, varargin)
      nReg = 0;
      if ~isempty( varargin )
        nReg = varargin{1};
      elseif ~isempty( obj.subject )
        nReg = obj.subject.nReg(1);
      end
      if obj.replicarContrastes
        obj.normalizaContrastes( nReg );
      end
      if obj.possuiMidLevel()
        obj.ajustaContrastesMid( nReg );
      end
    end
  end
  
  methods(Access = private)
    %In separated files
    populaMatlabbatch(obj);
    organizeConditions(obj);    
    
    function preparaRun(obj)
      if( isempty(obj.numSessions) )
        obj.numSessions = obj.subject.getNumSes();
      end
      obj.organizeConditions();
      obj.populaMatlabbatch();
      if ~obj.regressores
        obj.ajustaContrastes(0); %Remove os regressores
      else
        obj.ajustaContrastes(); %Primeiro normaliza os constrastes e ajuste se tiver midLevel
      end
    end
    
    function processarParallel(obj) %todo PRECISA SER COMPLETAMENTE REFEITO!
      obj.parallel = 1;
      sched = findResource('scheduler', 'type', 'local');
      obj.jobs{1} = sched.createJob;
      obj.jobs{2} = sched.createJob; obj.jobs{2}.FileDependencies{1} = [pwd '/core/copySPMDataStat.m'];
      obj.preparaRun();
      for nsub=obj.subjects
        obj.nSub = nsub;
        obj.sSubj = sprintf(['%s%0' num2str(obj.tamPadSubj) 'd'],obj.prefixSubj,nsub); %Identificador do sujeito (SUBJ001)
        obj.sSubjDir = fullfile(obj.inDir, obj.sSubj); %Diretório do sujeito
        obj.codeSubj = obj.sSubj;
        
        if obj.ajustarBatchFirstLevel() %Verifica se o sujeito deve ser processado
          fullOutDir = fullfile(obj.outDir, obj.prefixProj, obj.sSubj ); %Diretorio de saída
          if obj.possuiMidLevel()
            obj.executarFirstLevel( fullOutDir );
            if obj.midLevelUnified
              obj.codeSubj = [obj.sSubj '_CONTRASTES'];
              obj.limpaContrastes();
              for k = 1:length(obj.contrastesMid)
                obj.addContrastes(obj.contrastesMid{k,1},obj.contrastesMid{k,2});
              end
              obj.executarContrastes( fullfile(fullOutDir,'COM_CONTRASTES'), fullOutDir );
            else
              for k = 1:length(obj.contrastesMid)
                obj.codeSubj = [obj.sSubj '_' obj.contrastesMid{k,1}];
                obj.setContrastes( obj.contrastesMid{k,2} );
                obj.executarContrastes( fullfile(fullOutDir, obj.contrastesMid{k,1} ), fullOutDir );
              end
            end
          else
            obj.setContrastes( obj.contrastes );
            obj.executarFirstBatch( fullOutDir );
          end
        end
      end
      
      GenericModel.escreveTitulo( '#### PROCESSANDO JOBS EM PARALELO ####' );
      %Processando primeiro bloco de jobs
      disp(['Gerando arquivos SPM.mat - ' num2str(length(obj.jobs{1}.tasks)) ' job(s); {Processando}']);
      obj.jobs{1}.submit;
      waitForState(obj.jobs{1}, 'finished');
      fprintf('%s \n\n', 'Done!');
      % Processando segundo bloco de jobs
      if( ~isempty(obj.jobs{2}.tasks) )
        disp(['Gerando contrastes - ' num2str(length(obj.jobs{2}.tasks)) ' job(s); {Processando}']);
        obj.jobs{2}.submit;
        waitForState(obj.jobs{2}, 'finished');
        fprintf('%s \n\n', 'Done!');
      end
      disp('Finished.')
      
      obj.parallel = 0;
    end
  end
end