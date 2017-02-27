%mostra sinais com referencia em cz

clear all
%fdir = '10Hz_Amplitude_variando'
fdir = '30Hz_Amplitude_variando'
rdir = fullfile( pwd, fdir );

amps = [20, 50, 100, 500, 1000, 5000];

all_PPs_Cz = [];
all_y = [];

for k=1:length(amps)
    
    fname = ['T' num2str(amps(k)) 'uV_' fdir(1:4) '.peb'];
        
    sinal = AbreSinalPEB_placa( fullfile( rdir, fname) );
    
    cz = -sinal.ARQdig(18,:);
    sinal.ARQdig = sinal.ARQdig + repmat(cz,size(sinal.ARQdig,1),1);
    
    PPs_Cz = findPP( filterpass( cz(2:end), 100, 600, 'low'  ) );
    
    all_PPs_Cz = [all_PPs_Cz ; PPs_Cz];
    all_y = [all_y; repmat(amps(k),length(PPs_Cz),1)];
    
    mean_PPs_Cz(k) = mean( PPs_Cz );
    std_PPs_Cz(k) = std( PPs_Cz );
end

fator_calib_all = 1 / (pinv(all_PPs_Cz) * all_y);
fator_calib = 1 / (pinv(mean_PPs_Cz') * amps');

plotCalibracao( amps, mean_PPs_Cz, std_PPs_Cz, 'Amplitude entrada', 'Amplitude EEG', fdir(1:4) )

h = plot( amps, fator_calib * amps, 'k--' )
set(h,'Linewidth',2 )
set(gca,'FontSize',10,'FontWeight','bold')

mid_pos = ( max( amps ) - min( amps ) ) /2;

text( mid_pos, fator_calib * mid_pos, ['\leftarrow fator de calibração: ' sprintf( '%.2f', fator_calib ) ] );

saveas( gcf, [fdir '.tif'] )

save( ['results' fdir '.mat'], 'amps', 'mean_PPs_Cz', 'std_PPs_Cz' );

