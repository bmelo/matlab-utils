matlabbatch{1}.spm.stats.con.spmmat = { fullfile( dest_dir_subj, 'SPM.mat') };


for k=1:length(model.contrast)
    
    matlabbatch{1}.spm.stats.con.consess{k}.tcon.name    = model.contrast(k).name;
    matlabbatch{1}.spm.stats.con.consess{k}.tcon.convec  = model.contrast(k).vec;
    if(  ~isfield(model.contrast(k),'sessrep') )
        model.contrast(k).sessrep = 'repl';
    end
    matlabbatch{1}.spm.stats.con.consess{k}.tcon.sessrep = model.contrast(k).sessrep;

end

if length(sessions(1).names) > 0
    matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+1}.fcon.name = 'EOI';
    matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+1}.fcon.convec = { eye(length(sessions(1).names)); }';
    matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+1}.fcon.sessrep = 'repl';
    
    if ~isempty(sessions(r).regfile)
        
        tmp = load( sessions(r).regfile );
        [tmp2 tmp_name tmp_ext] = fileparts( sessions(r).regfile );

        matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+2}.fcon.name = 'EOI_ALL';
        matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+2}.fcon.convec = { eye(length(sessions(1).names)+size(tmp,2)) }';
        matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+2}.fcon.sessrep = 'repl';
    
        columns_offset = length(sessions(1).names);
        for k=1:length(sessions(1).regcontrast)
            cols = sessions(1).regcontrast(k).columns;
            matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+2+k}.fcon.name = sessions(1).regcontrast(k).name;
            matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+2+k}.fcon.convec = { [zeros(cols,columns_offset) , eye(cols)] }';
            matlabbatch{1}.spm.stats.con.consess{length(model.contrast)+2+k}.fcon.sessrep = 'repl';
            columns_offset = columns_offset + cols;
        end
        
    end
end

matlabbatch{1}.spm.stats.con.delete = 1;