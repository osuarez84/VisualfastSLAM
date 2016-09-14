function z = get_observations(stereoParams)
% Arrancamos cámaras Logitech
lCam = webcam(2);
rCam = webcam(3);

% Tomamos las imágenes
imgL = snapshot(lCam);
imgR = snapshot(rCam);

% Liberamos las cámaras para la próxima vez
clear('lCam');
clear('rCam');

% Rectificamos las imágenes
[J1, J2] = rectifyStereoImages(imgL, imgR, stereoParams);
img1 = J1;
img2 = J2;
figure;
idisp({J1, J2});

% SURF FEATURES
% Sacamos lo features de L y R
s1 = isurf(img1);
s2 = isurf(img2);

% Matches entre features de las imágenes stereo
[m, corresp] = s1.match(s2);
%F = m.ransac(@fmatrix, 1e-4, 'verbose');

s1_1 = s1(corresp(1,:)).uv;
s2_2 = s2(corresp(2,:)).uv;
s1Descriptors = s1(corresp(1,:)).descriptor;    % descriptores en columnas
s2Descriptors = s2(corresp(2,:)).descriptor;

% Obtenemos los índices de los inliers
[F, in, r] = ransac(@fmatrix, [s1_1; s2_2], 1e-4, 'verbose');

s1Inlier = s1_1(:,in);  % inliers de L
s2Inlier = s2_2(:,in);  % inliers de R
s1InDescriptors = s1Descriptors(:,in); % descriptores inliers L
s2InDescriptors = s2Descriptors(:,in); % descriptores inliers R

% Ploteamos inliers
figure;
%subplot(1,2,1);
imshow(img1);
hold on
plot(s1Inlier(1,:),s1Inlier(2,:),'go');


% Devolvemos coordenadas y descriptores
z.x = [s1Inlier(1,:); s2Inlier(1,:)];   % z.x = [xL; xR];
z.y = [s1Inlier(2,:); s2Inlier(2,:)];   % Z.y = [yL; yR] => v
z.descriptors.descriptorL = s1InDescriptors;
z.descriptors.descriptorR = s2InDescriptors;



end