classdef FirstLevelFixed < FirstLevel 
   properties
    subjects = [];
   end
   
   methods(Access = public)
       processar( obj );
       
       function obj=FirstLevelFixed( varargin )
           obj.openSPM = 0;
           if nargin == 1
               obj.populateData(varargin{1});
           end
       end
   end
   
   methods(Access = private)
       populaMatlabbatch( obj );
       
        function preparaRun(obj)
            obj.populaMatlabbatch();
            if ~obj.regressores
                obj.ajustaContrastes(0); %Remove os regressores
            else
                obj.ajustaContrastes(); %Primeiro normaliza os constrastes e ajuste se tiver midLevel
            end
        end
        
   end
   
    methods(Access = protected)
       %Verifica os parametros e ajusta para o MidLevel
        function ajustaContrastesMid(obj, nReg) %Ajustar constrastes quando existir midLevel
            
            for k=1:size(obj.contrastes,1)
                obj.contrastes{k,2} = repmat(obj.contrastes{k,2},1,length(obj.subjects));
            end
                %{
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
                %}
        end
        
        function ajustaContrastes(obj, varargin)
            
        end
        
        function executarAcoesContrastes(obj, fullOutDir)
            executarAcoesContrastes@FirstLevel( obj, fullOutDir )
        end
    end
end
