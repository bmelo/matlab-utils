%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {[dir_base,'PROC_DATA/SECOND_LEVEL/',design,'/', contrast{i}]};
    

if i<10
%%
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ001/con_000',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ002/con_000',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ003/con_000',num2str(i),'.img,1']
                                                        
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ004/con_000',num2str(i),'.img,1']
                                                         
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ005/con_000',num2str(i),'.img,1']
                                                         
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ006/con_000',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ007/con_000',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ008/con_000',num2str(i),'.img,1']
                                                         
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ009/con_000',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ010/con_000',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ011/con_000',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ012/con_000',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ013/con_000',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ014/con_000',num2str(i),'.img,1']
                                                         
                                                          };
                                                      
elseif i>9                                                      
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ001/con_00',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ002/con_00',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ003/con_00',num2str(i),'.img,1']
                                                        
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ004/con_00',num2str(i),'.img,1']
                                                         
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ005/con_00',num2str(i),'.img,1']
                                                         
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ006/con_00',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ007/con_00',num2str(i),'.img,1']
                                                          
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ008/con_00',num2str(i),'.img,1']
                                                         
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ009/con_00',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ010/con_00',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ011/con_00',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ012/con_00',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ013/con_00',num2str(i),'.img,1']
                                                          [dir_base,'/PROC_DATA/FIRST_LEVEL/',design,'/SUBJ014/con_00',num2str(i),'.img,1']
                                                         
                                                          };
end
%%
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


matlabbatch{2}.spm.stats.fmri_est.spmmat = {[dir_base,'PROC_DATA/SECOND_LEVEL/',design,'/', contrast{i},'/SPM.mat']};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;



matlabbatch{3}.spm.stats.con.spmmat = {[dir_base,'PROC_DATA/SECOND_LEVEL/',design,'/', contrast{i},'/SPM.mat']};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = contrast{i};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['-',contrast{i}];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = -1;
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
