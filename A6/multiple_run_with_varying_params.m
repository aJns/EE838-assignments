% Running RANSAC multiple times with different amounts of data and varying
% probability on the circle model, to get a good understanding of parameter
% effect on results.

nb_points = linspace(50, 5000, 10);
no_outlier_prob = [0.001, 0.25, 0.50, 0.75, 0.999];
range = [-50, 50];
inlier_th = [0.5, 1, 2, 5];
inlier_ratios = [0.3, 0.5, 0.7, 0.9];
sample_size = 3;

% circle model
a = 0;
b = 0;
r = 15;
circle_model = [a b r];


best_model = zeros(sample_size, length(nb_points), length(no_outlier_prob), length(inlier_th), length(inlier_ratios));

for i=1:length(nb_points)
    test_data = gen_data_sets(nb_points(i), range, inlier_th, inlier_ratios, circle_model);
    for j=1:length(no_outlier_prob)
        for h=1:length(inlier_th)
            for k=1:length(inlier_ratios)
                best_model(:, i, j, h, k) = calc_RANSAC_model(test_data(:,:,h,k), sample_size, no_outlier_prob(j), inlier_th(h), inlier_ratios(k));
            end
        end
    end
end

%% calc MSE

mse_results = zeros(length(nb_points), length(no_outlier_prob), length(inlier_th), length(inlier_ratios));

for i=1:length(nb_points)
    for j=1:length(no_outlier_prob)
        for h=1:length(inlier_th)
            for k=1:length(inlier_ratios)
                mse_results(i,j,h,k) = compare_ground_truth(circle_model, best_model(:, i,j,h,k));
            end
        end
    end
end


figure;
counter = 1;
for i=1:length(nb_points)
    for j=1:length(no_outlier_prob)
        subplot(length(nb_points), length(no_outlier_prob), counter);
        imagesc(squeeze(mse_results(i,j,:,:)));
        counter = counter + 1;
    end
end
