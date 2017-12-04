function [inlier_indices, inlier_std] = count_inliers(points1, points2, F, threshold)

n = size(points1, 2);

inlier_indices = zeros(n, 1);
inlier_distances = -ones(n, 1);

for i=1:n
    d = calc_distance(points1(:,i), points2(:,i), F);
    if d < threshold
        inlier_indices(i) = i;
        inlier_distances(i) = d;
    end
end

inlier_indices(inlier_indices==0) = [];
inlier_distances(inlier_distances==-1) = [];

inlier_std = std(inlier_distances);
