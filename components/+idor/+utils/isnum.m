function [ out ] = isnum( value )
%ISNUM Summary of this function goes here
%   Detailed explanation goes here

if ischar( value )
    out = ~isempty( regexp(value, '^\d+$', 'once') );
else
    out = isnumeric( value );
end

end

