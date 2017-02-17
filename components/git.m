function git( varargin )
%GIT commands args
%
%  Example: git status
%
%  To list allowed commands:
%    <a href="matlab:sys git help">git commands</a>

params = strtrim( sprintf('%s ', varargin{:}) );
system( ['git ' params]);

end