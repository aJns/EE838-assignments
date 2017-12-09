function [matched_points1, matched_points2] = get_matched_pts(I1, I2) 

[keypoints1, descriptors1] = vl_sift(I1);
[keypoints2, descriptors2] = vl_sift(I2);

matches = vl_ubcmatch(descriptors1, descriptors2);
match_count = length(matches);
matched_points1 = [keypoints1(1:2, matches(1,:)); ones(1, match_count)];
matched_points2 = [keypoints2(1:2, matches(2,:)); ones(1, match_count)];


