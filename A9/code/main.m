% matlab setup
dbstop if error

%% Setup VL_FEAT

VLFEATROOT = '../../libs/vlfeat-0.9.20';
run([VLFEATROOT '/toolbox/vl_setup']);
vl_version verbose

%% find interest points and matches
input_folder = fullfile('..', 'data');

orig_I1 = rgb2gray(imread(fullfile(input_folder, '1-1.jpg')));
orig_I2 = rgb2gray(imread(fullfile(input_folder, '1-2.jpg')));

I1 = single(orig_I1);
I2 = single(orig_I2);

[keypoints1, descriptors1] = vl_sift(I1);
[keypoints2, descriptors2] = vl_sift(I2);

matches = vl_ubcmatch(descriptors1, descriptors2);


%% RANSAC
point_count = length(matches);

N = 500;
T_DIST = 1e3;
MAX_inlier = -1;
MIN_std = 10e5;
p = 0.99;
sample_size = 7;
best_F = eye(3);
best_inlier_indices = [];

matched_points1 = [keypoints1(1:2, matches(1,:)); ones(1, point_count)];
matched_points2 = [keypoints2(1:2, matches(2,:)); ones(1, point_count)];

warning('off','all');

disp('Starting RANSAC...');

for i=1:N
    
    if mod(i, 50) == 0
        disp([ num2str(i) '/' num2str(N) ' iterations computed, MAX_inlier: ' num2str(MAX_inlier) ]);
    end
    
    indices = randperm(point_count, sample_size);
    curr_F = calculate_F(matched_points1(:, indices), matched_points2(:, indices));

    if isreal(curr_F) == false
        error('F not real!');
    end

    M = size(curr_F, 3);
    for j=1:M

        [inlier_indices, inlier_std] = count_inliers(matched_points1, matched_points2, curr_F(:,:,j), T_DIST);
        inlier_count = length(inlier_indices);

        if inlier_count > MAX_inlier
            MAX_inlier = inlier_count;
            MIN_std = inlier_std;
            best_F = curr_F(:,:,j);
            best_inlier_indices = inlier_indices;
        end

        if inlier_count == MAX_inlier && inlier_std < MIN_std
            MIN_std = inlier_std;
            best_F = curr_F(:,:,j);
            best_inlier_indices = inlier_indices;
        end

    end

%    if inlier_count > 0
%        outlier_ratio = 1 - inlier_count/point_count;
%        N = log(1-p)/log(1-(1-outlier_ratio)^sample_size);
%    end

end

disp('Finished RANSAC');

[matlab_F, matlab_inliers] = estimateFundamentalMatrix(matched_points1(1:2,:)',matched_points2(1:2,:)');
disp('Difference between my calculation and Matlabs version:');
disp(num2str(immse(matlab_F, best_F)));
matlab_inlier_count = nnz(matlab_inliers);

%% Non-linear estimation



%% Guided matching



%% Visualization
% 
% figure(1); clf;
% % imshow(orig_I1);
% % hold on;
% epiLines = epipolarLine(best_F', matched_points1(1:2, inlier_indices)');
% points = lineToBorderPoints(epiLines, size(orig_I2)+1000);
% line(points(:,[1,3])',points(:,[2,4])');
% hold on;
% imshow(orig_I2);


figure(2) ; clf ;
% imshow(cat(2, orig_I1, orig_I2)) ;
imshow(orig_I1) ;

% x2 = keypoints2(1,matches(2,:)) + size(I1, 2) ;
x1 = matched_points1(1, best_inlier_indices);
x2 = matched_points2(1, best_inlier_indices);%+ size(I1, 2);
y1 = matched_points1(2, best_inlier_indices);
y2 = matched_points2(2, best_inlier_indices);

hold on;
h = line([x1 ; x2], [y1 ; y2]) ;
set(h,'linewidth', 1, 'color', 'b') ;
plot(x1, y1, 'b*');
hold off;


% x1 = matched_points1(1, matlab_inliers);
% x2 = matched_points2(1, matlab_inliers) + size(I1, 2);
% y1 = matched_points1(2, matlab_inliers);
% y2 = matched_points2(2, matlab_inliers);
% 
% hold on;
% h = line([x1 ; x2], [y1 ; y2]) ;
% set(h,'linewidth', 1, 'color', 'y') ;
% hold off;



