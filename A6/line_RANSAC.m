%A: RANSAC for line fitting
% model: y = ax + b

%% generate data
% data domain: -50, 50
% number of points: 200
% inlier thresholds: 0.5, 1, 2, 5
% inlier ratios: 30%, 50%, 70%, 90%

nb_points = 200;
range = [-50, 50];
inlier_th = [0.5, 1, 2, 5, 99];
inlier_ratios = [0.3, 0.5, 0.7, 0.9];

% line model
a = 1.24;
b = 0.76;
line_model = [a b];

test_data = generate_data(nb_points, range, inlier_th, inlier_ratios, line_model);

clearvars a b


%% Estimate model with RANSAC

% variables
% probability that at least one sample has no outliers: 9.99%
% s = sample size, 2 because a line can be modeled with 2 points
no_outlier_prob = 0.999;
sample_size = 2;
nb_iterations = log(1-no_outlier_prob)./log(1-inlier_ratios.^sample_size);

% Because we have 4 thresholds, and 4 ratios, I assume we are going to estimate
% the line 4 times.

a_best = zeros(4, 1);
b_best = zeros(4, 1);

for i=1:length(nb_iterations)
    best_count = 0;
    for j=1:nb_iterations(i)
        line_index = randi([1 200], 2, 1);
        x = test_data(line_index, 1);
        y = test_data(line_index, 2);

        a = (y(2)-y(1))/(x(2)-x(1));
        b = y(1)-x(1)*( (y(2)-y(1)) / (x(2)-x(1)) );

        threshold = inlier_th(i);
        current_count = 0;

        clearvars x y

        for k=1:length(test_data)
            x = test_data(k,1);
            y = test_data(k,2);
            d = abs(a*x - y + b)/sqrt(a^2 + 1^2);
            if d < threshold
                current_count = current_count + 1;
            end
        end

        if current_count > best_count
            best_count = current_count;
            a_best(i) = a;
            b_best(i) = b;
        end
    end
end



%% plotting the resulting line approximations

x = linspace(-50, 50);
y = a_best*x + b_best;

close all;
figure;

plot(test_data(:,1), test_data(:,2), 'o');
hold on;
plot(x, y, '--');
hold off;















