function s = multivariate_gauss(x, P, n)
% Randome sample from multivariate Gaussian distribution

len = length(x);
S = chol(P)';
X = randn(len,n);
s = S*X + x*ones(1,n);
end