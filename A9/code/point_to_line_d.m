function d = point_to_line_d(a, b, c, x, y)

d = abs(a*x + b*y + c) / sqrt(a^2 + b^2);


