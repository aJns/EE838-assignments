% This function calculates the model using the MSAC algorithm. Otherwise the same as normal RANSAC,
% but the score is the distance of the inliers, not just their count.

function best_model = calc_MSAC_model(test_data, sample_size, no_outlier_prob, inlier_th, inlier_ratio)

best_model = zeros(sample_size, 1);
best_score = 0;
nb_iterations = log(1-no_outlier_prob)/log(1-inlier_ratio^sample_size);
for k=1:nb_iterations
    line_index = randi([1 size(test_data, 1)], sample_size, 1);
    x = test_data(line_index, 1);
    y = test_data(line_index, 2);

    model = approx_model(x, y);

    threshold = inlier_th;
    current_score = calc_msac_score(test_data, model, threshold);

    if current_score > best_score
        best_score = current_score;
        best_model = model;
    end
end
