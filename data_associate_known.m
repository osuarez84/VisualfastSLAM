function [zf, zn, flagFF, zHist, idf] = data_associate_known(z, flagFF, zHist, E)
% Función que computa la data association entre landmarks de frames
% consecutivos.
% INPUT
%   z => landmarks observadas y a las que se ha añadido ruido. Llevan
%   incorporados los descriptores.
%   flagFF => flag que nos indica si estamos procesando el primer frame. En
%   ese caso no tenemos histórico de landmarks, por lo que todas las
%   landmarks observadas son nuevas.
% OUTPUT
%   zf => landmarks observadas anteriormente
%   zn => landmarks nunca observadas, NUEVAS.
zf.x = [];
zf.y = [];
zf.d.dL = [];
zf.d.dR = [];

zn.x = [];
zn.y = [];
zn.d.dL = [];
zn.d.dR = [];

idf = [];

zHistT = zHist;

if flagFF
    % Do nothing
    % Inicializamos el histórico de landmarks ya vistas
    zHistT.x = z.x;
    zHistT.y = z.y;
    zHistT.d.dL = z.descriptors.descriptorL;
    zHistT.d.dR = z.descriptors.descriptorR;
    
    zn.x = z.x;
    zn.y = z.y;
    zn.d.dL = z.descriptors.descriptorL;
    zn.d.dR = z.descriptors.descriptorR;
else
    % Calculamos dist Euclidea al cuadrado de cada descriptor en la
    % observación actual y lo comparamos con todas las landmarks del
    % histórico de landmarks. Si está por debajo de un umbral la metemos en
    % posibles candidatos a landmark ya vista. De todos los candidatos
    % cogemos el que minimice esa distancia y damos por bueno el matching,
    % confirmando esa landmark como vista y cuyo índice en el histórico
    % debe de devolverse.
    for i = 1:1:size(z.x,2)
        % Matches entre frame L y nueva z
        for j = 1:1:size(zHistT.x,2)
            cLL = z.descriptors.descriptorL(:,i);   % current landmark
            oLL = zHistT.d.dL(:,j); % old landmark
            dEL = norm(cLL - oLL)^2;
            dHist(j).dL = dEL;
            dHist(j).iL = j;
        end
        
        [minDL, I] = min([dHist.dL]);
        
        if minDL < E % SI, hay matches en imagen L...
            % comprobamos si esa misma landmark en L tiene matches en el
            % frame R
            % TODO: revisar, creo que hay que comprobar solamente las
            % landmarks que corresponden a los índices dHist.iL!!! No
            % todas!
%             for j = 1:1:size(dHist.dL)%j = 1:1:size(zHist.x,2)
%                 cLR = z.descriptors.descriptorR(:,i);
%                 oLR = zHist.d.dR(:,dHist(j).iL);
%                 dER = norm(cLR - oLR)^2;
%                 dHist(j).dR = dER;
%                 dHist(j).iR = j;
%             end

            cLR = z.descriptors.descriptorR(:,i);
            oLR = zHistT.d.dR(:,I);
            dER = norm(cLR - oLR)^2;
            
           % [minDR, I] = min([dHist.dR]);
            if dER < E
                % Aseguramos de que la landmark ha sido observada anteriormente
                % en frame L y R, luego SI que ha sido vista con anterioridad.
                % => A la lista zf
                zf.x = horzcat(zf.x, z.x(:,i));
                zf.y = horzcat(zf.y, z.x(:,i));
                zf.d.dL = horzcat(zf.d.dL, z.descriptors.descriptorL);
                zf.d.dR = horzcat(zf.d.dR, z.descriptors.descriptorR);
                
                % Devolvemos los índices de las landmarks ya vistas en zHist
                % de manera que el índice nos indica què columna es en
                % zHist, que será la misma en la que estará guardada esa
                % landmark en particle.xf
                idf = [idf I];
            else
                % => NUEVA LANDMARK
                % => A la lista zn y al zHist
                zHistT.x = horzcat(zHistT.x, z.x(:,i));
                zHistT.y = horzcat(zHistT.y, z.y(:,i));
                zHistT.d.dL = horzcat(zHistT.d.dL, z.descriptors.descriptorL(:,i));
                zHistT.d.dR = horzcat(zHistT.d.dR, z.descriptors.descriptorR(:,i));
                
                % zn
                zn.x = horzcat(zn.x, z.x(:,i));
                zn.y = horzcat(zn.y, z.y(:,i));
                zn.d.dL = horzcat(zn.d.dL, z.descriptors.descriptorL(:,i));
                zn.d.dR = horzcat(zn.d.dR, z.descriptors.descriptorR(:,i));
            end
            
        else
            % NUEVA LANDMARK
            % => A la lista zn y al zHist
            zHistT.x = horzcat(zHistT.x, z.x(:,i));
            zHistT.y = horzcat(zHistT.y, z.y(:,i));
            zHistT.d.dL = horzcat(zHistT.d.dL, z.descriptors.descriptorL(:,i));
            zHistT.d.dR = horzcat(zHistT.d.dR, z.descriptors.descriptorR(:,i));
            
            % zn
            zn.x = horzcat(zn.x, z.x(:,i));
            zn.y = horzcat(zn.y, z.y(:,i));
            zn.d.dL = horzcat(zn.d.dL, z.descriptors.descriptorL(:,i));
            zn.d.dR = horzcat(zn.d.dR, z.descriptors.descriptorR(:,i));
        end
    end
    
    
    
end
% Guardamos el zHist Temporal en zHist al salir de la función
zHist = zHistT;


% Ya hemos procesado el primer frame, a partir de aquí tenemos histórico de
% landmarks para comprobar si hay nuevas o no.
flagFF = 0;

end