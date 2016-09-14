function zh = get_observation_model(R, xv, m)
% Obtenemos la función h()
xt = xv(1);
yt = xv(2);

zh = R * (m - [xt; yt]); 



end