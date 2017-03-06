load resultsROI_Condition001.mat

Z(:,6,:) = []; % Elimina a sexta coluna

k = 15; %Caso a ser analisado
for k=1:size(Z,3) %Coloquei o for para exportar as imagens, só comentar para ver o caso com o k acima (comentar tambem o end)
  
  mat = Z(:,:,k); %Matriz escolhida para gerar imagem
  colormap(hot); %Define combinacao de cores - existem algumas padroes
  colormap( flipud( colormap ) ); %Para inverter a ordem das cores
  imagesc( mat, [-1 1] ); %Segundo parametro especifica os limites da escala de cores
  colorbar;
  labelsImg( mat, true ); %Funcao que catei e adaptei para colocar os labels, segundo parametro inverte as cores brancas e pretas dos labels
  
  set(gca,'XTick',1:5,...                         %# Mudando rotulos das linhas e colunas
    'XTickLabel', names,...
    'YTick',1:5,...
    'YTickLabel',{'A','B','C','D','E'},...
    'TickLength',[0 0]);
  
  %Caso queira exportar as imagens
  outDir = 'hot_reverse';
  imwrite(hardcopy(gca, '-Dzbuffer', '-r0'), fullfile(outDir, sprintf('%02d.png',k)));
end
close all;