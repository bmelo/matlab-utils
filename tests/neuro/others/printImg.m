function printImg( filename )

matlabbatch{1}.spm.util.print.fname = filename;
matlabbatch{1}.spm.util.print.opts.opt = { '-dpsc2' '-append' };
matlabbatch{1}.spm.util.print.opts.append = true;
matlabbatch{1}.spm.util.print.opts.ext = '.ps';
spm_jobman('run', matlabbatch);

end

