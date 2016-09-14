function m = get_landmarks(z, xt, yt, R)
% Sacamos posición x-y del robot del vector de estado 

% Obtenemos las landmarks en world coordinates que podemos utilizar para
% añadirlas o no al mapa.
[n, m] = size(z,2);

for i = 1:m
    xr = z(1,i);
    yr = z(2,i);
    m(:,i) = R * [xr; yr] + [xt; yt];
end

end