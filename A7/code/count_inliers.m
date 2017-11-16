function [inlier_indices, inlier_std] = count_inliers(points1, points2, homography, threshold)

inlier_indices = zeros(1, length(points1));
inlier_distances = -ones(1, length(points1));

for i=1:length(points1)
    d = calc_distance(points1(:,i), points2(:,i), homography);
    if d < threshold
        inlier_indices(i) = i;
        inlier_distances(i) = d;
    end
end

inlier_indices(inlier_indices==0) = [];
inlier_distances(inlier_distances==-1) = [];

inlier_std = std(inlier_distances);
