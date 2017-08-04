function [ maxdim ] = max_dim( mdata )
%MAX_DIM Returns highest dimension of a matrix

[~, maxdim] = max( size(mdata) );

end

