function out = correctFilename(filename)

patt = '[><;,]';
out = regexprep(filename,patt,'_');
