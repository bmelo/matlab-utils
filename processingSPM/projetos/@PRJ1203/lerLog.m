%Função que lê o log e retorna um cell com todos os dados
function out = lerLog(fullfilepath, varargin)

type = 'CE';
if nargin>1
    type = varargin{1};
end;

if ~exist(fullfilepath,'file')
    out = false; return;
end

startText = 'NÂºQUEST	|';
parserStr = '%n%1s%f%f%n%n%n%n%n%n%n';
if strcmp(type, 'CG')
    startText = 'NÂºTRIAL	|';
    parserStr = '%n%1s%1s%n%n%n%n';
end;
file = fopen(fullfilepath, 'r');

tamStart = length(startText);
tline = fgetl(file);
cont = 1;
if tamStart>0
    while (length(tline)<tamStart || ~strcmp( tline(1:tamStart), startText ) ) && ~feof(file)
        tline = fgetl(file);
        cont = cont+1;
    end
end
fclose(file);
file = fopen(fullfilepath, 'r');

out = textscan(file, parserStr, 'Delimiter', '|', 'Headerlines', cont);

fclose(file);

end