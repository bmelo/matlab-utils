origem = 'Z:\PROJETOS\PRJ1206_BLINDNESS\03_PROCS\fMRI\RAW_DATA\';

destino = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_PROCESSAMENTO\fMRI\RAW_DATA';

pastas = {'fMRI_IMAG_1P', 'fMRI_IMAG_3P', 'fMRI_EXE'};

%sujeitos = {'SUBJ001','SUBJ002', 'SUBJ003'};
sujeitos = {'SUBJ005'};

for sujeito=1:length(sujeitos)
    for pasta = 1:length(pastas)
        from = fullfile( origem, sujeitos{sujeito}, pastas{pasta} );
        to = fullfile( destino, sujeitos{sujeito}, pastas{pasta} ); 
        if ~exist( to, 'dir'), mkdir( to ), end
        copyfile( from, to, 'f' );
   end
end