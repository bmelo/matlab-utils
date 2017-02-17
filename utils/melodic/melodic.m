function melodic()
%% settings
subjs = 1:40;
subjs_ignore = [18 40];
subjs = setdiff(subjs, subjs_ignore);
preproc_dir = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PREPROC_DATA/fMRI/NORM_ANAT/';
out_dir = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PREPROC_DATA/fMRI/MELODIC_ar';
patt = 'arWIP*.nii';
runs = {'IMAG_1', 'NFB_TREINO', 'RUN1', 'RUN2', 'RUN3', 'IMAG_2'};

%% logic
curdir = pwd;
for ns = subjs
    subjid = sprintf('SUBJ%03d', ns);
    subjdir = resolve_patt( fullfile(preproc_dir, [subjid '*']), 1 );    
    outsubjdir = fullfile(out_dir, subjid);
    
    for nr = 1:length(runs)
        rundir = runs{nr};
        infile = resolve_patt(fullfile(subjdir, rundir, patt), 1);
        outdir = fullfile(outsubjdir, rundir);
        
        if ~isdir(outdir)
            mkdir(outdir);         
        end
        cd(outdir);
        copyfile(fullfile(curdir, 'report.html'), 'report.html');
        
        fslexec( 'fsl_sub', 'melodic', '-i', infile, '-o', outdir, '-v',...
        '--bgthreshold=3', '--tr=2.0', '-d', '20', '--report', '--mmthresh=0.5');
    end
end

cd(curdir);
end


%% Para recuperar rapidamente o nome de pastas e arquivos
function out = resolve_patt( patt, complete )
result = dir(patt);
out = result(1).name;
if complete
    direc = fileparts(patt);
    out = fullfile(direc, out);
end
end