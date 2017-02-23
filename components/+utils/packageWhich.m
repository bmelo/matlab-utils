function [ root_dir ] = packageWhich( package )

packages = regexp(package, '\.', 'split');
curPack = what( packages{1} );
root_dir = curPack.path;
for k = 2:length(packages)
    subElem = packages{k}; %Can be a lot of things
    if exist( fullfile( root_dir, ['+' subElem] ), 'dir' )
        root_dir = fullfile( root_dir, ['+' subElem]);
    elseif exist( fullfile( root_dir, ['@' subElem] ), 'dir' )
        root_dir = fullfile( root_dir, ['@' subElem] );
    elseif exist( fullfile( root_dir, subElem ), 'dir' )
        root_dir = fullfile( root_dir, subElem );        
    else
        root_dir = fullfile( root_dir, [subElem '.m'] );
        break;
    end
end

end