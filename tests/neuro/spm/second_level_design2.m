clear all;
close all;
clear matlabbatch

%spm fmri;
%spm_jobman('initcfg');

dir_base = 'C:\Users\bruno.melo\Desktop\PRJ1305_TOC';
addpath(pwd);

design = 'MSAT_ONSET_POS_FRASE';
design_2ndlevel_dest = 'MSAT_ONSET_POS_FRASE_ALL';

contrast{1} = 'CULPA_VS_NEUTRO';
contrast{2} = 'NOJO_VS_NEUTRO';
contrast{3} = 'PENA_VS_NEUTRO';
contrast{4} = 'RAIVA_VS_NEUTRO';
contrast{5} = 'NEUTRO';
contrast{6} = 'FRASE';


for k=1:length(contrast)
    
    warning off;
    mkdir( fullfile(dir_base,'STATS\SECOND_LEVEL',design_2ndlevel_dest) );
    cd ( fullfile(dir_base,'STATS\SECOND_LEVEL',design_2ndlevel_dest));
    mkdir(contrast{k});
    warning on;
    
    disp (['Second level for Design: ',design, ' and contrast: ', contrast{k}, '. Results written to: ', design_2ndlevel_dest]);
    
    
    clear matlabbatch;
    
    % especificar aqui os sujeitos - mudar nome de design para criar pastas
    % separadas por combinacoes diferentes
    descartados = [11 13 22 35 42];
    ctls = setdiff( [1 2 9 12 15 16 18 19 21 23 25:27 30 32 33 36 37 40 41 47], descartados );
    pacs = setdiff( 1:48, [ctls descartados] );
    subjs = [pacs, ctls];
    groupname = {'TOC','CTL'};
    
    if( iscell(subjs) & size(subjs)==[1 2] )
        ttest_2groups;
    else
        ttest_spm_flex;
    end
    
    
    spm_jobman('run',matlabbatch);
    
    
end



