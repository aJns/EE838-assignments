function [points_hat, T] = normalize_points(points) 

n = size(points, 1);

x = points(:,1);
y = points(:,2);

x_mean = mean(x);
y_mean = mean(y);

s_numerator   = sqrt(2);
s_denominator = (1/n)*sum(sqrt( (x-x_mean).^2 + (y-y_mean).^2 ));

s = s_numerator/s_denominator;

t_x = -s*x_mean;
t_y = -s*y_mean;

T = [s 0 t_x; 0 s t_y; 0 0 1];
points_hat = (T*points');
