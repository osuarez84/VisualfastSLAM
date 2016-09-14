function [V,G] = add_control_noise(V, G, Q)
% Add random noise to nominal control values
C = multivariate_gauss([V;G],Q,1);
V = C(1);
G = C(2);


end