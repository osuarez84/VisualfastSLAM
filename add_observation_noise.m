function z = add_observation_noise(z, N)
% A�adimos ruido a las coordenadas de p�xeles xL y xR
len = size(z,2);
if len > 0
    z.x(1,:) = z.x(1,:) + randn(1,len)*sqrt(N(1,1)); % Ruido a landmarks en L
    z.x(2,:) = z.x(2,:) + randn(1,len)*sqrt(N(2,2)); % Ruido a landmarks en R
    
    % OJO, aqu� no estamos a�adiendo ruido a las coordenadas en y, ya que
    % en principio no las utilizamos para nada.
end


end