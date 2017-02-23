function includeSubdirs( subdirs )

S = dbstack('-completenames');
DIR = fileparts(S(2).file);
for k=1:length( subdirs )
    initFolder( fullfile(DIR, subdirs{k}) );
end

end