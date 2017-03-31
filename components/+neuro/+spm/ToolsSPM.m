classdef ToolsSPM
    
    methods(Static = true)
        
        %==========================================================================
        function prevsection()
        %==========================================================================
            xSPM = evalin('base', 'xSPM');
            hReg = evalin('base', 'hReg');
            dirSPM = fileparts( which('spm'));
            imgShow = fullfile(dirSPM,'canonical','single_subj_T1.nii,1');
            spm_sections(xSPM, hReg, imgShow);
            
        end
        
        %==========================================================================
        function chgcon(Ic)
        %==========================================================================
            xSPM = evalin('base', 'xSPM');
            xSPM2.swd   = xSPM.swd;
            try, xSPM2.units = xSPM.units; end
            xSPM2.Ic    = Ic;
            if isempty(xSPM2.Ic) || all(xSPM2.Ic == 0), xSPM2 = rmfield(xSPM2,'Ic'); end
            xSPM2.Im    = xSPM.Im;
            xSPM2.pm    = xSPM.pm;
            xSPM2.Ex    = xSPM.Ex;
            xSPM2.title = '';
            if ~isempty(xSPM.thresDesc)
                td = regexp(xSPM.thresDesc,'p\D?(?<u>[\.\d]+) \((?<thresDesc>\S+)\)','names');
                if isempty(td)
                    td = regexp(xSPM.thresDesc,'\w=(?<u>[\.\d]+)','names');
                    td.thresDesc = 'none';
                end
                if strcmp(td.thresDesc,'unc.'), td.thresDesc = 'none'; end
                xSPM2.thresDesc = td.thresDesc;
                xSPM2.u     = str2double(td.u);
                xSPM2.k     = xSPM.k;
            end
            hReg = spm_XYZreg('FindReg',spm_figure('GetWin','Interactive'));
            xyz  = spm_XYZreg('GetCoords',hReg);
            [hReg,xSPM,SPM] = spm_results_ui('setup',xSPM2);
            spm_XYZreg('SetCoords',xyz,hReg);
            assignin('base','hReg',hReg);
            assignin('base','xSPM',xSPM);
            assignin('base','SPM',SPM);
            figure(spm_figure('GetWin','Interactive'));
            neuro.spm.ToolsSPM.prevsection();
        end
        
        function chgCoords( xyz )
            hReg = evalin('base', 'hReg');
            RD = get(hReg,'UserData');
            xyz = spm_XYZreg('RoundCoords',xyz,RD.M,RD.D);
            spm_XYZreg('SetCoords', xyz ,hReg);
        end
        
        function xyz = goto(opt)
            xSPM = evalin('base', 'xSPM');
            %Special cases
            if ischar(opt)
                switch opt
                    case 'zero'
                        xyz = [0 1 -1];
                    case 'glmax'
                        try
                            [~, i] = max(xSPM.Z); i = i(1);
                            xyz       = xSPM.XYZmm(:,i);
                        catch
                            xyz = [0 1 -1];
                        end
                end
            else
                xyz = opt;
            end
            neuro.spm.ToolsSPM.chgCoords( xyz );
        end
        
        %Correct function. Below functions will be deprecated
        function filename = print( filename, format )
            filename = utils.correctFilename([filename '.' format]);
            matlabbatch{1}.spm.util.print.fname = filename;
            matlabbatch{1}.spm.util.print.fig.figname = 'Graphics';
            matlabbatch{1}.spm.util.print.opts = format;
            spm_jobman('run', matlabbatch);
        end
        
        function filename = printPS( filename )
            warning('ToolsSPM.printPS is deprecated. Try to use ToolsSPM.print with file format.');
            filename = correctFilename([filename '.ps']);
            matlabbatch{1}.spm.util.print.fname = filename;
            matlabbatch{1}.spm.util.print.fig.figname = 'Graphics';
            matlabbatch{1}.spm.util.print.opts = 'ps';
            spm_jobman('run', matlabbatch);
        end
        
        function filename = printPDF( filename )
            warning('ToolsSPM.printPDF is deprecated. Try to use ToolsSPM.print with file format.');
            filename = neuro.spm.ToolsSPM.printPS( filename );
            try
                utils.ps2pdf( 'psfile', filename, 'pdffile', [filename '.pdf'] );
                filename = [filename '.pdf'];
            catch
            end
        end
        
        function printImg( filename, png )
            warning('ToolsSPM.printImg is deprecated. Try to use ToolsSPM.print with file format.');
            if ~exist('png', 'var')
                png = true;
            end
            filename = correctFilename([filename '.tif']);
            matlabbatch{1}.spm.util.print.fname = filename;
            matlabbatch{1}.spm.util.print.fig.figname = 'Graphics';
            %Converte TIF para PNG
            if png
                format = 'png';
            else
                format = 'tif';
            end
            matlabbatch{1}.spm.util.print.opts = format;
            spm_jobman('run', matlabbatch);
        end
        
        function convertTIFF2PNG( filetiff )
            filepng = regexprep( filetiff, '\.tif*$', '.png' );
            S = imread( filetiff );
            imwrite( S, filepng );
            delete(filetiff);
        end
        
        function applyFWE( threshold, extent )
            xSPM2 = evalin('base', 'xSPM');
            xSPM2.thresDesc  = 'FWE';
            xSPM2.u = threshold;
            xSPM2.k = extent;
            spm_results_ui('setup',xSPM2);
        end
        
    end
    
end

