function remove_comments()
clc;
global items;

filename = 'items.xml';
extractItems(filename);

%varre os itens e salva aqueles que são attachments
%fh = fopen('xmlEnxugado.xml','w');
cont = 0;
for k=1:length(items)
    if any(strfind(items{k},'<wp:post_type>attachment</wp:post_type>'))
        cont = cont+1;
%        fprintf(fh, '%s', items{k});
    end
end
disp(cont);
%fclose(fh);

end

function out = trim( str, term )
out = regexprep(str, sprintf('^%s|%s$',term,term), '' );
end

function extractItems(filename)
global items;
items = regexp( fileread(filename), '<item>(.*?)</item>', 'match' );
end

function idsSpams = extractSpamsId(filename)

xmldata = fileread(filename);
dados = regexp( xmldata, '<wp:comment>(\s|\n)*<wp:comment_id>(?<id>\d+)(.*?)</wp:comment>', 'names' );
idsSpams = struct2cell(dados);
idsSpams = idsSpams(1,:);

end

function extractApproveds()
global comments;
fh = fopen('comentariosAprovados.xml', 'w');
for k=1:length(comments)
    if(strfind(comments{k}, '<wp:comment_approved>1</wp:comment_approved>'))
        fprintf(fh, '%s\n', char(comments{k}));
    end
end
fclose(fh);
end

function extractSpams()
global comments;
fh = fopen('comentariosRemovidos.log', 'w');
fh2 = fopen('comentariosRemovidosXML.log', 'w');
fh3 = fopen('comentariosMantidos.log', 'w');
fh4 = fopen('comentariosMantidosXML.log', 'w');

keywords = { 'ALPRAZOLAM', 'ambien', 'klonopin', 'xanax', 'meridia','Accutane','adipex','payday','plavix', 'viagra', 'cialis', 'mcwqbukfkdld', ...
    'http\:\/\/replica\S*', 'porno','casino\.net', 'http\:\/\/nf\-ussr\.ru\S*', '\[Hello', 'hot\sdamn', 'Vestidos\sde\sNoiva' };
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