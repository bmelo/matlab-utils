classdef ToolsSPM
    
    methods(Static = true)
        
        %==========================================================================
        function prevsection()
        %==========================================================================
            xSPM = evalin('base', 'xSPM');
            hReg = evalin('base', 'hReg');
            spm_sections(xSPM, hReg, [which('single_subj_T1.nii') ',1'])
            
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
            ToolsSPM.prevsection();
        end
        
        function chgCoords( xyz )
            hReg = evalin('base', 'hReg');
            RD = get(hReg,'UserData');
            xyz = spm_XYZreg('RoundCoords',xyz,RD.M,RD.D);
            spm_XYZreg('SetCoords', xyz ,hReg);
        end
        
        function printImg( filename )

            matlabbatch{1}.spm.util.print.fname = filename;
            matlabbatch{1}.spm.util.print.opts.opt = { '-dpsc2' '-append' };
            matlabbatch{1}.spm.util.print.opts.append = true;
            matlabbatch{1}.spm.util.print.opts.ext = '.ps';
            spm_jobman('run', matlabbatch);
            %ps2pdf( 'psfile', filename,'pdffile', [filename '.pdf'] );
            
        end
        
    end
    
end

