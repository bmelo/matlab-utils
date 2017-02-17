d = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_PROCESSAMENTO\fMRI_SESSOES_SEPARADAS\PREPROC_DATA';
freg = '*ufMRI*';

d = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_PROCESSAMENTO\fMRI_SESSOES_CONJUNTO\PREPROC_DATA';
freg = '*arfMRI*';


pastas = {'fMRI_IMAG_1P', 'fMRI_IMAG_3P', 'fMRI_EXE'};

sujeitos = {'SUBJ001','SUBJ002', 'SUBJ003'};
%sujeitos = {'SUBJ003'};

for sujeito=1:length(sujeitos)
    for pasta = 1:length(pastas)
        
        current_dir = fullfile( d, sujeitos{sujeito}, pastas{pasta} ); 
        cd( current_dir )
        delete( freg );
        
   end
end