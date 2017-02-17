function copySPMDataStat(dirIn, dirOut, varargin)
%COPYSPMDATASTAT Summary of this function goes here
%   Detailed explanation goes here

if ~isdir(dirOut)
    mkdir(dirOut);
end
copyfile( [dirIn '\*.img'] , dirOut );
copyfile( [dirIn '\*.hdr'] , dirOut );
copyfile( [dirIn '\SPM.mat'] , dirOut );
if ~isempty(varargin)
    spm_jobman('run', varargin{1});
end

end
