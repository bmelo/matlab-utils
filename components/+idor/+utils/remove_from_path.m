function remove_from_path( exclude ) 

p = path;

r = p;
while true
   
    [t r] = strtok( r, ':');
    if ~isempty( strfind( t, exclude ) )
        rmpath( t );
    end
    
    if isempty( r ), break, end
    
end
