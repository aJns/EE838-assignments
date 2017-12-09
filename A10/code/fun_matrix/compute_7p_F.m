function F = compute_7p_F(points1, points2) 
% expecting points to be of size 3x7

[norm_pts1, T1] = normalize_points(points1);
[norm_pts2, T2] = normalize_points(points2);


A = [norm_pts2(1,:).*norm_pts1(1,:);
     norm_pts2(1,:).*norm_pts1(2,:);
     norm_pts2(1,:);

     norm_pts2(2,:).*norm_pts1(1,:);
     norm_pts2(2,:).*norm_pts1(2,:);
     norm_pts2(2,:);

     norm_pts1(1,:);
     norm_pts1(2,:);
     ones(1,7)]';
% A should be of size 7x9

[~,~,V] = svd(A);

F1 = reshape(V(:,end-1), 3, 3)';
F2 = reshape(V(:,end), 3, 3)';

lambdas = eig(F2^(-1)*F1);
lambdas(imag(lambdas) ~= 0) = [];
lambdas = real(lambdas);

n = length(lambdas);

F = zeros(3, 3, n);
for i=1:n
    F(:,:,i) = (F1+lambdas(i)*F2);
    
    % constraint enforcement and denormalization
    [U,D,V] = svd(F(:, :, i));
    D(3,3) = 0;
    F(:, :, i) = T2'*(U * D * V')*T1;

    if rank(F(:,:,i)) ~= 2
        error('F not rank 2!');
    end
end



function [normalized, T] = normalize_points(points)

centroid = mean(points(1:2,:), 2);

s = sqrt(2)/mean(sqrt( (points(1,:)-centroid(1) ).^2 + (points(2,:)-centroid(2) ).^2 ));

T = [s,     0,      -s*centroid(1);
     0,     s,      -s*centroid(2);
     0,     0,      1];

normalized = T*points;

