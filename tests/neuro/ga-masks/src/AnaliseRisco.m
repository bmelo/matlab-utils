classdef AnaliseRisco < handle
    %ANALISERISCO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant = true)
        pathExe = fullfile( CONSTS.VENDORS_DIR, 'AnaliseRisco', 'AnaliseRisco.exe' );
    end
    
    properties
        paramsFile = '';
        limpar = false;
    end
    
    methods
        function obj = AnaliseRisco( params )
            obj.montaParamsFile( params );
            %Executa o processamento
            cmd = ['"' obj.pathExe '" "' obj.paramsFile '"'];
            evalc(['system(''' cmd ''')']);
            obj.limpaParams();
        end
        
        function montaParamsFile( obj, params )            
            if isstruct(params)
                obj.paramsFile = [tempname(CONSTS.TEMP_DIR) '.txt']; %Nome temporário do arquivo params
                Classifier.struct2ini( obj.paramsFile, params );
                obj.limpar = true;
            else
                obj.paramsFile = params; %Assume que é string e coloca no atributo
            end
        end
        
        function limpaParams(obj)
            %Limpa o params.txt temporário, caso o método tenha construído
            if obj.limpar
                delete( obj.paramsFile );
                obj.paramsFile = '';
            end
        end
    end
    
end

