function nb_inliers = count_inliers(test_data, model, threshold)

current_count = 0;
for k=1:length(test_data)
    d = calc_error(test_data(k,:), model);
    if d < threshold
        current_count = current_count + 1;
    end
end
nb_inliers = current_count;

