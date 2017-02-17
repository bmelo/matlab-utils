function [out] = mergeStructs( varargin )
if nargin < 2; error('function mergeStructs needs at least 2 inputs'); end;

out = varargin{1};

for k=2:length(varargin)
    toMerge = varargin{k};
    fields = fieldnames( toMerge );
    for nF = 1 : length( fields )
        field = fields{nF};
        if isstruct( toMerge.(field) ) && isfield( out, field ) && isstruct( out.(field) )
            out.(field) = mergeStructs( out.(field), toMerge.(field) );
        else
            out.(field) = toMerge.(field);
        end
    end
end

end