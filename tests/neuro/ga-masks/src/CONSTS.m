classdef CONSTS
    %CONSTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant = true)
        BASE_DIR = fileparts( fileparts( mfilename('fullpath') ) );
        TEMP_DIR = fullfile( CONSTS.BASE_DIR, 'tmp' ); 
        VENDORS_DIR = fullfile( CONSTS.BASE_DIR, 'vendors' ); 
        OUTPUT_DIR = fullfile( CONSTS.BASE_DIR, 'output' ); 
    end
    
end

