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
root = ['C:\Users\bruno.melo\Desktop\PRJ1411\FIRST_LEVEL_ROI_SVM_compared\' tipo];
    
imgsSPM.inDir = root;
imgsSPM.open();
outDir = fullfile('C:\Users\bruno.melo\Desktop\PRJ1411\EXPORTED_IMGS_SL_005', tipo);
imgsSPM.xyz = ToolsSPM.goto('glmax'); %Go to global maxima
%imgsSPM.prefix = subjects(nsubj).name;
imgsSPM.export( outDir );
%cd( imgsSPM.outDir );
convertPsFiles();

cd(dirAtual);