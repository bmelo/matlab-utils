function [ outfilename ] = concatFiles( files, outfile )
%CONCATFILES Summary of this function goes here
%   Detailed explanation goes here
if( isempty( files ) )
    return;
end

if ~iscell(files)
    files = {files};
end

[dirname filename] = fileparts( files{1} );
outfilename = sprintf(['%s/' outfile], dirname, filename);
values = dlmread(files{1});
for k=2:length(files)
   values = [values; dlmread(files{k})];
end
dlmwrite(outfilename, values);

end