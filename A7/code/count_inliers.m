function nb_inliers = count_inliers(points1, points2, homography, threshold)

nb_inliers = 0;
for i=1:length(points1)
    d = calc_distance(points1(i,:), points2(i,:), homography);
    if d < threshold
        nb_inliers = nb_inliers + 1;
    end
end

