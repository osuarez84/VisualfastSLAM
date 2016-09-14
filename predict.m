function particle = predict(particle, V, G, Q, dt)
% En esta función robamos las particulas de nuestra distribución del motion
% model.

% add random noise to controls
VG = multivariate_gauss([V;G], Q, 1);
V = VG(1);
G = VG(2);

% TODO: cambiar el modelo del robot y proponer el que sale en el paper.
% Habría que incluir la matriz de rotación R:
angle = pi_to_pi(particle.xv(3));
R = [   cos(angle), -sin(angle);
        sin(angle), cos(angle)];

A = R * [V*dt*cos(G*dt); V*dt*sin(G*dt)];
xv = particle.xv;
particle.xv = [   xv(1) + A(1);
                  xv(2) + A(2);
                  pi_to_pi(xv(3) + G*dt)];
particle.R = R;

% xv = particle.xv;
% particle.xv = [ xv(1) + V*dt*cos(G+xv(3,:));
%                 xv(2) + V*dt*sin(G+xv(3,:));
%                 pi_to_pi(xv(3) + V*dt*sin(G)/WB)];

end