function [ out ] = getFilePattern( filepat, pos )
% pos = FIRST | LAST | integer
out = false;
if( ~exist('pos', 'var') )
    pos = 1;
else
    if strcmp(pos, 'FIRST')
        pos = 1;
    end
end

fileD = fileparts(filepat);
files = dir(filepat);
if( length(files) > 0 )
    if( strcmp(pos, 'LAST') )
        pos = length(files);
    end
    fileN = files(pos).name;

    out = fullfile(fileD, fileN);
end

end

