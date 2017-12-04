function plot_inliers_outliers(inliers1, inliers2, outliers1, outliers2, I1, I2) 

figure;

J = imfuse(I1, I2);
imshow(J);

image_height = size(J, 1);

hold on;

for i=1:length(inliers1)
    plot(inliers1(i,:), image_height-inliers2(i,:), 'g');
end

for i=1:length(outliers1)
    plot(outliers1(i,:), image_height-outliers2(i,:), 'r');
end

hold off;


