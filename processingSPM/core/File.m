classdef File
    %FILE Classe para manipulação de arquivos
    %   Detailed explanation goes here
    
    methods(Static = true)
        %Busca arquivos e retorna seus nomes, podendo incluir o diretorio
        function out = getFileNames( pattern, varargin )
            includeFolder = false;
            if nargin == 2
                includeFolder = varargin{1};
            end
            
            [status files] = fileattrib(pattern);
            out = status;
            
            if status
                out = cell(length(files),1);
                for k=1:length(files)
                    if includeFolder
                        out{k} = files(k).Name;
                    else
                        [sD sF sE] = fileparts(files(k).Name);
                        out{k} = [sF sE];
                    end
                end
            end
            
        end
    end
    
end

