% B: RANSAC for circle fitting
% model: (x-a)^2 + (y-b)^2 = r^2

%% generate data
% data domain: -50, 50
% number of points: 200
% inlier thresholds: 0.5, 1, 2, 5
% inlier ratios: 30%, 50%, 70%, 90%

nb_points = 200;
range = [-50, 50];
inlier_th = [0.5, 1, 2, 5];
inlier_ratios = [0.3, 0.5, 0.7, 0.9];

% circle model
a = 0;
b = 0;
r = 15;
circle_model = [a b r];

test_data = gen_data_sets(nb_points, range, inlier_th, inlier_ratios, circle_model);

clearvars a b r


%% Estimate model with RANSAC

% variables
% probability that at least one sample has no outliers: 99.9%
% s = sample size, 3 because a circle can be modeled with 3 points
no_outlier_prob = 0.999;
sample_size = 3;

mi = 1;
a_best = zeros(length(inlier_th), length(inlier_ratios), 3);
b_best = zeros(length(inlier_th), length(inlier_ratios), 3);
r_best = zeros(length(inlier_th), length(inlier_ratios), 3);

for i=1:length(inlier_th)
    for j=1:length(inlier_ratios)
        best_count = 0;
        nb_iterations = log(1-no_outlier_prob)/log(1-inlier_ratios(j)^sample_size);
        for k=1:nb_iterations
            line_index = randi([1 size(test_data, 1)], sample_size, 1);
            x = test_data(line_index, 1, i, j);
            y = test_data(line_index, 2, i, j);

            model = approx_model(x, y);

            threshold = inlier_th(i);
            current_count = count_inliers(test_data(:,:,i,j), model, threshold);

            if current_count > best_count
                best_count = current_count;
                a_best(i, j, mi) = model(1);
                b_best(i, j, mi) = model(2);
                r_best(i, j, mi) = model(3);
            end
        end
    end
end


%% R-RANSAC

mi = 2;
for i=1:length(inlier_th)
    for j=1:length(inlier_ratios)
        best_count = 0;
        nb_iterations = log(1-no_outlier_prob)/log(1-inlier_ratios(j)^sample_size);
        for k=1:nb_iterations
            line_index = randi([1 size(test_data, 1)], sample_size, 1);
            x = test_data(line_index, 1, i, j);
            y = test_data(line_index, 2, i, j);

            model = approx_model(x, y);
            threshold = inlier_th(i);

            if ~passed_preval(test_data(:,:,i,j), nb_iterations, model, threshold)
                continue
            end

            current_count = count_inliers(test_data(:,:,i,j), model, threshold);

            if current_count > best_count
                best_count = current_count;
                a_best(i, j, mi) = model(1);
                b_best(i, j, mi) = model(2);
                r_best(i, j, mi) = model(3);
            end
        end
    end
end


%% MSAC

mi=3;

for i=1:length(inlier_th)
    for j=1:length(inlier_ratios)
        best_count = 0;
        nb_iterations = log(1-no_outlier_prob)/log(1-inlier_ratios(j)^sample_size);
        for k=1:nb_iterations
            line_index = randi([1 size(test_data, 1)], sample_size, 1);
            x = test_data(line_index, 1, i, j);
            y = test_data(line_index, 2, i, j);

            model = approx_model(x, y);

            threshold = inlier_th(i);
            current_score = calc_msac_score(test_data(:,:,i,j), model, threshold);

            if current_count > best_count
                best_count = current_count;
                a_best(i, j, mi) = model(1);
                b_best(i, j, mi) = model(2);
                r_best(i, j, mi) = model(3);
            end
        end
    end
end


%% plotting the resulting line approximations
close all;

nb_th = length(inlier_th);
nb_rt = length(inlier_ratios);

for mi=1:3
    figure;
    counter = 1;
    for i=1:nb_th
        for j=1:nb_rt

    ang=linspace(0, 2*pi, nb_points);
    x=(r_best(i,j,mi)*cos(ang) + a_best(i,j,mi))';
    y=(r_best(i,j,mi)*sin(ang) + b_best(i,j,mi))';

            subplot(nb_th, nb_rt, counter)
            plot(test_data(:,1,i,j), test_data(:,2,i,j), 'o');
            hold on;
            plot(x, y);
            hold off;
            title([ 'threshold:' num2str(inlier_th(i)) ' ratio:' num2str(inlier_ratios(j)) ]);
            counter = counter + 1;
        end
    end
end



%% Save the mse results to matrix and matrix to csv
% each row has the same threshold
% each column the same ratio of inliers

ground_truth = circle_model;

mse_results = zeros(nb_th, nb_rt, 3);

for mi=1:3
    for i=1:nb_th
        for j=1:nb_rt
            model = [a_best(i, j, mi) b_best(i, j, mi) r_best(i, j, mi)];
            mse_results(i, j, mi) = compare_ground_truth(ground_truth, model);
        end
    end
end

csvwrite('circle_mse_RANSAC.csv', mse_results(:,:,mi));

csvwrite('circle_mse_R-RANSAC.csv', mse_results(:,:,mi));

csvwrite('circle_mse_MSAC.csv', mse_results(:,:,mi));












