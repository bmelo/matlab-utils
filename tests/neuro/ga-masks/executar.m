clc;
init;
%areas = [1:5 7:16 20:48];
%areas = [8:14 20:22 24 25 28 32 36 38 44:48];
areas = 1:116;
atlas = aal;
%Após sugestões da Patrícia
sujeitos = {'SUBJ005', 'SUBJ007', 'SUBJ008', 'SUBJ009', 'SUBJ010', 'SUBJ011'};
%areas = [8:16 24 25 32 33 46];
%atlas = brodmann

ga = GA(sujeitos, areas, atlas);
%ga.paralelo = true;
%ga.maxSelecao = 2;
ga.executar();
%individuo = Individuo(ga.classifier.gerarMaskAleatoria(10), {'SUBJ005'});
%ga.classifier.classificar( individuo );