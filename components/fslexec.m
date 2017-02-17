function fslexec( varargin )
%FSLEXEC fslcommand args
%
%  Example: FSLEXEC bet
%
%  To list allowed commands:
%    <a href="matlab:fslexec commands">fslexec commands</a>

cmds_allowed = sort({
  'tbss_1_preproc'
  'tbss_2_reg'
  'dtifit'
  'tbss_3_postreg'
  'tbss_4_prestats'
  'feat'
  'fslmaths'
  'fslmeants'
  'fslsplit'
  'fslmerge'
  'melodic'
  'bet'
  'eddy_correct'
  'randomise_parallel'
  'tbss_non_FA'
  'design_ttest2'
  'fsl_regfilt'
  'fsl_sub'
  'fslswapdim'
  'fslorient'
  'fslreorient2std'
});

try
    cmd = varargin{1};
    allowed = any( strcmp( cmd, cmds_allowed ) ); %checa se o comando é permitido
    
    %Executa comando, caso seja permitido
    if allowed
        system( strtrim( sprintf('%s ', varargin{:}) ) );
    elseif strcmp(cmd, 'commands')
        fprintf('\n')
        links = cellfun(@(x) sprintf( '<a href="matlab:fslexec %s">%s</a>', x, x ), cmds_allowed, 'Unif', false );
        fprintf( '   %s \n', links{:} );
        %fprintf( '   <a href="matlab:fslexec %s">%1s</a> \n', cmds_allowed{:} );
        fprintf('\n')
    else
        disp( 'Command not allowed.' );
    end
catch
end
end