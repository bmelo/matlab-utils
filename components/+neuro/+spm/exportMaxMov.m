function exportMaxMov( dirIn, fileSaida, prefixSubj, prefixRun )

if nargin<2; fileSaida = fullfile(dirIn, 'dadosMovimentos'); end;
if nargin<3; prefixSubj = 'SUBJ*'; end;
if nargin<4; prefixRun = 'RUN*'; end;

dados = [];
maxR = 0;
maxT = 0;
fPatt = 'rp_*.txt';
dirs = dir( fullfile( dirIn, prefixSubj ) );
for k=1:length(dirs)
    subjDir = dirs(k).name;
    runs = dir( fullfile( dirIn, subjDir, sprintf('%s*',prefixRun) ) );
    for nR=1:length(runs)
        runDir = runs(nR).name;
        folder = fullfile( dirIn, subjDir, runDir);
        if(exist(folder,'dir'))
            files = dir( fullfile( folder, fPatt ));
            if( ~isempty(files) )
                dadosMov = textread( fullfile(folder,files(1).name) );
                dados(end+1).subjFolder = fullfile(subjDir, runDir);
                dados(end).maximos = max(dadosMov) - min(dadosMov);
                dados(end).maximos(4:6) = dados(end).maximos(4:6) ./(pi/180) ; %Convert RADIANS to DEGREES
                maxR = max( [maxR max(dados(end).maximos(1:3))] );
                maxT = max( [maxT max(dados(end).maximos(4:6))] );
            end
        end
    end
end

%escrevendo resultados
dadosOut{1} = {'SUJEITO', 'TRANSL', 'ROTACAO'};
for k=1:length(dados)
    dadosOut{end+1} = { dados(k).subjFolder, max(dados(k).maximos(1:3)), max(dados(k).maximos(4:6)) };
end
dadosOut{end+2} = {'MAXIMOS:',maxR, maxT};

geraOut([fileSaida '.txt'], dadosOut);
geraOut([fileSaida '.xls'], dadosOut);