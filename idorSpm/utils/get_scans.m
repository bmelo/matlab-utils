function scans = get_scans( config, preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix, prefix_run )
if ~exist('prefix_run','var'), prefix_run = ''; end;

file_format = idor.utils.Var.get(config, 'run_file_extension', 'nii');
dimensions = idor.utils.Var.get(config, 'run_file_dimensions', 4);
imgname = sprintf( '%s%s', run_file_prefix, run_file_suffix);

scans = [];
for r=1:nrun
    dirRun = fullfile( preproc_dir, get_run_dir(config, r) );
    %Preparing images based on file dimension
    if dimensions == 3
        scans{r,1} = get3DImages(dirRun, imgname, file_format);
    else
        nii4D = get4DImages(dirRun, imgname, file_format, prefix_run);
        for k=1:nvol
            vols{k,1} = sprintf('%s,%i', nii4D, k);
        end
        scans{r,1} = vols;
    end
end

end

%% for 3D images
function files = get3DImages( dirRun, imgname, extension, prefix_run )
if ~exist('prefix_run','var'), prefix_run = ''; end;

imgname = sprintf( '%s*.%s', imgname, extension );
if( ~exist( fullfile(dirRun, imgname), 'file' ) )
    [~, dirFs] = fileattrib( fullfile(dirRun, imgname) );
    for k = 1:length(dirFs)
        files{k,1} = sprintf('%s,1', dirFs(k).Name);
    end
end

end

%% for 4D images
function file = get4DImages( dirRun, imgname, extension, prefix_run )
if ~exist('prefix_run','var'), prefix_run = ''; end;
imgname = sprintf( '%s.%s', imgname, extension );
%imgname = strrep( imgname, '{rn}', num2str(r) );
dirRun = resolveDir( dirRun );
if( ~exist( fullfile(dirRun, imgname), 'file' ) )
    dirFs = dir( fullfile(dirRun, imgname) );
    imgname = dirFs(1).name;
end
file = fullfile( dirRun, [prefix_run imgname]);

end

%% Resolves dirName, if necessary
function dirOut = resolveDir( dirpath )
dirOut = dirpath;
if( ~exist( dirpath, 'dir' ) )
    root = fileparts(dirpath);
    dirs = dir(dirpath);
    if( ~isempty(dirs) && dirs(1).isdir )
        dirOut = fullfile( root, dirs(1).name );
    else
        error('Directory %s not found.', dirpath);
    end
end
end