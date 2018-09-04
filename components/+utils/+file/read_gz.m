function [ data ] = read_gz( filename )
%READ_GZ Summary of this function goes here
%   Detailed explanation goes here

% Get the serialized data
streamCopier = com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
baos = java.io.ByteArrayOutputStream;

fileStr     = java.io.FileInputStream(filename);
inflatedStr = java.util.zip.GZIPInputStream(fileStr);
%charStr     = java.io.InputStreamReader(inflatedStr);
%lines       = java.io.BufferedReader(charStr);

buffer = zeros( 1, 1, 'int32' );
%buffer = int32(arrayfun( @(b)read(inflatedStr, 'int32'), buffer ));
%disp(buffer);
javaMethod(inflatedStr, read, buffer, 0, 1);
return


streamCopier.copyStream(inflatedStr, baos);
inflatedStr.close;
data = baos.toByteArray;  % array of Matlab int8

end
