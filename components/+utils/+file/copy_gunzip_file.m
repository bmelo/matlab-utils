function [outfile] = copy_gunzip_file( file, outdir )
%COPY_GUNZIP_FILE Copy a file and gunzip in outdir
import utils.resolve_names;
if( ~isdir(outdir) )
    mkdir( outdir );
end
[~, basename] = fileparts(file);
outfile = fullfile( outdir, basename );
copyfile( file, [outfile '.gz'], 'f' );

try
    system( ['gunzip -f ' outfile '.gz'] );
catch
    gunzip(fullfile(directory, '*.gz'))
end

end