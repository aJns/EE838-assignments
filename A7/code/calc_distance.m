function distance = calc_distance(point1, point2, homography) 

projected1 = (homography'*point1')';
projected2 = (homography'^(-1)*point2')';

distance = pdist2(point2, projected1) + pdist2(point1, projected2);
