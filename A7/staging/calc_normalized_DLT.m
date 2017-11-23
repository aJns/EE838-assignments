function homography = calc_normalized_DLT(points1, points2) 

[points1_hat, T1, points2_hat, T2] = normalize_for_DLT(points1, points2);

homography_hat = homography_from_DLT(points1_hat, points2_hat);

homography = T2^(-1)*homography_hat*T1;
