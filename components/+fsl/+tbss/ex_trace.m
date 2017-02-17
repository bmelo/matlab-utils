function ex_trace( dir, subjPrefix, nums )
%EX_TRACE
%   Params: dir, subjPrefix, nums
%   Example: ex_trace( 'Directory', 'PILO', [1:5 8 12:13] )

%import idor.blade
fprintf('EX-TRACE\n');
for nS = nums
    subjId = sprintf('%s%03d', subjPrefix, nS);
    subjDir = fullfile( dir, subjId );
    fprintf( '%s [ %s ]\n\n', subjId, subjDir );
    
    %split
    cmdSplit = sprintf('fslsplit %s %s_3D -t', subjDir, subjDir);
    disp( cmdSplit );
    system( cmdSplit );
    
    %apaga último 3D
    delete( sprintf( '%s*3D0033*',subjDir) );
    
    %merge
    cmdMerge = sprintf( 'fslmerge -a %s_ex %s_3D*', subjDir, subjDir);
    disp( cmdMerge );
    system( cmdMerge );
    
    %limpa sujeira
    delete( sprintf( '%s*3D*', subjDir ) );
    
end

end

