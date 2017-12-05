function indices = close_enough_points(line, points, dist_t) 

n = length(points);
indices = false(n, 1);

for i=1:n
    d = point_to_line_d(line(1), line(2), line(3), points(1,i), points(2,i));
    if d < dist_t
        indices(i) = true;
    end
end

temp = 1:n;
indices = temp(indices);

