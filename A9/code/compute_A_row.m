function A_row = compute_A_row(point1, point2) 

x1 = point1(1);
y1 = point1(2);

x2 = point2(1);
y2 = point2(2);

A_row = [x2*x1, x2*y1, x2, y2*x1, y2*y1, y2, x1, y1, 1];
