function F = LM_estimate_F(F0, points1, points2) 
% Matlab's non-linear estimation, wrapped in my own function for easyness

options.Algorithm = 'levenberg-marquardt';
error_fun = @(F)calculate_errors(F, points1, points2);

F = lsqnonlin(error_fun, F0, [], [], options);


