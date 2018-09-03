function [ table ] = tsvread_read( filename )
%BIDS_TSVREAD Summary of this function goes here
%   Detailed explanation goes here
table = readtable(filename,'FileType','text','Delimiter','\t','TreatAsEmpty',{'N/A','n/a'});

end

