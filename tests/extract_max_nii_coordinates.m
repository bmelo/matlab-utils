run('vendors/matlab-utils/libsetup.m');
import neuro.*

subjsdir = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PROC_DATA/fMRI/exclui_subj005/STATS/FIRST_LEVEL/MOTOR';
cons = 3:9;
mask = 'M1_LEFT_igual_035_space_con.nii';

masknii = load_nii(mask);
header = spm_vol(mask);
for con = cons
    conname = sprintf('*/con_%04d*', con);
    arquivos = utils.resolve_names( fullfile(subjsdir, conname) );
    
    for arquivo=arquivos
        connii = load_nii(arquivo{1});
        
        if size(connii.img) ~= size(masknii.img)
            error('Dimensão da máscara está diferente da dimensão da imagem.');
        end
        
        connii.img(~masknii.img) = 0;
        M = connii.img();
        [C,I] = max(M(:));
        [I, J, K] = ind2sub(size(M),I);
        
        % MNI Space
        XYZ = header.mat * [I; J; K; 1];
        
        fprintf('%s\t%.4f\t%d\t%d\t%d\n', arquivo{1}, M(I,J,K), -XYZ(1), XYZ(2), XYZ(3));
    end

end