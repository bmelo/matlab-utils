function execRec(direc, func, varargin)
    itens = dir(direc);
    feval(func, direc, varargin{:});
    for k=1:length(itens)
        if( any( strcmp(itens(k).name, {'.' '..'})) ), continue; end
        if( itens(k).isdir )
            subf = fullfile(direc, itens(k).name);
            execRec(subf, func, varargin{:});
        end
    end
end