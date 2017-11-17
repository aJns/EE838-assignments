function distances = calc_distances(points1, points2, homography) 

%homography = reshape(homography_vector, 3, 3);

N = size(points1, 2);
distances = zeros(1, N);

for i=1:N
    distances(1,i) = calc_distance(points1(:,i), points2(:,i), homography);
end


