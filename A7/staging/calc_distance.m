function distance = calc_distance(point1, point2, homography) 

projected2 = (homography*point1');
projected1 = (homography^(-1)*point2');

% change coordinates to cartesian

c_point1 = point1(1:2)/point1(3);
c_point2 = point2(1:2)/point2(3);
c_projected1 = projected1(1:2)'/projected1(3);
c_projected2 = projected2(1:2)'/projected2(3);

d_point1_to_projected1 = pdist2(c_point1, c_projected1);
d_point2_to_projected2 = pdist2(c_point2, c_projected2);

distance = d_point1_to_projected1 + d_point2_to_projected2;
