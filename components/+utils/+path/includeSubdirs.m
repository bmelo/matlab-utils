function includeSubdirs( subdirs )

S = dbstack('-completenames');
% Trying get directory of call function or current
try
    DIR = fileparts(S(2).file);
catch e
    DIR = pwd();
end

% Including each subdirectory
for k=1:length( subdirs )
    utils.path.initFolder( fullfile(DIR, subdirs{k}) );
end

end