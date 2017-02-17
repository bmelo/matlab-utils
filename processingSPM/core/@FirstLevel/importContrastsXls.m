function contrasts = importContrastsXls( xlsFile )

[nums, texts, dados] = xlsread( xlsFile, 'CONTRASTS' );

if ~strcmp(dados{1,1}, 'CODE')
    return;
end

numRows = 0;
for k=2:size(dados,1)
    if isempty(dados(k,1)) | isnan( dados{k,1} )
        break;
    else
        numRows = numRows+1;
    end
end

numCols = 0;
for k=3:size(dados,2)
    if isempty(dados(2,k)) | isnan( dados{2,k} )
        break;
    else
        numCols = numCols+1;
    end
end

contrasts = cell(numRows,2);
arrContrasts = zeros(1,numCols);
for k=1:numRows
    contrasts{k,1} = dados{k+1,1};
    for j=1:numCols
        arrContrasts(j) = dados{k+1,j+2};
    end
    contrasts{k,2} = arrContrasts;
end

end
