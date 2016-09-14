function p = initialise_particles(np)
% Funci�n para inicializar todos los par�metros de cada particula

for i = 1:np
    p(i).w = 1/np;
    p(i).xv = [0;0;0];  % state vector
    p(i).xf = [];   % mean for each feature (landmark)
    p(i).Pf = [];   % covariace for each feature (landmark)
    p(i).R = [0, 0; 0, 0];    % Rotation matrix for each particle
end
end