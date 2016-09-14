function fastSLAM_OMAR(stereoParams)
% Cargamos las variables de configuración
configfile;

% initialisations
particles = initialise_particles(NPARTICLES);

% Valores de odometría de prueba
xLO = [0 0 0]';
xCO = [0 0 0]';

zHist = [];

while (1)

    % Prediction step
    for i = 1:NPARTICLES
        % Vamos cogiendo particulas del motion equation
        % ANNOTATION: para hacer pruebas debemos pasarle inventado xLO y
        % xCO, que son las posiciones en t y t-1 medidas desde odometría.
        particles(i) = sampleMotionOdometry(xLO, xCO, particles(i), pM); % Necesitamos crear un motion equation para un coche
    end
    
    % Observe step
    % TODO: cambiar este intervalo de tiempo por una obtención de una
    % captura del stereo rig conectado al PC.
    z = get_observations(stereoParams);
    
    % Add observation noise
    z = add_observation_noise(z,N);
    
    % Data association
    % Aquí clasificamos las observaciones entre nuevas o no
    % zf => ya vistas anteriormente
    % zn => landmarks nuevas
    [zf, zn, flagFF, zHist, idf] = data_associate_known(z, flagFF, zHist, E);
    
    [zfr, znr] = convert_to_robot(zf, zn, N, b, f, PX, PY); % Finalmente obtenemos la observación z =  [xr; yr]
    %[zfw, znw] = convert_to_global(zf, zn);
    
    
    for i = 1:NPARTICLES
        if ~isempty(zfr) % observe map features, refresh...
            w = compute_weight(particles(i), zfr, idf, N);
            particles(i).w = particles(i).w * w;
            particles(i) = feature_update(particles(i), zfr, idf, N);     % EKF para cada landmark
        end
        
        if ~isempty(znr)
            particles(i) = add_feature(particles(i), znr, N);
        end
    end
    
    particles = resample_particles(particles, NEFFECTIVE);
    
    % TESTING
    figure;
    scatter(particles(1).xf(2,:), particles(1).xf(1,:));
    hold on;
    plot(0,0,'r*'); % Posición del robot, que no se mueve
    p = make_covariance_ellipses(particles(i));
    plot(p(2,:), p(1,:),'g');

end


%% ANNOTATIONS
% TODO:
%   => Revisar la predicción de partículas, utilizar la función
%   sampleMotionOdometry(). Tenemos que pasarle datos falsos de posición de
%   odometría para hacer pruebas.
%   => Revisar get_observations, necesito sacar frames de las cámaras
%   => Revisar función convert_to_robot
%   => Crear función convert_to_global
%   => Crear función compute_weight
%   => Crear función feature_update
%   => Crear función add_feature
%   => Crear función resample_particles

function p= initialise_particles(np)
for i=1:np
    p(i).w= 1/np;
    p(i).xv= [0;0;0];
    p(i).xf= [];
    p(i).Pf= [];
end

function p= make_covariance_ellipses(particle)
% part of plotting routines
p= [];
lenf= size(particle.xf,2);

if lenf > 0
    N= 10;
    inc= 2*pi/N;
    phi= 0:inc:2*pi;
    circ= 2*[cos(phi); sin(phi)];
    
    xf= particle.xf;
    Pf= particle.Pf;
    p= zeros (2, lenf*(N+2));

    ctr= 1;
    for i=1:lenf
        ii= ctr:(ctr+N+1);
        p(:,ii)= make_ellipse(xf(:,i), Pf(:,:,i), circ);
        ctr= ctr+N+2;
    end
end

function p= make_ellipse(x,P,circ)
% make a single 2-D ellipse 
r= sqrtm_2by2(P);
a= r*circ;
p(2,:)= [a(2,:)+x(2) NaN];
p(1,:)= [a(1,:)+x(1) NaN];





