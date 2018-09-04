function rootdir = getpackpath( package )
%GETPACKPATH Return absolute path of a package
% parameters: 
%   package (root package dir)

s = what(package); %there may be several packages with the same name. s may be an array of structs
rootdir = s.path;

end

