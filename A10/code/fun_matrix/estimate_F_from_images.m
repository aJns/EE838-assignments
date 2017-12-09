function [F, inliers, outliers] = estimate_F_from_images(I1, I2) 

[matched_points1, matched_points2] = get_matched_pts(I1, I2);

[ransac_F, ransac_inliers] = estimate_RANSAC_F(matched_points1, matched_points2);

% Non-linear estimation from all inliers
F = LM_estimate_F(ransac_F, matched_points1(:, ransac_inliers), matched_points2(:, ransac_inliers));
F = F/F(3,3);

inliers = [matched_points1(:,ransac_inliers); matched_points2(:,ransac_inliers)];
outliers = [matched_points1(:,~ransac_inliers); matched_points2(:,~ransac_inliers)];
