function txt_write( filename, txt, overwrite, echo )
%TXT_WRITE Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3, overwrite = 0; end
if nargin < 4, echo = 0; end

if overwrite
    mode = 'w';
else
    mode = 'a';
end

fh = fopen(filename, mode);
fprintf(fh, '%s\n', txt);
fclose(fh);

% Echo txt
if echo
    disp(txt); 
end

end

