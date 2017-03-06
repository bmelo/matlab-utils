function bower( varargin )
%BOWER commands args
%
%  Example: bower help
%
%  To list allowed commands:
%    <a href="matlab:sys git help">git commands</a>

params = strtrim( sprintf('%s ', varargin{:}) );
system( ['bower ' params]);

end