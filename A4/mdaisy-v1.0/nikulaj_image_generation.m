close all;

imageFolder = fullfile('..', 'images');

%%
image1 = imread(fullfile(imageFolder, 'face.jpg'));
image1 = rgb2gray(image1);
figure; imshow(image1);

%%
compute_daisy(image1);

%%
image2 = imread(fullfile(imageFolder, 'grasshopper.jpg'));
image2 = rgb2gray(image2);
figure; imshow(image2);

%%
compute_daisy(image2);