function distance = calc_distance(point1, point2, homography) 


projected2 = (homography * point1')';

projected2 = projected2 / projected2(end);

diff = projected2 - point1;

distance = sqrt(sum(diff.^2));
