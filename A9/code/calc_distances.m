function distances = calc_distances(points1, points2, F)

N = size(points1, 1);
distances = zeros(N,1);

for i=1:N
    distances(i) = calc_distance(points1(i,:), points2(i,:), F);
end


