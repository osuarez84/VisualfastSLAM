%% Data association
% Expected observation
% xv = [x y theta], vehicle state
% xf = [xr yr], landmark state
% z => observación
Rt = [cos(theta) -sin(theta);
      sin(theta) cos(theta)];
  
lm = Rt*[xr; yr] + [xt; yt];
zp = R'*[lm(1)-xt; lm(2)-yt];

% Compute jacobian
G = [   cos(theta) sin(theta);
        -sin(theta) cos(theta)];
    
% Observation uncertainty    
Z = G*Pf*G' + Q;

% for each observed landmark (z)
p = 1/(sqrt(abs(2*pi*Z)))*exp(-0.5*(z - zp)'*inv(Z)*(z - zp));

% Se trata de calcular la probabilidad de que cada landmark 
for i = 1:Nf    % cada landmark de la particula m...
    lm = Rt*[xr; yr] + [xt; yt];
    zp = Rt'*[lm(1)-xt; lm(2)-yt];
    
    G = [   cos(theta) sin(theta);
        -sin(theta) cos(theta)];
    Z = G*Pf*G' + Q;
    
    for j = 1:length(z) % para cada landmark observada...
        p(i,j) = 1/(sqrt(abs(2*pi*Z)))*exp((-0.5*(z(j) - zp)'*inv(Z)...
            *(z(j) - zp)));