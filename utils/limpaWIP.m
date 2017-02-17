function limpaWIP(direc)

files = dir( fullfile(direc, '*WIP*') );
for k=1:length(files)
    filename = files(k).name;
    newfilename = regexprep(filename,'WIP', '');
    if( ~strcmp(filename, newfilename) )
        fprintf('%s -> %s\n',filename, newfilename )
        movefile( fullfile(direc, filename), fullfile(direc, newfilename) );
    end
end