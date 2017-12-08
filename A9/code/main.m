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

F = estimate_F_from_images(I1, I2);

