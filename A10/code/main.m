% matlab setup
dbstop if error

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


[I1, map1] = imread(I1_file, image_fmt);
[I2, map2] = imread(I2_file, image_fmt);
rgb_I1 = ind2rgb(I1, map1);
rgb_I2 = ind2rgb(I2, map2);
I1 = single(rgb2gray(rgb_I1));
I2 = single(rgb2gray(rgb_I2));

intrinsic_params_str = fileread(intrinsic_file);
eval(intrinsic_params_str);
K = [fc(1), alpha_c,    cc(1);
     0,     fc(2),      cc(2);
     0,     0,          1];



%% Get F

[F, inliers, outliers] = estimate_F_from_images(I1, I2);
plot_inliers_outliers(I1, I2, inliers, outliers);


%% Get E => R & T

E = K'*F*K; % not getting the right results

[U,S,V] = svd(E);
W = [0  -1  0;
     1  0   0;
     0  0   1];
Z = [0  1   0;
     -1 0   0;
     0  0   0[;

T = U*Z*U';
R = U*W*V';


%% Triangulation


%% 
