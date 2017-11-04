% B: RANSAC for circle fitting
% model: (x-a)^2 + (y-b)^2 = r^2

%% generate data
% data domain: -50, 50
% number of points: 200
% inlier thresholds: 0.5, 1, 2, 5
% inlier ratios: 30%, 50%, 70%, 90%

nb_points = 200;
range = [-50, 50];
inlier_th = [0.5, 1, 2, 5, 99];
inlier_ratios = [0.3, 0.5, 0.7, 0.9];

% circle model
a = 0;
b = 0;
r = 15;
circle_model = [a b r];

test_data = generate_data(nb_points, range, inlier_th, inlier_ratios, circle_model);

clearvars a b r


%% Estimate model with RANSAC

% variables
% probability that at least one sample has no outliers: 99.9%
% s = sample size, 3 because a line can be modeled with 3 points
no_outlier_prob = 0.999;
sample_size = 3;
nb_iterations = log(1-no_outlier_prob)./log(1-inlier_ratios.^sample_size);

% Because we have 4 thresholds, and 4 ratios, I assume we are going to estimate
% the line 4 times.

est_count = length(nb_iterations);

a_best = zeros(est_count, 1);
b_best = zeros(est_count, 1);
r_best = zeros(est_count, 1);

for i=1:est_count
    best_count = 0;
    for j=1:nb_iterations(i)
        line_index = randi([1 200], sample_size, 1);
        x = test_data(line_index, 1);
        y = test_data(line_index, 2);

        m12 = (y(2) - y(1))/(x(2) - x(1));
        m23 = (y(3) - y(2))/(x(3) - x(2));

        x12 = (x(1) + x(2))/2;
        y12 = (y(1) + y(2))/2;

        x23 = (x(2) + x(3))/2;
        y23 = (y(2) + y(3))/2;

        a = ( m12*m23*(y23-y12)+m12*x23-m23*x12 ) / ( m12-m23 );
        b = (-1/m12)*(a-x12)-y12;
        r = sqrt( (x(1)-a)^2 + (y(1)-b)^2 );

        threshold = inlier_th(i);
        current_count = 0;

        clearvars x y

        for k=1:length(test_data)
            x = test_data(k,1);
            y = test_data(k,2);
            d = abs(sqrt( (x-a)^2  + (y-b)^2 ) -r );
            if d < threshold
                current_count = current_count + 1;
            end
        end

        if current_count > best_count
            best_count = current_count;
            a_best(i) = a;
            b_best(i) = b;
            r_best(i) = r;
        end
    end
end



%% plotting the resulting line approximations


ang=linspace(0, 2*pi, nb_points);
x=r_best(1)*cos(ang) + a_best(1);
y=r_best(1)*sin(ang) + b_best(1);

close all;
figure;

plot(test_data(:,1), test_data(:,2), 'o');
hold on;
plot(x, y);
hold off;















