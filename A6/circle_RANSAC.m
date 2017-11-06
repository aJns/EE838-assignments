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
best_model = zeros(sample_size, length(inlier_th), length(inlier_ratios), 3);

for i=1:length(inlier_th)
    for j=1:length(inlier_ratios)
        best_model(:, i, j, mi) = calc_RANSAC_model(test_data(:,:,i,j), sample_size, no_outlier_prob, inlier_th(i), inlier_ratios(j));
    end
end


%% R-RANSAC

mi = 2;
for i=1:length(inlier_th)
    for j=1:length(inlier_ratios)
        best_model(:, i, j, mi) = calc_R_RANSAC_model(test_data(:,:,i,j), sample_size, no_outlier_prob, inlier_th(i), inlier_ratios(j));
    end
end


%% MSAC

mi=3;

for i=1:length(inlier_th)
    for j=1:length(inlier_ratios)
        best_model(:, i, j, mi) = calc_MSAC_model(test_data(:,:,i,j), sample_size, no_outlier_prob, inlier_th(i), inlier_ratios(j));
    end
end



%% Save the mse results to matrix and matrix to csv
% each row has the same threshold
% each column the same ratio of inliers

ground_truth = circle_model;

nb_th = length(inlier_th);
nb_rt = length(inlier_ratios);

mse_results = zeros(nb_th, nb_rt, 3);

for mi=1:3
    for i=1:nb_th
        for j=1:nb_rt
            model = best_model(:,i,j,mi);
            mse_results(i, j, mi) = compare_ground_truth(ground_truth, model);
        end
    end
end

csvwrite('circle_mse_RANSAC.csv', mse_results(:,:,mi));

csvwrite('circle_mse_R-RANSAC.csv', mse_results(:,:,mi));

csvwrite('circle_mse_MSAC.csv', mse_results(:,:,mi));


%% plotting the resulting line approximations
close all;

for mi=1:3
    figure;
    counter = 1;
    for i=1:nb_th
        for j=1:nb_rt

            a = best_model(1, i, j, mi);
            b = best_model(2, i, j, mi);
            r = best_model(3, i, j, mi);

            ang=linspace(0, 2*pi, nb_points);
            x=r*cos(ang) + a;
            y=r*sin(ang) + b;

            subplot(nb_th, nb_rt, counter)
            plot(test_data(:,1,i,j), test_data(:,2,i,j), 'o');
            hold on;
            plot(x', y');
            hold off;
            title([ 'threshold:' num2str(inlier_th(i)) ' ratio:' num2str(inlier_ratios(j)) ' mse:' num2str(mse_results(i,j,mi)) ]);
            counter = counter + 1;
        end
    end
end












