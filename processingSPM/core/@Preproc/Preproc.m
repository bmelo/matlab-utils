classdef Preproc < handle & ProcessamentoSPM
    
    properties(SetAccess = public) %With default values
        tr = 2;
        nslices = 22;
        voxelSize = [3 3 3];
        smoothing = [6 6 6];
        
        unifiedRealign = 0;
        ordem = {'realign','slicetiming','normalization','smooth'};
        prefixoAtual = ''; %Informa qual o prefixo da imagem que será processado em um determinado momento
        prefixoRaw = 'fMRI'; %Informa o prefixo das imagens sem tratamento
    end
    
    properties(Constant = true)
        %Lista com prefixos
        preRealign = 'r';
        preSlicetiming = 'a';
        preNormalization = 'w';
        preSmooth = 's';
        preDetrend = 'd';
    end
    
    methods (Access = public)
        function obj=Preproc( varargin ) %Construtor
            if nargin == 1
                obj.populateData(varargin{1});
            end
            obj.outDir = obj.inDir; %Os diretórios de entrada e saída são iguais!
        end
        processar(obj); %In separated file
    end
    
    methods (Access = protected)
        populaMatlabbatch(varargin); %In separated file
        
        function executarPreproc(obj)
            GenericModel.escreveTitulo( ['Executando pré-processamentos do sujeito ' obj.subject.code] );
            try
                for k=1:length(obj.ordem)
                    obj.posfixNameScript = ['-' num2str(now) '-' sprintf('%02d ',k) '(' obj.ordem{k} ')']; %Ajustando nome do script exportado
                    obj.populaMatlabbatch(obj.ordem{k});
                    if strcmp(obj.ordem{k}, 'detrend') & ~obj.onlyExportScripts
                        spm('quit');
                        cspm_lmgs_ivamod( obj.matlabbatch{1} );
                    else %Processamento via spm_jobman
                        if any(strcmp(obj.ordem{k}, {'realign', 'normalization'}))
                            spm('FnUIsetup');
                        end
                        obj.executar(obj.subject.fullPath, obj.matlabbatch);
                        if strcmp(obj.ordem{k}, 'realign')
                            txtRegressores = dir( fullfile(obj.subject.getSesDir(1), 'rp_*.txt') );
                            if ~isempty(txtRegressores)
                                if obj.unifiedRealign
                                    copyfile( fullfile(obj.subject.getSesDir(1), txtRegressores(1).name), fullfile(obj.subject.fullPath, [obj.prefixoAtual '_' txtRegressores(1).name]) );
                                else
                                    copyfile( fullfile(obj.subject.getSesDir(1), txtRegressores(1).name), fullfile(obj.subject.getSesDir(1), [obj.prefixoAtual '_' txtRegressores(1).name]) );
                                end
                            end
                        end
                    end
                end
                obj.finishTime = now;
            catch Er
                obj.error = MException('Preproc:Execute','Processamento encerrado em %s', obj.ordem{k});
                obj.error = obj.error.addCause(Er);
            end
        end
    end    
end