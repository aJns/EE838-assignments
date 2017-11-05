function passed = passed_preval(test_data, iterations, model, threshold)

passed = false;
preval_sample_size = 20;
preval_inlier_th = min(iterations/(iterations+200), 0.15);

preval_index = randi([1 length(test_data)], preval_sample_size, 1);
preval_count = count_inliers(test_data(preval_index,:), model, threshold);
if (preval_count / preval_sample_size) > preval_inlier_th
    passed = true;
    disp(['passed preval. th:' num2str(threshold) ' preval th:' num2str(preval_inlier_th)])
end








end
