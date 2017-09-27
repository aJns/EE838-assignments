close all;

imageFolder = fullfile('..', 'images');

%%
image1 = imread(fullfile(imageFolder, 'face.jpg'));
image1 = rgb2gray(image1);
%figure; imshow(image1);

%%
R  = 15;
RQ = 3;
TQ = 8;
HQ = 8;
SI = 1;
LI = 1;
NT = 1;
dzy1 = compute_daisy(image1, R, RQ, TQ, HQ, SI, LI, NT);
descriptor1 = display_descriptor(dzy1, 200, 200);
pre_dzy1 = init_daisy(image1, R, RQ, TQ, HQ, SI, LI, NT);

%%
image1 = imread(fullfile(imageFolder, 'grasshopper.jpg'));
image1 = rgb2gray(image1);
%figure; imshow(image2);

%%
compute_daisy(image2);
