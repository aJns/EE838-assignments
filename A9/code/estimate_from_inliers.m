function fundamental_matrix = estimate_from_inliers(inliers1, inliers2, starting_F) 

options.Algorithm = 'levenberg-marquardt';
options.MaxFunctionEvaluations = 1e4;
options.StepTolerance = 1e-12;

loss_fun = @(F)calc_distances(inliers1, inliers2, F);
fundamental_matrix = lsqnonlin(loss_fun, double(starting_F), [], [], options);



