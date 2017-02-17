function gerarLog(filename, cellText)

if iscell(cellText)
    
    fid = fopen(filename, 'w');
    for k=1:length(cellText)
        fprintf(fid, '%s\n', cellText{k});
    end
    fclose(fid);
end

end