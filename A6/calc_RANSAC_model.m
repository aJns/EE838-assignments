% This function calculates the model using the vanilla RANSAC algorithm.
% It should be quite self explanatory.

function best_model = calc_RANSAC_model(test_data, sample_size, no_outlier_prob, inlier_th, inlier_ratio)

best_model = zeros(sample_size, 1);
best_count = 0;
% calculate the amount of iterations to run the algorithm
nb_iterations = log(1-no_outlier_prob)/log(1-inlier_ratio^sample_size);
for k=1:nb_iterations
    % randomly select sample_size amount of points from the test data
    line_index = randi([1 size(test_data, 1)], sample_size, 1);
    x = test_data(line_index, 1);
    y = test_data(line_index, 2);

    % get a model from the samples
    model = approx_model(x, y);

    threshold = inlier_th;
    current_count = count_inliers(test_data, model, threshold);

    % if the current inlier count is better than the best recorded count, set
    % this result as the best one
    if current_count > best_count
        best_count = current_count;
        best_model = model;
    end
end
