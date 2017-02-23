function run( input_args )
%RUN fslcommand args
%   Detailed explanation goes here

cmds_alloweds = {
  'tbss_1_preproc'
  'tbss_2_reg'
  'dtifit'
  'tbss_3_postreg'
  'tbss_4_prestats'
  'fslmaths'
  'fslmeants'
  'fslsplit'
  'fslmerge'
  'melodic'
  'bet'
  'eddy_correct'
};

disp(input_args);

end

