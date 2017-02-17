function runMestre()

% definicoes usuario
subjects = 1;
preproc = 0;
stats = 1;
single_run = 0;

if preproc
    % sessoes em conjunto
    obj = PRJ1206();
    obj.subjects = subjects;
    
    obj = initParamsGeral( obj );
    
    obj.dcm2nii();
    obj.processarPreproc();

elseif stats

    if ~single_run        
        obj = PRJ1206();
        obj.subjects = 1;
        obj.description = 'Analise com Regressores';
        obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'NORMAL+REGRESSORES');
        obj.processarFirstLevel('regressores', true);
        % obj.processarFirstLevelFixed('regressores', true);
    end

end

if single_run
    
    obj = PRJ1206_SEP_EXE();
    obj.subjects = subjects;
    runSPM( obj );
    
    obj = PRJ1206_SEP_1P();
    obj.subjects = subjects;
    runSPM( obj );
    
    obj = PRJ1206_SEP_3P();
    obj.subjects = subjects;
    runSPM( obj );
end


end

function obj = prepareObj( obj, subjects )
    obj = initParamsGeral( obj );
    obj.subjects = subjects;
end