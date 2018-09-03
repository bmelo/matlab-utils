function [ idx ] = contains(  items, search )
%CONTAINS Function to find cell within strings
% parameters: 
%   items
%   search
if ~iscell(search), search = {search}; end

for s = search
    IndexC = strfind(items, s{1});
    idx = find(not(cellfun('isempty', IndexC)));
    if idx > 0
        break
    end
end
end

