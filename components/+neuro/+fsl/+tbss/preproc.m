function [ cmdout ] = preproc( nii )
%PREPROC Summary of this function goes here
%   Detailed explanation goes here
import idor.blade
cmd = sprintf('tbss_1_preproc %s', nii);

[~,cmdout] = system( cmd );
%cmdout = runLamina( 1, cmd );

end

