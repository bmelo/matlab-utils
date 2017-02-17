function out = idorFolder( folder )

if ispc
    inicio = '//10.36.4.201/dados';
    inicioRem = '/dados';
else
    inicio = '/dados';
    inicioRem = '//10.36.4.201/dados'; %Para remover
end

folder = strrep(folder, '\', '/');
folder = regexprep(folder,  ['^' inicioRem] , inicio, 'ignorecase');
out = regexprep(folder, '\\|/', filesep);

end