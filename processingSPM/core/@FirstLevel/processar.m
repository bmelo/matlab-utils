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
    fullOutDir = fullfile(obj.outDir, obj.prefixProj, obj.subject.code ); %Diretorio de saída
    if ~onlyCons
        if obj.possuiMidLevel()
            obj.executarFirstLevel( fullOutDir );
            obj.executarAcoesContrastes(fullOutDir);
        else
            obj.setContrastes( obj.contrastes );
            obj.executarFirstBatch( fullOutDir );
        end
    else
        obj.executarAcoesContrastes( fullOutDir );
    end
end

if obj.openSPM
    spm('quit');
end

obj.execFinished();
end

