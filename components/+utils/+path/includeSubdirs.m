function includeSubdirs( subdirs )

S = dbstack('-completenames');
DIR = fileparts(S(2).file);
for k=1:length( subdirs )
    utils.path.initFolder( fullfile(DIR, subdirs{k}) );
end

end