function [points1_hat, T1, points2_hat, T2] = normalize_for_DLT(points1, points2)

[points1_hat, T1] = normalize_points(points1);
[points2_hat, T2] = normalize_points(points2);

