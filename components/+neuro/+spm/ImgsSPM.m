classdef ImgsSPM < handle
    %ImgsSPM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        outDir = fullfile(pwd, '..', 'EXPORTED_IMGS');
        inDir = pwd;
        pattern = '*';
        type = 'ativacao';
        threshold = 0.001;
        extent = 0;
        FWE = false;
        export_pdf = true;
        xyz = [0 1 -1];
        goTo = [];
        cons = [];
        prefix = '';
        posfix = '';
        mask = '';
        mask_ex = 0;
    end
    
    properties(Access = private)
        con = 1;
        spmCons = [];
    end
    
    methods(Static = true)
        %Checa se diretorio existe, criando se necessario
        function checkFolder( dirCk )
            if ~isdir( dirCk )
                try
                    mkdir( dirCk );
                catch
                    [root, ~] = fileparts( dirCk );
                    neuro.spm.ImgsSPM.checkFolder( root );
                    mkdir( dirCk );
                end
            end
        end
    end
    
    methods(Access = public)
        function strXYZ = xyz2str(obj)
            strXYZ = [ '[' num2str(obj.xyz(1)) ' ' num2str(obj.xyz(2)) ' ' num2str(obj.xyz(3)) ']' ];
        end
        
        function desc = getThreDesc(obj)
            desc = 'unc.';
            if( obj.FWE == 1)
                desc = 'FWE';
            elseif ischar(obj.FWE)
                [~,filename] = fileparts(obj.FWE);
                desc = ['smc-' filename];
            end
        end
        
        %% Carrega SPM.mat
        function open( obj, varargin )
            if ~isempty(varargin)
                obj.inDir = varargin{1};
            end
            
            %Modelo para gerar arquivos
            matlabbatch{1}.spm.stats.results.spmmat = { fullfile( obj.inDir, 'SPM.mat') };
            matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
            matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
            if( obj.FWE )
                matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
            else
                matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
            end
            matlabbatch{1}.spm.stats.results.conspec.thresh = obj.threshold;
            matlabbatch{1}.spm.stats.results.conspec.extent = obj.extent;
            if ~isempty(obj.mask)
                matlabbatch{1}.spm.stats.results.conspec.mask.image.name = {[obj.mask ',1']};
                matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = obj.mask_ex;
            end
            matlabbatch{1}.spm.stats.results.units = 1;
            matlabbatch{1}.spm.stats.results.print = false;
            
            %% Executando SPM
            spm('defaults', 'fmri');
            spm_jobman('run', matlabbatch);
            obj.spmCons = evalin('base', 'SPM.xCon');
        end
        
        %% Exporta algo
        function export( obj, outDir )
            dirRoot = pwd;
            
            if( obj.exportAllCons() ); obj.cons = 1:length(obj.spmCons); end;
            for ncon = 1:length(obj.cons)
                obj.con = obj.cons(ncon);
                fullOutDir = fullfile(outDir, obj.spmCons(obj.con).name);
                obj.exportImgs( fullOutDir );
            end
            
            cd( dirRoot );
            
        end
    end
    
    methods(Access = private)
        function out = exportAllCons(obj)
            out = isempty(obj.cons);
        end
        
        function execGoTo(obj)
            if isempty(obj.goTo); return; end;
            if( ischar( obj.goTo ) )
                neuro.spm.ToolsSPM.chgCoords( ToolsSPM.goto( obj.goTo ) ); %Go to global maxima
            else
                neuro.spm.ToolsSPM.chgCoords( obj.goTo );
            end
        end
        
        function exportImgs(obj, outDir)
            neuro.spm.ToolsSPM.chgcon(obj.con);
            if( obj.exportAllCons & ~isempty(obj.goTo) ); obj.execGoTo(); end;
            %% Exportando arquivos
            if ~iscell(obj.type)
                obj.doExport(obj.type, outDir);
            else
                for k=1:length(obj.type)
                    obj.doExport(obj.type{k}, outDir);
                end
            end
        end
        
        function doExport(obj, type, outDir)
            import utils.*;
            import neuro.spm.*;
            xSPM = evalin('base', 'xSPM');
            
            %num = regexp(dir, '([^_ \t][^_\t]*)', 'match');
            filename = fullfile( outDir, sprintf('%sp%s(%s_k=%d)_%s_%s%s.nii', obj.prefix, num2str(obj.threshold), obj.getThreDesc(), obj.extent, xSPM.title, obj.xyz2str(), obj.posfix) );
            filename = correctFilename(filename);
            % Checking if output dir exists
            outDir = fileparts(filename); % After correction
            if ~isdir(outDir), mkdir(outDir); end;
            % Exporting
            switch type
                case 'ativacao'
                    ImgsSPM.checkFolder( outDir );
                    if obj.export_pdf
                        filename = ToolsSPM.print( filename, 'ps' ); 
                        ps2pdf( filename );
                    end
                    ToolsSPM.print( filename, 'png' );
                case 'save'
                    obj.checkFolder( fileparts(filename) );
                    spm_write_filtered(xSPM.Z,xSPM.XYZ,xSPM.DIM,xSPM.M,...
                        sprintf('SPM{%c}-filtered: u = %5.3f, k = %d', xSPM.STAT,xSPM.u,xSPM.k), filename );
            end
        end
    end 
end