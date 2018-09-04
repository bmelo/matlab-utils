function gunzip_dir( directory )
%GUNZIP_DIR Try gunzip all gz files in directory
%   Detailed explanation goes here

% Try gunzip all gz files
try
    cmd = sprintf('find %s -name "*.gz" -type f -exec gunzip -f "{}" \\;', directory);
    system( cmd );
catch
    gunzip(fullfile(directory, '*.gz'))
end

end

