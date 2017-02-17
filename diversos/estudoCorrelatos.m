if( ~exist('valores','var') )
    if( exist('valores.mat','file') )
        load('valores.mat');
    else
        % GERAIS
        valores.cansaco = reshape( load('CANSACO.txt'), 1,[] );
        valores.concentracao = reshape( load('CONCENTRACAO.txt'), 1,[] );
        
        % POR EMOÇÃO
        valores.tern.tmax = reshape( load('TERNURA_T_max.txt'), 1,[] );
        valores.tern.tsize = reshape( load('TERNURA_T_size.txt'), 1,[] );
        valores.tern.cenario = reshape( load('TERNURA_CENARIO.txt'), 1,[] );
        valores.tern.intensidade = reshape( load('TERNURA_INTENSIDADE.txt'), 1,[] );
        valores.tern.mantra = reshape( load('TERNURA_MANTRA.txt'), 1,[] );
        
        valores.angu.tmax = reshape( load('ANGUSTIA_T_max.txt'), 1,[] );
        valores.angu.tsize = reshape( load('ANGUSTIA_T_size.txt'), 1,[] );
        valores.angu.cenario = reshape( load('ANGUSTIA_CENARIO.txt'), 1,[] );
        valores.angu.intensidade = reshape( load('ANGUSTIA_INTENSIDADE.txt'), 1,[] );
        valores.angu.mantra = reshape( load('ANGUSTIA_MANTRA.txt'), 1,[] );
        
        save('valores');
    end
end

%% Plotar gráficos

main = valores.tern.tmax;
main = (main/max(main)) * 5;
%figure;
%plot(main);
%figure;
%plot(valores.cansaco);
clc;
fprintf('## CORRELAÇÕES ##\n');
emocoes = {'tern', 'angu'};
dados = {'cenario', 'intensidade', 'mantra'};
for emocao=emocoes
    fprintf( '    %s\n', upper(emocao{1}) );
    for origem = {'tmax', 'tsize'}
        fprintf('%s x CANSAÇO: %.2f\n', upper(origem{1}), corr2( valores.(emocao{1}).(origem{1}), valores.cansaco ));
        fprintf('%s x CONCENTRAÇÃO: %.2f\n', upper(origem{1}), corr2( valores.(emocao{1}).(origem{1}), valores.concentracao ));
        for dado = dados
            fprintf('%s x %s: %.2f\n',...
                upper(origem{1}),...
                upper(dado{1}),...
                corr2( valores.(emocao{1}).(origem{1}), valores.(emocao{1}).(dado{1}) ));
        end
        fprintf('\n');
    end
end

fprintf('## OPOSTOS\n');
fprintf('   TERNURA\n');
fprintf('TMAX T x CENARIO A: %.2f\n', corr2( valores.tern.tmax, valores.angu.cenario ));
fprintf('TMAX T x INTENSIDADE A: %.2f\n', corr2( valores.tern.tmax, valores.angu.intensidade ));
fprintf('TSIZE T x CENARIO A: %.2f\n', corr2( valores.tern.tsize, valores.angu.cenario ));
fprintf('TSIZE T x INTENSIDADE A: %.2f\n\n', corr2( valores.tern.tsize, valores.angu.intensidade ));

fprintf('   ANGUSTIA\n');
fprintf('TMAX A x CENARIO T: %.2f\n', corr2( valores.angu.tmax, valores.tern.cenario ));
fprintf('TMAX A x INTENSIDADE T: %.2f\n', corr2( valores.angu.tmax, valores.tern.intensidade ));
fprintf('TSIZE A x CENARIO T: %.2f\n', corr2( valores.angu.tsize, valores.tern.cenario ));
fprintf('TSIZE A x INTENSIDADE T: %.2f\n', corr2( valores.angu.tsize, valores.tern.intensidade ));
