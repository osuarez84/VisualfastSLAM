function z = add_observation_noise(z, N)
% Añadimos ruido a las coordenadas de píxeles xL y xR
len = size(z,2);
if len > 0
    z.x(1,:) = z.x(1,:) + randn(1,len)*sqrt(N(1,1)); % Ruido a landmarks en L
    z.x(2,:) = z.x(2,:) + randn(1,len)*sqrt(N(2,2)); % Ruido a landmarks en R
    
    % OJO, aquí no estamos añadiendo ruido a las coordenadas en y, ya que
    % en principio no las utilizamos para nada.
end


end