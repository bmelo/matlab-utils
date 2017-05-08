function cdEditor()
%CDEDITOR Summary of this function goes here
%   Detailed explanation goes here

h = matlab.desktop.editor.getActive;
fdir = fileparts(h.Filename);
cd(fdir);

end

