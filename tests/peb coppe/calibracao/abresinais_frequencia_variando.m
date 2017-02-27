%mostra sinais com referencia em cz
clear all

fdir = '100uV_Frequencia_variando'
rdir = fullfile( pwd, fdir );

freqs = [0.05 0.1 0.5 1 10 20 30 40 45 50 55 60 65 70 80 90 100 110 120];

freqs_EEG = [];
all_PPs_Cz = [];
all_y = [];

for k=1:length(freqs)
    
    freq_str = strrep( num2str(freqs(k)), '.', '' );
    
    fname = ['T100uV_' freq_str 'Hz.peb'];
        
    sinal = AbreSinalPEB_placa( fullfile( rdir, fname) );
    
    cz = -sinal.ARQdig(18,:);
    sinal.ARQdig = sinal.ARQdig + repmat(cz,size(sinal.ARQdig,1),1);
    
    [f_EEG pow_EEG] = fft_signal( cz(2:end), 600 );
    [m max_ind_f] = max( pow_EEG );
    
    freqs_EEG(k) = f_EEG( max_ind_f);
    
    cutoff = min( 200, freqs_EEG(k) * 100 );
    
    PPs_Cz = findPP( filterpass( cz(2:end), cutoff, 600, 'low'  ) );
   
    % remove bad signal for some recordings
    if k==1
        PPs_Cz(3) = [];
    end
    if k==2
        PPs_Cz(4) = [];
    end
    
    % PPs_Cz = findPP( cz(2:end) );

    all_PPs_Cz = [all_PPs_Cz ; PPs_Cz];
    all_y = [all_y; repmat(freqs_EEG(k),length(PPs_Cz),1)];
    
    mean_PPs_Cz(k) = mean( PPs_Cz );
    std_PPs_Cz(k) = std( PPs_Cz );
end

plotCalibracao( freqs, mean_PPs_Cz, std_PPs_Cz, 'Frequência', 'Amplitude EEG', 'Resposta em frequência para Amplitude 100uV' )

saveas( gcf, [fdir '.tif'] )

figure, 
h = plot( freqs, freqs_EEG );
grid on
set(h,'Linewidth',2 )
set(gca,'FontSize',10,'FontWeight','bold')
saveas( gcf, [fdir '_freq.tif'] )
    
save( ['results' fdir '.mat'], 'freqs', 'freqs_EEG', 'mean_PPs_Cz', 'std_PPs_Cz' );

