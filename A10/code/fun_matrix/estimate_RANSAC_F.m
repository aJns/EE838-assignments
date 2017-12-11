function [F, inlier_indices] = estimate_RANSAC_F(matched_points1, matched_points2) 
% matched_points are expected to be of shape 3xN

match_count = length(matched_points1);

% set RANSAC params
dist_thresh = 10;
iter_count = 1000;
sample_size = 7;

best_F = eye(3);
best_inliers = 0;

for i=1:iter_count
    % get random point indices
    indices = randperm(match_count, sample_size);

    % get F candidate(s)
    curr_F = compute_7p_F(matched_points1(:,indices), matched_points2(:,indices));

    % check all candidates
    n = size(curr_F, 3);
    for j=1:n
        errors = calculate_errors(curr_F(:,:,j), matched_points1, matched_points2);
    
        % get inlier indices
        curr_inliers = errors <= dist_thresh;
        
        if sum(curr_inliers) > sum(best_inliers)
            best_inliers = curr_inliers;
            best_F = curr_F(:,:,j);
            disp(['Max inlier count: ' num2str(sum(best_inliers))]);
        end
    end
end

% normalize to scale
F = best_F/best_F(3,3);
inlier_indices = best_inliers;
