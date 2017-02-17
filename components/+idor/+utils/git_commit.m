function git_commit( mensagem )
%GIT_COMMIT Summary of this function goes here
%   Detailed explanation goes here

cmdCommit = sprintf('git commit -m "%s"', mensagem);
system( 'git add . -A' );
system( cmdCommit );
system( 'git push' );

end

