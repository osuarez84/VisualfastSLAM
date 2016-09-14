function particle = add_feature(particle, znr, N)
% add new features
lenz = size(znr.x,2);
xf = zeros(2,lenz);
Pf = zeros(2,2,lenz);
xv = particle.xv;
theta = xv(3);

Rt = [  cos(theta) -sin(theta);
        sin(theta) cos(theta)];

for i = 1:lenz
    xf(:,i) = Rt * [znr.x(i); znr.y(i)] + [xv(1); xv(2)];
    
    % Computamos innovation covariance
    G = [  cos(theta), -sin(theta);
        sin(theta), cos(theta)];
    
    Pf(:,:,i) = G' * inv(N) * G;
end

lenx = size(particle.xf,2);
ii = (lenx+1):(lenx+lenz);
particle.xf(:,ii) = xf;
particle.Pf(:,:,ii) = Pf;

















end