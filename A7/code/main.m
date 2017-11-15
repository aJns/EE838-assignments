close all

%% test
I = imread(fullfile('..', 'images', 'H1_ex1.png'));
I = rgb2gray(I);
corners = detectFASTFeatures(I,'MinContrast',0.1);
J = insertMarker(I,corners,'circle');
imshow(J);


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

figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);

%% RANSAC
point_count = length(matchedPoints1.Location);

matched_points1 = [matchedPoints1.Location, ones(point_count, 1)];
matched_points2 = [matchedPoints2.Location, ones(point_count, 1)];

points = randi([1, point_count], 5, 1);
homography = calc_normalized_DLT(matched_points1(points,:), matched_points2(points,:));

inliers = count_inliers(matched_points1, matched_points2, homography, 1)


tform = projective2d(homography');

figure; imshow(imwarp(I, tform));
