function F = compute_LM(F0, nb_iter, points1, points2) 

F = F0;
lm_param = 1;         % lambda in the texts
lm_mod = 10;

distances = calc_distances(points1, points2, F);    % residuals, or r

for i=1:nb_iter
    distances = calc_distances(points1, points2, F);
end

% Jacobian functor
calc_J = @(x,h,f)(f(repmat(x,size(x'))+diag(h))-f(repmat(x,size(x'))))./h';
% Your function
f = @(F)calc_distances(points1, points2, F);
% Point at which to estimate it
%x = [1;1];
% Step to take on each dimension (has to be small enough for precision)
h = 1e-5*ones(size(F));
% Compute the jacobian
calc_J(F,h,f)

