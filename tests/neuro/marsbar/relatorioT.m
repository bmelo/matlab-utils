addpath( fullfile(pwd, 'nifti_tools'));
rootdir = '';
SUBJS = [2:7 9 10];
CONTRASTES = {'T - A -*' 'A - T -*'};
dirROIS = '';
MASKS = {'Tenderness_ROI_SUBJ.nii' 'Anguish_ROI_SUBJ.nii' };
filepat = 'p0.01*';

for nc = 1:length(CONTRASTES)
    cont = CONTRASTES{nc};
    mask = load_nii( fullfile( dirROIS, MASKS{nc} ) );
    % posicoes da mascara
    posmask = mask.img > 0;
    relatorio.contraste(nc).name = cont;
    for subj=SUBJS
        subjid = sprintf('SUBJ%03d', subj);
        dirsubj = fullfile(rootdir, subjid);
        dirs = dir( fullfile(dirsubj, cont) );
        for ndc = 1:length(dirs)
            dircont = fullfile(dirsubj, dirs(ndc).name);
            files = dir( fullfile(dircont, filepat) );
            if( length(files)>1 )
                error( 'Mais de um arquivo para ser analisado com o padrão "%s"', filepat );
            elseif( isempty(files) )
                error( 'Nenhuma imagem foi localizada com o padrão "%s"', fullfile(dircont, filepat) );
            end
            img = load_nii( fullfile( dircont, files.name ) );
            posnumbers = ~isnan(img.img); %Posicoes com valores
            vals = img.img( posmask & posnumbers );
            number = length( vals );
            relatorio.contraste(nc).subjs.(subjid).run(ndc) = struct('min', min(vals),'max', max(vals),'mean', mean(vals),'number', number);
        end
    end
end