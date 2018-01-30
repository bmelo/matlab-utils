run('vendors/matlab-utils/libsetup.m');
import neuro.*

clc;
subjsdir = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PROC_DATA/fMRI/exclui_subj005/STATS/FIRST_LEVEL/MOTOR';
cons = 3:9;
mask = 'M1_LEFT_igual_035_space_con.nii';

masknii = load_nii(mask);
header = spm_vol(mask);
for con = cons
    conname = sprintf('*/spmT_%04d*nii', con);
    arquivos = utils.resolve_names( fullfile(subjsdir, conname) );
      
    for arquivo=arquivos
        cog_val = neuro.imgs.cog(arquivo{1}, masknii);
        
        % MNI Space
        XYZ = header.mat * [cog_val 1]';
        
        fprintf('%s\t%.2f\t%.2f\t%.2f\n', arquivo{1},-XYZ(1), XYZ(2), XYZ(3));
        break;
    end

end