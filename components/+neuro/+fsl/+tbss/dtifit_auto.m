function dtifit_auto( dir, subjPrefix, nums )
%DTIFIT_AUTO
%   Params: dir, subjPrefix, nums
%   Examples: 
%       dtifit_auto( 'Directory', 'PILO', [1:5 8 12:13] )

%import idor.blade
fprintf('EX-TRACE\n');
for nS = nums
    subjId = sprintf('%s%03d', subjPrefix, nS);
    subjDir = fullfile( dir, subjId );
    fprintf( '%s [ %s ]\n\n', subjId, subjDir );
    
    %dtifit
    cmdDtifit = sprintf('dtifit -k %s_ED_masked -o %s -m %s_ED_mask_mask -r %s/bvec -b %s/bval -V', subjDir, subjDir, subjDir, dir, dir);
    disp( cmdDtifit );
    system( cmdDtifit );
    
end

end

