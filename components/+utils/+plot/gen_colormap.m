function [ cmap ] = gen_colormap( m, varargin )
%GEN_COLORMAP Summary of this function goes here
%   Detailed explanation goes here
colors = cell2mat(varargin(:));

r = interp_values( m, colors(:,1) );
g = interp_values( m, colors(:,2) );
b = interp_values( m, colors(:,3) );

cmap = [r g b];

end

function out = interp_values(m, vals)

nI = length(vals)-1;
n = floor(m/nI);
out = [];

for k = 1 : nI
    orig = vals(k);
    dest = vals(k+1);
    
    if(orig == dest)
        intvs = [ones(n, 1)*dest; dest];
    else
        step = (dest-orig) / (n-1);
        intvs = (orig:step:dest)';
        intvs(end) = dest;
    end
    out = [out; intvs];
    % Removing last value, it'll be added in the next loop (orig)
    if k < nI
        out(end) = [];
    else
        % Fixing some cases, where range doesn't fill all values
        out(end:m) = dest;
    end
end

end
