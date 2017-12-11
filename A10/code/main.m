% matlab setup
dbstop if error
close all

%% Setup VL_FEAT

VLFEATROOT = '../../libs/vlfeat-0.9.20';
run([VLFEATROOT '/toolbox/vl_setup']);
vl_version verbose


%% Add subfolders to path

addpath('fun_matrix');


%% Load images and intrinsic params
data_dir = fullfile('..', 'data');
I1_file = fullfile(data_dir, '1.png');
I2_file = fullfile(data_dir, '2.png');
image_fmt = 'png';
intrinsic_file = fullfile(data_dir, 'Intrinsic_parameter.txt');


[orig_I1, map1] = imread(I1_file, image_fmt);
[orig_I2, map2] = imread(I2_file, image_fmt);
rgb_I1 = ind2rgb(orig_I1, map1);
rgb_I2 = ind2rgb(orig_I2, map2);
I1 = single(rgb2gray(rgb_I1));
I2 = single(rgb2gray(rgb_I2));

% Get intrinsic params and build the intrinsic matrix
intrinsic_params_str = fileread(intrinsic_file);
eval(intrinsic_params_str);
K = [fc(1), alpha_c,    cc(1);
     0,     fc(2),      cc(2);
     0,     0,          1];



%% Get F

[F, inliers, outliers] = estimate_F_from_images(I1, I2);
% plot_inliers_outliers(I1, I2, inliers, outliers);


%% Get E => R & T

E = K'*F*K;

[U,S,V] = svd(E);
W = [0  -1  0;
     1  0   0;
     0  0   1];
Z = [0  1   0;
     -1 0   0;
     0  0   0];

Tx = U*Z*U';
t = [Tx(3,2); Tx(1,3); Tx(2,1)];
R = U*W*V';


%% Get projection matrices

P1 = K*[eye(3) zeros(3,1)];
P2 = K*[R t]; 


%% Triangulation

pts_3d = triangulate_points(P1, P2, inliers(1:3,:), inliers(4:6,:));

% get cartesian coordinates
c_pts_3d = pts_3d(1:3,:)./pts_3d(4,:);

%% get color
% extract color values from images, makes the results in meshlab a bit clearer
I1_pts = uint16(inliers(1:2,:)./inliers(3,:));
n = length(I1_pts);
I1_color = zeros(n, 3);
for i=1:n
    I1_color(i,:) = rgb_I1(I1_pts(2,i), I1_pts(1,i), :);
end

%% Visualize points

% point_cloud exported to meshlab
point_cloud = pointCloud(c_pts_3d', 'Color', I1_color);

% figure;
% pcshow(point_cloud);



