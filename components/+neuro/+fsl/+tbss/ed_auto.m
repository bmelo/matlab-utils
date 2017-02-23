function ed_auto( dir, subjPrefix, nums )
%ED_AUTO
%   Params: dir, subjPrefix, nums
%   Example: ed_auto( 'Directory', 'PILO', [1:5 8 12:13] )

fprintf('EDDY CURRENT CORRECTION\n');
for nS = nums
    subjId = sprintf('%s%03d', subjPrefix, nS);
    subjDir = fullfile( dir, subjId );
    fprintf( '%s [ %s ]\n\n', subjId, subjDir );
    
    %eddy_correct    
    cmdEC = sprintf('eddy_correct %s_ex.nii %s_ED 0', subjDir, subjDir);
    disp( cmdEC );
    system( cmdEC );    
end

end

