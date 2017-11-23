function homography = estimate_from_inliers(inliers1, inliers2, starting_H) 

options.Algorithm = 'levenberg-marquardt';
options.MaxFunctionEvaluations = 1e4;

loss_fun = @(H)calc_distances(inliers1, inliers2, H);
homography = lsqnonlin(loss_fun, double(starting_H), [], [], options);



