% Função para gerar comandos e traçar o caminho entre ROIs
function rois( params )

[~,~,rois] = xlsread( params.XLS , 'ROIS');
fileout = fopen( 'output.txt', 'w' );

for grupo = 1 : size(params.SUBJECTS, 2)
  for nSub = 1 : size(params.SUBJECTS, 1)
    params.SUBJID = params.SUBJECTS{nSub, grupo};
    if(isnan(params.SUBJID))
      continue
    end;
    for nRoiS = 1:length(rois)
      params.ROI_SEED = rois{nRoiS};
      for nRoiT = 1:length(rois)
        params.ROI_TARGET = rois{nRoiT};
        fprintf('%s\n', geraComando( params ));
        fprintf( fileout, '%s\n', geraComando( params ));
      end
    end
  end
end

fclose(fileout);

end