function index_pairs = find_correspondences(features1, features2) 

flip = size(features1, 1) > size(features2, 1);

if flip
    f1 = features2;
    f2 = features1;
else
    f1 = features1;
    f2 = features2;
end

index_pairs = zeros(size(f1, 1), 2);

for i=1:size(f1, 1)
    min_sim = 0.03;
    best_index = 0;

    for j=1:size(f2, 1)
        similarity = calc_similarity(f1(i,:), f2(j,:));

        if similarity < min_sim
            min_sim = similarity;
            best_index = j;
        end
    end

    if flip
        index_pairs(i, :) = [best_index, i];
    else
        index_pairs(i, :) = [i, best_index];
    end
end

log_i = index_pairs(:,1) == 0;
index_pairs(log_i,:) = [];

log_i = index_pairs(:,2) == 0;
index_pairs(log_i,:) = [];










