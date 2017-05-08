function standard_space( infile, outfile )
%STANDARD_SPACE Summary of this function goes here
%   Detailed explanation goes here

fprintf('fslreorient2std %s %s\n', infile, outfile);
fslexec('fslreorient2std', infile, outfile);

end

