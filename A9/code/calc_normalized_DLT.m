function F = calc_normalized_DLT(points1, points2) 

% [points1_hat, T1, points2_hat, T2] = normalize_for_DLT(points1, points2);

F = F_from_DLT(points1, points2);

% homography = T2^(-1)*homography_hat*T1;
