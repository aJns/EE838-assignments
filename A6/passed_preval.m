% This is the pre-evaluation function for R-RANSAC. It returns true if the
% randomly sampled model is good enough.

function passed = passed_preval(test_data, iterations, model, threshold)

passed = false;
% arbitrary preval sample size
preval_sample_size = 20;
% We have to decide a threshold count of inliers which is good enought to
% evaluate further.  My solution is to have it be an exponentially growing
% function between [0.00, 0.15]. Better solutions are surely available.
preval_inlier_th = min(iterations/(iterations+200), 0.15);

% Randomly select samples to pre-evaluate
preval_index = randi([1 length(test_data)], preval_sample_size, 1);
% Check how many inliers we get
preval_count = count_inliers(test_data(preval_index,:), model, threshold);
% Check their ratio from the overall preval sample size
if (preval_count / preval_sample_size) > preval_inlier_th
    passed = true;
    %disp(['passed preval. th:' num2str(threshold) ' preval th:' num2str(preval_inlier_th)])
end








end
