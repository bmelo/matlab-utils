function processar( obj, varargin )
%PROCESSAR Summary of this function goes here
%   Detailed explanation goes here
processar@ProcessamentoSPM(obj);

onlyCons = 0;
if ~isempty( varargin )
    onlyCons = varargin{1};
end

%%Processamento principal do first Level
obj.preparaRun();

if obj.checkDataToProcess() %Verifica se o sujeito deve ser processado
    fullOutDir = fullfile(obj.outDir, obj.prefixProj ); %Diretorio de saída
    if ~onlyCons
         if obj.possuiMidLevel()
                obj.ajustaContrastesMid();
         end
         
         obj.setContrastes( obj.contrastes );
         obj.executarFirstBatch( fullOutDir );
         
    else
        obj.executarAcoesContrastes( fullOutDir );
    end
end

if obj.openSPM
    spm('quit');
end

obj.execFinished();
end

