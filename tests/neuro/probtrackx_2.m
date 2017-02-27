function mats = probtrackx_2()
clc;
roisFile = '\\10.36.4.201\dados1\PROJETOS\PRJ0801_MEM_FANTAS\03_PROCS\SCRIPTS\DOUTORADO\PROBTRACK_NETWORK\rois.txt';
pastaSubjs = '\\10.36.4.201\dados1\PROJETOS\PRJ0801_MEM_FANTAS\03_PROCS\PROC_DATA\PROBTRACKX';
%pastaSubjs = 'C:\Documents and Settings\bmelo\Desktop\PROBTRACK';
%flip = false;

%Extraindo rois do arquivo
f = fopen(roisFile);
rois = textscan(f, '%s');
fclose(f);

mats.ctls = processaLote( pastaSubjs, 'CTL', 1:9, rois, false);
mats.pacs = processaLote( pastaSubjs, 'PAC', [3:5 7:9], rois, false );
flipados = processaLote( pastaSubjs, 'PAC', [1:2 6], rois, true ); %SUJEITOS FLIPADOS
mats.pacs.subj = [mats.pacs.subj flipados.subj];

save( 'mats.mat', 'mats' );
fprintf('Dados exportados para o arquivo %s\n\n', fullfile(pwd, 'mats.mat') );
%processaLote( pastaSubjs, 'PAC', 1:9, rois, flip );
end

%Executa o processamento em lote
function out = processaLote( pasta, prefix, nums, rois, flip )
total = length(nums);
out = struct();
for k=1:total
  subj = sprintf('%s%.3d', prefix, nums(k));
  pastaSubj = fullfile( pasta, subj );
  if isdir(pastaSubj)
    out.subj(k).subject = subj;
    out.subj(k).dir = pastaSubj;
    out.subj(k).matrix = processaIndividuo( pastaSubj, rois, flip );
    out.subj(k).labeledMatrix = putLabels( out.subj(k).matrix, rois );
  end
end
end

%Executa processamento individual
function out=processaIndividuo( pasta, rois, flip )

total = length(rois{1});
out = zeros( total, total );
for k=1:total
  for j=k:total
    pastaRois = sprintf( '%s-%s', rois{1}{k}, rois{1}{j} );
    fileVals = fullfile( pasta, pastaRois, 'waytotal' );
    if ~exist(fileVals, 'file') 
      continue
    end
    values = dlmread(fileVals);
    out(k,j) = values(1);
    out(j,k) = values(2);
  end
end

%Faz o flip na matriz
if flip
  out = out';
end

end

function out=putLabels( matriz, rois )

out = cell( size(matriz)+1 );
out(1,1:end) = ['/', rois{1:end}'];
out(1:end,1) = ['/', rois{1:end}'];
for k=1:size(matriz,1)
  for j=1:size(matriz,2)
    out{k+1, j+1} = matriz(k,j);
  end
end

end