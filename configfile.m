% Fichero de configuraci�n para la funci�n fastSLAM_OMAR.m

% Flag para marcar el inicio del primer frame
flagFF = true;

% Threshold para la comparaci�n de a distancia Euclidea de los descriptores
E = 0.08;

% Par�metros para la ejecuci�n del fastSLAM
NPARTICLES = 100;
NEFFECTIVE = 0.75*NPARTICLES;


% Par�metros de las c�maras
% Valores de par�metros dados a mano CAMBIAR
% OJO: ajustar para las c�maras Logitech!!
% Distancias expresadas en mm
b = 78.7803;
f = 2.3;
PX = 306.7550;
PY = 252.1248;


% CONTROL NOISES (Odometry)
% Estos par�metros deben de calcularse por experimentaci�n.
alfa1 = 0.1;
alfa2 = 0.2;
alfa3 = 0.01;
alfa4 = 0.01;
pM = [alfa1, alfa2, alfa3, alfa4]';

% OBSERVATION NOISES
% Estos par�metros deben de calcularse por experimentaci�n
sigmaXL = 0;
sigmaXR = 0;

N = [   sigmaXL^2, 0;
        0, sigmaXR^2];
    
    
    
    
    
    