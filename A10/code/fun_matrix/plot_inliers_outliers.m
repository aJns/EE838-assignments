function plot_inliers_outliers(I1, I2, inliers, outliers)
% inliers/outliers expected to be in form 4xN, where the rows 1:2 are for
% the points in I1, and the rows 3:4 for I2

imshow(cat(2, I1, I2));
