addpath('nifti_tools');
mask = ''; %Usar esta linha ou a linha abaixo
%mask = load_nii( '' ); %Este formato deverá diminuir o tempo de execução
vol = '';
meansActivation = [];

meansRest   = zeros(10,1);
for k=1:10
    meansRest(k) = meanRoiVol( vol, mask );
end
lastRM = mean(meansRest);
for k=1:10
    mRV = meanRoiVol( vol, mask );
    meansActivation(end+1) = (mRV -lastRM )/lastRM;
end
plot(meansActivation);