matlabbatch{1}.spm.temporal.st.scans = get_scans( preproc_dir, nrun, nvol, ['r' run_file_prefix] , run_file_suffix );
matlabbatch{1}.spm.temporal.st.nslices = ncorte;
matlabbatch{1}.spm.temporal.st.tr = TR;
matlabbatch{1}.spm.temporal.st.ta = TA;
matlabbatch{1}.spm.temporal.st.so = [1:ncorte];
matlabbatch{1}.spm.temporal.st.refslice = ceil(ncorte/2);
matlabbatch{1}.spm.temporal.st.prefix = 'a';



