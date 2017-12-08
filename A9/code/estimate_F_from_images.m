function F = estimate_F_from_images(I1, I2) 

[keypoints1, descriptors1] = vl_sift(I1);
[keypoints2, descriptors2] = vl_sift(I2);

matches = vl_ubcmatch(descriptors1, descriptors2);
match_count = length(matches);
matched_points1 = [keypoints1(1:2, matches(1,:)); ones(1, match_count)];
matched_points2 = [keypoints2(1:2, matches(2,:)); ones(1, match_count)];

[ransac_F, ransac_inliers] = estimate_RANSAC_F(matched_points1, matched_points2);

% Non-linear estimation from all inliers
F = LM_estimate_F(ransac_F, matched_points1(:, ransac_inliers), matched_points2(:, ransac_inliers));

% guided matching
