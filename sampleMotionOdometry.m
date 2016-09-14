function x = sampleMotionOdometry(xLastO, xCurrentO, x, paramsMotion)
% Función para computar las partículas en base a un modelo de odometría
% INPUT
%   xLast => estado del robot en t-1 calculado desde la odometría
%       xLast = [x y theta]'
%   xCurrent => estado del robot en t calculado desde la odometría
%       xCurrent = [x y theta]'
%   x => pose de la partícula sobre la que se aplica el algorítmo
%       x = [x y theta]
%   paramsMotion => parámetros del modelo de movimiento:
%       paramsMotion = [alfa1, alfa2, alfa3, alfa4]'
%       (Se deben definir en configfile)
% OUTPUT
%   st => partícula calculada

% Calculamos rot1
dRot1 = atan2((xCurrentO(2) - xLastO(2)), (xCurrentO(1) - xLastO(1)))...
    - xLastO(3);
dRot1 = pi_to_pi(dRot1);

% Calculamos la traslacion
dTrans = sqrt((xCurrentO(1) - xLastO(1))^2 + (xCurrentO(2) - xLastO(2))^2);

% Calculamos rot2
dRot2 = xCurrentO(3) - xLastO(3) - dRot1;
dRot2 = pi_to_pi(dRot2);


% Inyectamos ruido utilizando una función Gaussiana
N1 = paramsMotion(1)*dRot1 + paramsMotion(2)*dTrans;
N2 = paramsMotion(3)*dTrans + paramsMotion(4)*(dRot1+dRot2);
N3 = paramsMotion(1)*dRot2 + paramsMotion(2)*dTrans;

% TODO: hablar con Dictino para saber si este añadido de ruido está bien
% hecho con la función randn
dRot1N = dRot1 - randn(1)*N1;
dTransN = dTrans - randn(1)*N2;
dRot2N = pi_to_pi(dRot2 - randn(1)*N3);

% Se calcula nueva pose generada por el algorítmo
xv = x.xv;

xPrime = xv(1) + dTransN*cos(xv(3) + dRot1N);
yPrime = xv(2) + dTransN*sin(xv(3) + dRot1N);
thetaPrime = pi_to_pi(xv(3) + dRot1N + dRot2N);

x.xv = [xPrime; yPrime; thetaPrime];







end