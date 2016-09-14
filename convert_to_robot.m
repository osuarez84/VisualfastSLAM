function [zfr, znr] = convert_to_robot(zf, zn, N, b, f, px, py)
% Necesitamos computar la jacobiana del measurement model

% Jacobiana del measurement model (linealización)
% W =     [[                      -(b*f)/(xL - xR)^2,          (b*f)/(xL - xR)^2]
%         [ b/(xL - xR) + (b*(px - xL))/(xL - xR)^2, -(b*(px - xL))/(xL - xR)^2]];
% Q = W * N * W';
%
% z = [f*b/(xL-xR); (((xL-px)*b/(xL-xR)) - b/2)] + Q;
zfr = [];
znr = [];


if ~isempty(zf)
    [n, m] = size(zf.x);
    for i = 1:m
        xL = zf.x(1,i);
        xR = zf.x(2,i);
        A = [f*b/(xL - xR); ( ((xL - px)*b / (xL - xR)) - b/2)];
        W =[[                      -(b*f)/(xL - xR)^2,          (b*f)/(xL - xR)^2]
            [ b/(xL - xR) + (b*(px - xL))/(xL - xR)^2, -(b*(px - xL))/(xL - xR)^2]];
        Q = W * N * W';
        
        % TODO: revisar esta operación, ya que la matriz Q que sale no es
        % diagonal!! y no se que hacer con los términos fuera de la diagonal
        % principal!!
        zfr.x(1,i) = A(1) + randn*Q(1,1);
        zfr.y(1,i) = A(2) + randn*Q(2,2);
    end
end

if ~isempty(zn)
    
    [r,c] = size(zn.x);
    
    for i = 1:c
        xL = zn.x(1,i);
        xR = zn.x(2,i);
        A = [f*b/(xL - xR); ( ((xL - px)*b / (xL - xR)) - b/2)];
        W =[[                      -(b*f)/(xL - xR)^2,          (b*f)/(xL - xR)^2]
            [ b/(xL - xR) + (b*(px - xL))/(xL - xR)^2, -(b*(px - xL))/(xL - xR)^2]];
        Q = W * N * W';
        
        % TODO: revisar esta operación, ya que la matriz Q que sale no es
        % diagonal!! y no se que hacer con los términos fuera de la diagonal
        % principal!!
        znr.x(1,i) = A(1) + randn*Q(1,1);
        znr.y(1,i) = A(2) + randn*Q(2,2);
        
        
        
    end
    
    
end
end

% Función para el computo de la Jacobiana para el measurement model
function W = h()
syms f b xL xR px real
x = [xL;xR];    % variables respecto a las que debemos derivar
y = [f*b/(xL-xR); (((xL-px)*b/(xL-xR)) - b/2)]; % matriz sobre la que computar la Jacobiana
W = jacobian(y,x);
end