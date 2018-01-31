run('vendors/matlab-utils/libsetup.m');
import neuro.*

clc;
subjsdir = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PROC_DATA/fMRI/exclui_subj005/STATS/FIRST_LEVEL/MOTOR';
cons = 3:9;
mask = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PROC_DATA/fMRI/exclui_subj005/STATS/FIRST_LEVEL/MOTOR/Motor_ntw_thr3_all_subjs_pre_pos_bin_first_level_space_R.nii';

masknii = load_nii(mask);
header = spm_vol(mask);
threshold = 4;

for con = cons
    conname = sprintf('*/spmT_%04d*nii', con);
    %conname = '*009/spmT_0005*nii';
    arquivos = utils.resolve_names( fullfile(subjsdir, conname) );
      
    for arquivo=arquivos
        
        % Thresholding image
        vol = load_nii(arquivo{1});
        vol.img(~masknii.img) = NaN;
        vol.img(vol.img < threshold) = NaN;
        
        if ~all(isnan(vol.img(:)))
            cog_val = neuro.imgs.cog(vol);
            % MNI Space
            XYZ = header.mat * [cog_val 1]';
            fprintf('%s\t%.2f\t%.2f\t%.2f\n', arquivo{1}, -XYZ(1), XYZ(2), XYZ(3));
        else
            fprintf('%s\t-\t-\t-\n', arquivo{1});
        end        
    end

end