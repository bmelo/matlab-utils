classdef Subject < handle
    %SUBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private, GetAccess = public)
        code = '';
        sFullPath = '';
    end
    
    properties
        num;
        pathSessions;
        pathRoot = '';
        prefixSes;
        tamPadSes;
        regressores;
        label = '';
        sessions;
        params = struct();
    end    
    
    methods
        function obj = Subject( code, pathRoot )
            obj.pathRoot = pathRoot;
            obj.setCode( code );
        end
        
        function setCode( obj, code )
            obj.code = code;
            obj.label = code;
            obj.sFullPath = fullfile(obj.pathRoot, obj.code);
        end
        
        function out = fullPath(obj)
            out = obj.sFullPath;
        end
        
        function numCols = nReg(obj, nses)
            numCols = 0;
            fileReg = getRegFile(obj, nses);
            if ~isempty(fileReg)
                fid = fopen(fileReg);
                strData = strtrim(fgets(fid));
                cols = regexp(strData, '([^_ \t][^_ \t]*)', 'match');
                numCols = length(cols);
                fclose(fid);
            end
        end
        
        function regressor = getRegFile(obj, nses, unificado)
            
            if nargin > 2 && unificado
                if isempty(obj.regressores)
                    obj.ajustarRegressores(nses, unificado);
                end
                regressor = obj.regressores{nses};
            else
                fileR = dir( fullfile(obj.sFullPath, obj.pathSessions{nses}, 'rp_fMRI*.txt') ); % arquivo para processamento unificado
                regressor = fullfile( obj.sFullPath, obj.pathSessions{nses}, fileR.name);
            end
        end
        
        function regressorstruct = getOutrosRegressores( obj, outrosRegressoresPrefix, nses )
            if ~isempty( outrosRegressoresPrefix )
                filesR = dir( fullfile(obj.sFullPath, obj.pathSessions{nses}, [outrosRegressoresPrefix '*.txt']) );
                count = 0;
                
                regressorstruct = struct('name', {}, 'val', {} );
                   
                for fs=1:length(filesR)
                   
                   [nomes dado_colunas count_f] = getNomesRegressores( fullfile(obj.sFullPath, obj.pathSessions{nses}, filesR(fs).name), count );
                   
                   numCols = size( dado_colunas, 2 );
                   
                   for c=1:numCols
                       % construir struct conforme:
                       regressorstruct(end+1) = struct('name', nomes{c}, 'val',dado_colunas(:,c));
                   end
                   
                   count = count + count_f;
                end
            else
                regressorstruct = struct('name', {}, 'val', {});
            end
        end
        
        function numSes = getNumSes(obj)
          numSes = length(obj.pathSessions);
        end
        
        function sSes = getSes(obj, nses) %get String da Sessao
            if isempty(obj.pathSessions)
                sSes = sprintf(['%s%0' num2str(obj.tamPadSes) 'd'],obj.prefixSes,nses); %Identificador do sujeito (RUN01)
            else
                sSes = obj.pathSessions{nses};
            end
        end
        
        function sesDir = getSesDir(obj, nses)
            sesDir = fullfile(obj.sFullPath, obj.getSes(nses));
        end
    end
    
    methods(Access = private)
        function ajustarRegressores(obj, nses, unificado)
           
            if unificado
                fileR = dir( fullfile(obj.sFullPath, 'ru_rp_fMRI*.txt') ); % arquivo para processamento unificado
                if ~isempty(fileR) 
                    regFile = fullfile(obj.sFullPath, fileR(1).name);
                    dados = dlmread(regFile);
                    totalDados = size(dados,1)/obj.sessions;
                    for nses=1:obj.sessions
                        fileName = fullfile(obj.sFullPath, sprintf('regressores_ses_%02d.txt', nses));
                        startPos = (totalDados*(nses-1)+1);
                        endPos = (totalDados*nses);
                        dlmwrite( fileName, dados(startPos:endPos, :), 'newline','pc', 'delimiter',' ');
                        obj.regressores{nses} = fileName;
                    end
                end
            end
        end
    end
    
end

