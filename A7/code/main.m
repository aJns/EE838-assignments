close all


%% find interest points and matches
I1 = rgb2gray(imread(fullfile('..', 'images', 'H2_ex1.png')));
I2 = rgb2gray(imread(fullfile('..', 'images', 'H2_ex2.png')));

% matlab toolbox
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

% find correspondences using ssd similarity measure
indexPairs = find_correspondences(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

%% RANSAC
point_count = length(matchedPoints1.Location);

N = 500;
T_DIST = 500;
MAX_inlier = -1;
MIN_std = 10e5;
p = 0.99;
sample_size = 4;
best_H = eye(3);
best_inlier_indices = [];

matched_points1 = [matchedPoints1.Location, ones(point_count, 1)];
matched_points2 = [matchedPoints2.Location, ones(point_count, 1)];

warning('off','all');

for i=1:N
    
    indices = randi([1, point_count], sample_size, 1);
    while are_points_collinear(matched_points1(indices, 1:2))
        indices = randi([1, point_count], sample_size, 1);
    end
    homography = calc_normalized_DLT(matched_points1(indices, :), matched_points2(indices, :));

    [inlier_indices, inlier_std] = count_inliers(matched_points1, matched_points2, homography, T_DIST);
    inlier_count = length(inlier_indices);

    if inlier_count > MAX_inlier
        MAX_inlier = inlier_count;
        MIN_std = inlier_std;
        best_H = homography;
        best_inlier_indices = inlier_indices;
    end

    if inlier_count == MAX_inlier && inlier_std < MIN_std
        MIN_std = inlier_std;
        best_H = homography;
        best_inlier_indices = inlier_indices;
    end

    if inlier_count > 0
        outlier_ratio = 1 - inlier_count/point_count;
        N = log(1-p)/log(1-(1-outlier_ratio)^sample_size);
    end

end

% refined H from all inliers
refined_H = estimate_from_inliers(matched_points1(best_inlier_indices, :), matched_points2(best_inlier_indices, :), best_H);


warning('on','all');

%% figures
close all

% original image 1
figure; imshow(I1);

% interest points
im1 = insertMarker(I1, points1, 'circle');
im2 = insertMarker(I2, points2, 'circle');

figure; imshowpair(im1, im2, 'montage');

% correspondence
figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);


% TODO: visualize outliers
% TODO: get outliers in addition to inliers
outlier_indices = setdiff(1:point_count, best_inlier_indices);

inlier_points1 = matched_points1(best_inlier_indices,1:2);
inlier_points2 = matched_points2(best_inlier_indices,1:2);

figure;
showMatchedFeatures(I1, I2, inlier_points1, inlier_points2, 'PlotOptions', {'yo','y+','g-'});

outlier_points1 = matched_points1(outlier_indices,1:2);
outlier_points2 = matched_points2(outlier_indices,1:2);

figure;
showMatchedFeatures(I1, I2, outlier_points1, outlier_points2, 'PlotOptions', {'yo','y+','r-'});


% ransac

tform = projective2d(best_H^(-1)');
best_warp = imwarp(I2, tform);

figure; imshow(best_warp);


% optimal estimation with all inliers

tform = projective2d(refined_H^(-1)');
refined_warp = imwarp(I2, tform);

figure; imshow(refined_warp);



