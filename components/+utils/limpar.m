function limpar(direc)

cd(direc);
delete *.ps.pdf;
delete *k=;
delete *.png;
delete *.ps;
itens = dir('*.tif');
for k=1:length(itens)
    filepng = regexprep( itens(k).name, '\.tif*$', '.png' );
    S = imread( itens(k).name );
    imwrite( S, filepng );
    delete(itens(k).name);
end