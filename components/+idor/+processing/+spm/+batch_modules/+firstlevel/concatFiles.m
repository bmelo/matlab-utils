function [ outfilename ] = concatFiles( files, outfile )
if( isempty( files ) )
    return;
end
%CONCATFILES Summary of this function goes here
%   Detailed explanation goes here
[dirname filename] = fileparts( files{1} );
outfilename = sprintf(['%s/' outfile], dirname, filename);
values = dlmread(files{1});
for k=2:length(files)
   values = [values; dlmread(files{k})];
end
dlmwrite(outfilename, values);

end