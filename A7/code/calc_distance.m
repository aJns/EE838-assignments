function distance = calc_distance(point1, point2, homography) 

projected2 = (homography*point1);
projected1 = (homography^(-1)*point2);

d_point1_to_projected1 = pdist2(point1', projected1');
d_point2_to_projected2 = pdist2(point2', projected2');

distance = d_point1_to_projected1 + d_point2_to_projected2;
