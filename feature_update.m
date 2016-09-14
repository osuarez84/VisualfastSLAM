function particle = feature_update(particle, zfr, idf, N)
xf = particle.xf(:,idf);
Pf = particle.Pf(:,:,idf);
xv = particle.xv;

% Calculamos zp
for i = 1:length(idf)
    x = xf(1,i);
    y = xf(1,i);
    theta = xv(3);
    
    Rt = [cos(theta) -sin(theta);
        sin(theta) cos(theta)];
    
    zp(:,i) = Rt' * [ (zfr.x(i) - xv(1)); (zfr.y(i) - xv(2))];
    G = [  cos(theta), -sin(theta);
        sin(theta), cos(theta)];
    Z(:,:,i) = G * Pf(:,:,i) * G' + N;
end

z = [zfr.x(1,:); zfr.y(1,:)];

% Calculamos innovación
v = z - zp;


% Hacemos la actualización del KF utilizando cholesky
for i = 1:length(idf)
    vi = v(:,i);
    Pfi = Pf(:,:,i);
    xfi = xf(:,i);
    
    [xf(:,i), Pf(:,:,i)] = KF_cholesky_update(xfi, Pfi, vi, N, G);
end
    
particle.xf(:,idf) = xf;
particle.Pf(:,:,idf) = Pf;






end