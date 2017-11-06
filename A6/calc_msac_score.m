% This function is used in the MSAC algorithm to get the distance of inliers,
% not just their count.
% Outliers have a zero score, inliers a score from 0 to 1. 0 at the edge of the
% threshold, 1 on the line.
% I've done it this way to make it easier to swap out with the other
% algorithms, which view a higher count of inliers as better.

function score = calc_msac_score(test_data, model, threshold)

score = 0;
for k=1:length(test_data)
    d = calc_error(test_data(k,:), model);
    if d < threshold
        score = score + (1 - d/threshold);
    end
end

