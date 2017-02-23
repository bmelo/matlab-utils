function [ output ] = find( dirdata, pattern, type, depth )
%Find file using regular expression
%
%   Example of use: find( '/dados1', '.*(img|nii)', 'f' )
%
output = {};
maxdepth = '';
if( ~exist('type', 'var') ); type = 'd'; end;
if( exist('depth', 'var') ); maxdepth = ['-maxdepth ' depth]; end;

findCmd = sprintf('find %s %s-regextype posix-extended -regex "%s" -type %s | sort', dirdata, maxdepth, pattern, type);
[~, finds] = system( findCmd );

if( ~isempty(finds) )
    finds = regexprep(finds,'\n*$', '');
    output = regexp(finds,'\n', 'split');   
end

end

