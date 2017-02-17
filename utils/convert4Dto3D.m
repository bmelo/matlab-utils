function convert4Dto3D( img, dest )

if nargin == 1; dest = ''; end;

[pathf,file,ext] = fileparts(img);
if( strcmp(ext, '.gz') )
    img = fullfile( pathf, file );
end

% Checking if need create the output directory
if( ~exist( dest, 'dir' ) )
    mkdir(dest)
end

% Extracting gz file
if( ~exist(img, 'file') && exist([img '.gz'], 'file') )
    gunzip( [img '.gz'] );
end


% Running job in SPM
matlabbatch{1}.spm.util.split.vol = { [img ',1']};
matlabbatch{1}.spm.util.split.outdir = {dest};

spm_jobman('run', matlabbatch)
