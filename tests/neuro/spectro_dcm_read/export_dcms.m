function export_dcms()
% BIDS Proposal - https://docs.google.com/document/d/1pWCb02YNv5W-UZZja24fZrdXLm4X7knXMiZI7E2z7mY/edit#heading=h.4k1noo90gelw
% 

files = {
    'dlpfc_1_off_pre', '../dcm/S1704007_1_20170529/eja_svs_mpress_dlpfc_PRJ1704_0033/1.3.12.2.1107.5.2.43.66103.2017052911281761664120752_0033_000001.dcm';
    'dlpfc_2_on_pre',  '../dcm/S1704007_1_20170529/eja_svs_mpress_dlpfc_PRJ1704_0033/1.3.12.2.1107.5.2.43.66103.2017052911281761732720753_0033_000002.dcm';
    'ofc_1_off_pre',   '../dcm/S1704007_1_20170529/eja_svs_mpress_ofc_PRJ1704_0030/1.3.12.2.1107.5.2.43.66103.2017052911114075539820055_0030_000001.dcm';
    'ofc_2_on_pre',    '../dcm/S1704007_1_20170529/eja_svs_mpress_ofc_PRJ1704_0030/1.3.12.2.1107.5.2.43.66103.2017052911114075602620056_0030_000002.dcm';
    'dlpfc_1_off_pos', '../dcm/S1704007_2_20170602/eja_svs_mpress_dlpfc_PRJ1704_0031/1.3.12.2.1107.5.2.43.66103.2017060212571949517370481_0031_000001.dcm';
    'dlpfc_2_on_pos',  '../dcm/S1704007_2_20170602/eja_svs_mpress_dlpfc_PRJ1704_0031/1.3.12.2.1107.5.2.43.66103.2017060212571949581370482_0031_000002.dcm';
    'ofc_1_off_pos',   '../dcm/S1704007_2_20170602/eja_svs_mpress_ofc_PRJ1704_0028/1.3.12.2.1107.5.2.43.66103.2017060212403543166069784_0028_000001.dcm';
    'ofc_2_on_pos',    '../dcm/S1704007_2_20170602/eja_svs_mpress_ofc_PRJ1704_0028/1.3.12.2.1107.5.2.43.66103.2017060212403543229769785_0028_000002.dcm';
};

% Siemens' Demo
for nf = 1:length(files)
    [region, file] = files{nf, :};
    fd = dicom_open(file);
    y_s = dicom_get_spectrum_siemens(fd);
    fclose(fd);
    
    real_channel = real(y_s);
    imaginary_channel = imag(y_s);
    t = table(real_channel,imaginary_channel);
    writetable(t, fullfile('../txt/', ['S1704007_pre_' region '.txt']), 'FileType', 'text', 'Delimiter', '\t');
end

disp()
