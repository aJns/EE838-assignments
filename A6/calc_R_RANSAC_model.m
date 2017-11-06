function best_model = calc_R_RANSAC_model(test_data, sample_size, no_outlier_prob, inlier_th, inlier_ratio)

best_model = zeros(sample_size, 1);
best_count = 0;
nb_iterations = log(1-no_outlier_prob)/log(1-inlier_ratio^sample_size);
for k=1:nb_iterations
    line_index = randi([1 size(test_data, 1)], sample_size, 1);
    x = test_data(line_index, 1);
    y = test_data(line_index, 2);

    model = approx_model(x, y);
    threshold = inlier_th;

    if ~passed_preval(test_data, nb_iterations, model, threshold)
        continue
    end
    current_count = count_inliers(test_data, model, threshold);

    if current_count > best_count
        best_count = current_count;
        best_model = model;
    end
end
