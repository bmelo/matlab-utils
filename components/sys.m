function sys( varargin )
%SYS fslcommand args
%
%  Example: SYS git
%
%  To list allowed commands:
%    <a href="matlab:fslexec commands">fslexec commands</a>

cmds_allowed = sort({
  'git'
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