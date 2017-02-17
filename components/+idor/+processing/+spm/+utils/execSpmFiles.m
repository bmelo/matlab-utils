function execSpmFiles( files )
%EXECSPMFILES Summary of this function goes here
%   Detailed explanation goes here

for k=1:length(files)
    clear matlabbatch;
    load( files{k} );
    spm_jobman('run',matlabbatch);
end

end

