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
% s = sample size, 3 because a circle can be modeled with 3 points
no_outlier_prob = 0.999;
sample_size = 3;
nb_iterations = log(1-no_outlier_prob)./log(1-inlier_ratios.^sample_size);

% Because we have 4 thresholds, and 4 ratios, I assume we are going to estimate
% the line 4 times.

est_count = length(nb_iterations);

a_best = zeros(est_count, 3);
b_best = zeros(est_count, 3);
r_best = zeros(est_count, 3);

mi = 1;
for i=1:est_count
    best_count = 0;
    for j=1:nb_iterations(i)
        line_index = randi([1 length(test_data)], sample_size, 1);
        x = test_data(line_index, 1);
        y = test_data(line_index, 2);

        [a, b, r] = approx_model(x, y);

        threshold = inlier_th(i);
        current_count = count_inliers(test_data, [a b r], threshold);

        if current_count > best_count
            best_count = current_count;
            a_best(i, mi) = a;
            b_best(i, mi) = b;
            r_best(i, mi) = r;
        end
    end
end


%% MSAC

mi = 2;
for i=1:est_count
    best_count = 0;
    preval_inlier_th = min(nb_iterations(i)/(nb_iterations(i)+50), 0.25);
    threshold = inlier_th(i);
    preval_sample_size = 20;

    for j=1:nb_iterations(i)
        circle_index = randi([1 length(test_data)], sample_size, 1);
        x = test_data(circle_index, 1);
        y = test_data(circle_index, 2);

        [a, b, r] = approx_model(x, y);
        
        preval_index = randi([1 length(test_data)], preval_sample_size, 1);
        preval_count = count_inliers(test_data(preval_index,:), [a b r], threshold);
        if (preval_count / preval_sample_size) < preval_inlier_th
            continue
        else
            disp(['Preval passed. Th:' num2str(threshold) ' Inliers:' num2str(preval_count)]);
        end

        current_count = count_inliers(test_data, [a b r], threshold);

        if current_count > best_count
            best_count = current_count;
            a_best(i, mi) = a;
            b_best(i, mi) = b;
            r_best(i, mi) = r;
        end
    end
end


%% plotting the resulting line approximations
close all;

for mi=1:3
    ang=linspace(0, 2*pi, nb_points);
    x=(r_best(:, mi)*cos(ang) + a_best(:, mi))';
    y=(r_best(:, mi)*sin(ang) + b_best(:, mi))';

    figure;

    plot(test_data(:,1), test_data(:,2), 'o');
    hold on;
    plot(x, y);
    hold off;
end














