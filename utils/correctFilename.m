function out = correctFilename(filename)

patt = '[><;,*]';
out = regexprep(filename,patt,'_');
out = regexprep(out,'_{2,}','_');
out = regexprep(out,'_*$','');
