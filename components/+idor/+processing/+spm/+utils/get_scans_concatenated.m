function scans = get_scans_concatenated( preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix )

scans = [];
scans_orig = get_scans( preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix );
for k = 1:size(scans_orig,1)
    scans = [scans; scans_orig{k}];
end

end

