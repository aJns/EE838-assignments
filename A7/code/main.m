close all

%% test
I = imread(fullfile('..', 'images', 'H1_ex1.png'));
I = rgb2gray(I);
corners = detectFASTFeatures(I,'MinContrast',0.1);
J = insertMarker(I,corners,'circle');


%% find interest points and matches
I1 = rgb2gray(imread(fullfile('..', 'images', 'H1_ex1.png')));
I2 = rgb2gray(imread(fullfile('..', 'images', 'H1_ex2.png')));

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

%% RANSAC
point_count = length(matchedPoints1.Location);

N = 500;
T_DIST = 5e+3;
MAX_inlier = -1;
MIN_std = 10e5;
p = 0.99;
best_H = eye(3);

matched_points1 = [matchedPoints1.Location, ones(point_count, 1)];
matched_points2 = [matchedPoints2.Location, ones(point_count, 1)];

warning('off','all');

for i=1:N
    
    indices = randi([1, point_count], 4, 1);
    while are_points_collinear(matched_points1(indices,1:2))
        indices = randi([1, point_count], 4, 1);
    end
    homography = calc_normalized_DLT(matched_points1(indices,:), matched_points2(indices,:));

    inliers = count_inliers(matched_points1, matched_points2, homography, T_DIST);

    if inliers > MAX_inlier
        MAX_inlier = inliers;
        best_H = homography;
    end
end

warning('on','all');

% figures
close all

figure; imshow(J);

figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);


% ransac

tform = projective2d(best_H');

figure; imshow(imwarp(I, tform));
