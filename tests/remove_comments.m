function remove_comments()
clc;
global xmldata;

filename = 'valiaemdia.wordpress.2013-02-25.xml';
xmldata = fileread(filename);
%extractSpams();

spams = extractSpamsId('comentariosRemovidosXML.log');
for k=1:100:length(spams)
    fim = k+100;
    if fim > length(spams); fim = length(spams); end;
    sIds = trim( sprintf('%s|',spams{k:fim}), '\|');
    fprintf('<wp:comment>(\\s)*<wp:comment_id>(%s)(.*?)</wp:comment>\n', sIds);
    xmldata =  regexprep( xmldata, sprintf('<wp:comment>(\\s|\\n)*<wp:comment_id>(%s)(.*?)</wp:comment>', sIds), '' );
end
fh = fopen('xmlEnxugado.xml','w');
fprintf(fh, '%s', xmldata);
fclose(fh);

end

function out = trim( str, term )
out = regexprep(str, sprintf('^%s|%s$',term,term), '' );
end

function idsSpams = extractSpamsId(filename)

xmldata = fileread(filename);
dados = regexp( xmldata, '<wp:comment>(\s|\n)*<wp:comment_id>(?<id>\d+)(.*?)</wp:comment>', 'names' );
idsSpams = struct2cell(dados);
idsSpams = idsSpams(1,:);
end

function extractSpams()
global xmldata;
fh = fopen('comentariosRemovidos.log', 'w');
fh2 = fopen('comentariosRemovidosXML.log', 'w');
fh3 = fopen('comentariosMantidos.log', 'w');
fh4 = fopen('comentariosMantidosXML.log', 'w');

comments = regexp( xmldata, '<wp:comment>(.*?)</wp:comment>', 'match' );

keywords = { 'ALPRAZOLAM', 'ambien', 'klonopin', 'xanax', 'meridia','Accutane','adipex','payday','plavix', 'viagra', 'cialis', 'mcwqbukfkdld', ...
    'http\:\/\/replica\S*', 'porno', 'http\:\/\/nf\-ussr\.ru\S*', '\[Hello', 'hot\sdamn', 'Vestidos\sde\sNoiva' };
pattern = regexprep( sprintf('(\\W)%s(\\W)|',keywords{:}) , '\|$',''  );
for k=1:length(comments)
    comentario = regexp( comments{k}, '<wp:comment_content>(.*?)</wp:comment_content>', 'tokens' );
    comentario = comentario{1};
    retornos = regexpi( comentario, pattern);
    if ~isempty(retornos{:})
        fprintf(fh, '%s\n', char(comentario{1}));
        fprintf(fh2, '%s\n', char(comments{k}));
        %xmldata = strrep(xmldata, comments{k}, '');
    else
        fprintf(fh3, '%s\n', char(comentario{1}));
        fprintf(fh4, '%s\n', char(comments{k}));
        fprintf('%s\n', char(comentario{1}) );
    end
end
fclose(fh);
fclose(fh2);
fclose(fh3);
fclose(fh4);
end