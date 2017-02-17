function scans = get_scans_concatenated( config, preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix, prefix_run )
if ~exist('prefix_run','var'), prefix_run = ''; end;

scans = [];
scans_orig = get_scans( config, preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix, prefix_run );
for k = 1:size(scans_orig,1)
    scans = [scans; scans_orig{k}];
end

end

