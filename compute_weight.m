function w = compute_weight(particle, zfr, idf, N)
% Funci�n para computar el peso asignado a la part�cula en funci�n de la
% innovaci�n, es decir, en funci�n de si lo observado es similar a lo que
% se esperaba observar seg�n la pose del robot.
% INPUT


% OUTPUT


% Matriz de rotaci�n R para la pose del robot es
xv = particle.xv;
xf = particle.xf(:,idf);
Pf = particle.Pf(:,:,idf);

for i = 1:length(idf)
    x = xf(1,i);
    y = xf(1,i);
    theta = xv(3); 
    
    Rt = [cos(theta) -sin(theta);
        sin(theta) cos(theta)];
    
    % Calculamos la predicted observation z^ (wrt robot)
    % TODO: revisar si utilizamos zfw o zfr
    zp(:,i) = Rt' * [ (zfr.x(i) - xv(1)); (zfr.y(i) - xv(2))];
    
    % Computamos innovation covariance (Z)
    G = [  cos(theta), -sin(theta);
        sin(theta), cos(theta)];
    Z(:,:,i) = G * Pf(:,:,i) * G' + N;
end
z = [zfr.x(1,:); zfr.y(1,:)];

% Innovaci�n
v = z - zp;


w = 1;
% Calculamos el peso para cada observaci�n (landmark) hecha
for i = 1:size(z,2)
    Zf = Z(:,:,i);
    den = 2*pi*sqrt(det(Zf));
    num = exp(-0.5 * v(:,i)' * inv(Zf) * v(:,i));
    w = w * num/den;
end






end

function zp_jacobian()
syms theta xw yw xt yt real
x = [xw; yw];
y = [cos(theta) -sin(theta); sin(theta) cos(theta)] * [xw - xt; yw - yt];
Hf = jacobian(y,x);

end