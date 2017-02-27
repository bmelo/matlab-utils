%mostra sinais com referencia em cz


sinal = AbreSinalPEB_placa();

cz = -sinal.ARQdig(18,:);
sinal.ARQdig = sinal.ARQdig + repmat(cz,size(sinal.ARQdig,1),1);
