function A = compute_A(point1, point2) 

x1 = point1(1);
y1 = point1(2);

x2 = point2(1);
y2 = point2(2);

A = zeros(2,9);

A(1,:) = [x1  y1  1  0   0   0  -x2*x1  -x2*y1  -x2];
A(2,:) = [0   0   0  x1  y1  1  -y2*x1  -y2*y1  -y2];
