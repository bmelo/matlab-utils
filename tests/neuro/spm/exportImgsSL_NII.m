addpath(pwd);
clear; clc;

dirAtual = pwd;
imgsSPM = ImgsSPM;
imgsSPM.pattern = '*';
imgsSPM.type = 'save';
imgsSPM.threshold = .005;
imgsSPM.extent = 5;
imgsSPM.FWE = false;
imgsSPM.goTo = 'glmax';
imgsSPM.exportAllCons = true;
%imgsSPM.xyz = [2.76 -89.42 -2.0];

tipo = 'ROI';
root = ['\' tipo];
    
imgsSPM.inDir = root;
imgsSPM.open();
outDir = fullfile('', tipo);
imgsSPM.xyz = ToolsSPM.goto('glmax'); %Go to global maxima
%imgsSPM.prefix = subjects(nsubj).name;
imgsSPM.export( outDir );
%cd( imgsSPM.outDir );
convertPsFiles();

cd(dirAtual);