function extract_volume( infile, outdir, n_vol )
%STANDARD_SPACE Summary of this function goes here
%   infile - 4D volume
%   outdir - Output directory or empty value to use the same of the image
%   n_vol - number of volume, if only need to extract one. [starts from 1]

% Out directory
curdir = pwd;
if nargin == 1 || isempty(outdir), outdir = fileparts(infile); end;

% Preparing filename
clean_name = regexprep(infile, '\.nii(\.gz)*$', '');
fbasename = [utils.path.basename( clean_name ) '_vol'];

[~, attrs] = fileattrib( utils.resolve_name([infile '*']));
infile = attrs.Name;

%% Doing split
cd(outdir);
fprintf('fslsplit %s\n', infile);
fslexec('fslsplit', infile);


%% renaming to preserve original name
if nargin < 2
    files = utils.resolve_names('vol*.nii.gz');
    for nF = 1:length(files)
        fix_vol_name( files{nF}, fbasename )
    end
else
    file = utils.resolve_name( sprintf('vol*%d.nii.gz', n_vol-1) );
    fix_vol_name( file, fbasename );
end

% removing what is not necessary
delete vol*

cd(curdir);

end

%% Function to correct volume names
function fix_vol_name( vol_name, fbasename )

fnum = str2num( regexprep(vol_name, '\D', '' ) );
new_name = sprintf('%s%04d.nii.gz', fbasename, fnum+1);

system( sprintf('mv %s %s', vol_name, new_name));

end