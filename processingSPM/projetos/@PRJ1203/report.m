function report( logFile, varargin)
if(~exist(logFile, 'file'))
    return;
end
[caminho nomearq] = fileparts(logFile);
exportar = true;
if nargin > 1
    exportar = varargin{2};
end
USER = 2;
OTHER = 3;

dados = PRJ1203.lerLog(logFile, 'CG');
tam = length(dados{USER});
saldos = zeros(tam+1, 2);

%GANHOS
for k=1:tam
    if dados{USER}{k}=='H' & dados{OTHER}{k}=='H'
        saldos(k+1,:) = [-1 -1]; 
    elseif dados{USER}{k}=='H' & dados{OTHER}{k}=='D'
        saldos(k+1,:) = [2 0]; 
    elseif dados{USER}{k}=='D' & dados{OTHER}{k}=='H'
        saldos(k+1,:) = [0 2]; 
    elseif dados{USER}{k}=='D' & dados{OTHER}{k}=='D'
        saldos(k+1,:) = [1 1]; 
    end
end

inter = 0:tam;
acumulado = cumsum(saldos);
h = figure;
plot(inter, acumulado(:,1), '-ro', inter,acumulado(:,2),'-go');
hleg = legend(['VOLUNTARIO (' num2str(acumulado(end,1)) ')'], ['OUTRO (' num2str(acumulado(end,2)) ')']);
set(hleg, 'Location', 'North');
xlabel('Num Trial')
ylabel('Retorno Acumulado do Run');
title(nomearq, 'FontWeight','bold')
extremos = [min(unique(acumulado)) max(unique(acumulado))];
offset = (extremos(2)-extremos(1))*0.1;
set(gca, 'YLim', [extremos(1)-offset extremos(2)+offset] );
saveas(h,fullfile(caminho, nomearq),'png');
end

