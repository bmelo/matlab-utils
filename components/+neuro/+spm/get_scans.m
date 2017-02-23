function scans = get_scans( preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix )

scans = [];
for r=1:nrun
    dirRun = fullfile(preproc_dir, sprintf( 'RUN%i', r));
    imgname = sprintf( '%s%s.nii', run_file_prefix, run_file_suffix );
    imgname = strrep( imgname, '{rn}', num2str(r) );
    if( ~exist( fullfile(dirRun, imgname), 'file' ) )
       dirFs = dir( fullfile(dirRun, imgname) );
       imgname = dirFs(1).name;
    end
    imgfullfilename = fullfile( dirRun, imgname);
    for k=1:nvol
        run_tmp{k,1} = sprintf('%s,%i', imgfullfilename, k);
        scans{r,1} = run_tmp;
    end
end

end