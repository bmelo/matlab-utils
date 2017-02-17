function [ cons ] = get_cons_path( config, subjs, conN, proc_base )
%GET_CONS_PATH Summary of this function goes here
%   Detailed explanation goes here

contr = sprintf( 'con_%04d', conN );

cons = cell(length(subjs),1);
for s=1:length(subjs)
    subj = get_subjid( config, subjs(s) );
    base_dir = fullfile( proc_base, subj );
    ext = '.nii';
    if( ~exist( fullfile( base_dir, [contr ext] ) ,'file') )
        ext = '.img';
    end
    cons{s,1} = fullfile( base_dir, [contr ext ',1'] );
end


end

