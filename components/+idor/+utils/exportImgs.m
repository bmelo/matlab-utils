addpath(pwd);
clear; clc;

dirAtual = pwd;
imgsSPM = ImgsSPM;
imgsSPM.pattern = '*';
imgsSPM.type = {'ativacao','save'};
imgsSPM.threshold = 0.005;
imgsSPM.extent = 5;
imgsSPM.FWE = true;
imgsSPM.goTo = 'glmax';
imgsSPM.exportAllCons = true;
%imgsSPM.xyz = [2.76 -89.42 -2.0];

root = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/MOV_COMPLETE';

subjects = dir(fullfile(root, 'SUBJ*'));
for nsubj=1:length(subjects)
    imgsSPM.inDir = fullfile( root, subjects(nsubj).name );
    imgsSPM.open();
    outDir = fullfile('/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/EXPORTED_IMGS', subjects(nsubj).name);
    imgsSPM.xyz = ToolsSPM.goto('glmax'); %Go to global maxima
    imgsSPM.export( outDir );
    %cd( imgsSPM.outDir );
    convertPsFiles();
end

cd(dirAtual);