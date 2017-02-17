function help( cmd )

cmd = regexp( strtrim(cmd), '^\w*', 'match');
system(cmd{1});

end