function [ lims ] = dimlims( data )
%DIMLIMS - Extract limits with information in a matrix
% Output: min and max value for each dimension (row).

positions = find( ~isnan(data(:)) );
n_items = length(positions);
dims = size(data);
idxs = zeros(n_items, length(dims));
pos = cell(1, length(dims));

for k = 1:n_items
    [pos{:}] = ind2sub(dims, positions(k));
    idxs(k, :) = [pos{:}];
end

lims = [min(idxs,[],1); max(idxs,[],1)]';

end