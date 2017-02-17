function [ pos ] = findField( item, search, field )
if( ~isfield( item, field ) ), return; end;

positions = strcmp( search, {item(:).(field)} );
pos = find(positions, 1);