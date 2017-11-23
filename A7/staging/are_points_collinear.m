function collinear = are_points_collinear(points)

tolerance = 1e-14;

collinear = true;

collinear = rank(points', tolerance) < 2;

