function filename = resolve_name(filename)

if( ~exist(filename, 'file') )
    dirFs = dir( filename );
    if( ~isempty(dirFs) )
        filename = fullfile( fileparts(filename), dirFs(1).name );
    end
end