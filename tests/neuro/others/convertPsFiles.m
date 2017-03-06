function convertPsFiles()

files = dir('*.ps');
for k=1:length(files)
    convertFirstPsFile( files(k).name );
end

end

function convertFirstPsFile(filename)

ps2pdf('psfile', filename,'pdffile', [filename '.pdf'], 'deletepsfile',1, 'verbose', 0);
clear all;

end