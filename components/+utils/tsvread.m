function [ events ] = tsvread( tsvfile )
%TSVREAD
%   tsvfile: Filename in TSV format (Tab-Separated Value)

% Extracting all values
fh = fopen( tsvfile );
events = get_row( fh );
while ~feof( fh )
    row = get_row( fh );
    % Checking if they have the same number of columns
    if size(row,2) == size(events, 2)
        events = [events; row];
    end
end
fclose( fh );

end

% Extract values, converting to numbers when necessary
function row = get_row( fid )
line = fgetl(fid);
if line == -1 %% Final do arquivo
    row = {};
    return;
end
items = regexp(line, '\t', 'split');

row = cell(1, length(items));
for n = 1:length(items)
    row{n} = str2double( items{n} );
    if isnan(row{n})
        row{n} = items{n};
    end
end

end

