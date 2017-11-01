%% A: RANSAC for line fitting
% model: y = ax + b

% generate data
% data domain: -50, 50
% number of points: 200
% inlier thresholds: 0.5, 1, 2, 5
% inlier ratios: 30%, 50%, 70%, 90%

nb_points = 200;
range = [-50, 50];
inlier_th = [0.5, 1, 2, 5, 99];
inlier_ratios = [0.3, 0.5, 0.7, 0.9];

nb_inside_th = nb_points * [inlier_ratios 1];

temp_length = length(nb_inside_th);
for i=0:temp_length - 2
    nb_inside_th(temp_length - i) = nb_inside_th(temp_length - i) - nb_inside_th(temp_length - 1 - i);
end

% line model
a = 1.24;
b = 0.76;

x = (range(2)-range(1))*rand(nb_points, 1) + range(1);

y_variance = [-20, 20];
y = zeros(nb_points, 1);

for i=1:nb_points
    while 1
        y(i) = a*x(i) + b;
        y(i) = y(i) + (y_variance(2)-y_variance(1))*rand(1, 1) + y_variance(1);

        d = abs(a*x(i) - y(i) + b)/sqrt(a^2 + 1^2);

        y_okay = 0;
        for j=1:length(inlier_th)
            if d < inlier_th(j) && nb_inside_th(j) > 0
                nb_inside_th(j) = nb_inside_th(j) - 1;
                y_okay = 1;
                break;
            end
        end
        if y_okay == 1
            break;
        end
    end
end
