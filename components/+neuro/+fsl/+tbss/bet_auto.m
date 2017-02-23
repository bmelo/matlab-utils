function bet_auto( dir, subjPrefix, nums, suffix )
%BET_AUTO
%   Params: dir, subjPrefix, nums, [suffix]
%   Examples: 
%       bet_auto( 'Directory', 'PILO', [1:5 8 12:13] )
%       bet_auto( 'Directory', 'PILO', [1:5 8 12:13], 'ED_masked' )

if ~exist('suffix', 'var'); suffix = 'ED'; end;

%import cluster.sge
fprintf('EX-TRACE\n');
for nS = nums
    subjId = sprintf('%s%03d_', subjPrefix, nS, suffix);
    subjDir = fullfile( dir, subjId );
    fprintf( '%s [ %s ]\n\n', subjId, subjDir );
    
    %split
    cmdBet = sprintf('bet2 %s %s_mask -f 0.3 -g 0 -o -m -v', subjDir, subjDir);
    disp( cmdBet );
    system( cmdBet );
    
    %apaga último 3D
    delete( sprintf( '%s*3D0033*',subjDir) );
    
    %merge
    cmdMaths = sprintf( 'fslmaths %s -mul %s_mask_mask %s_masked', subjDir, subjDir, subjDir);
    disp( cmdMaths );
    system( cmdMaths );
    
    
end

end

