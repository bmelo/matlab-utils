function convertPsFiles(direc)
if(~exist('direc','var')), direc = pwd; end
disp(direc);
files = dir( fullfile(direc,'*.ps') );
for k=1:length(files)
    fullfilename = fullfile(direc,files(k).name);
    convertFirstPsFile( fullfilename );
end

end

function convertFirstPsFile(filename)

filename = regexprep(filename,'\.ps$','');
ps2pdf('psfile', [filename '.ps'], 'pdffile', [filename '.pdf'], 'deletepsfile',0, 'verbose', 0);
clear all;

end