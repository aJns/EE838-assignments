function H = homography_from_DLT(points1, points2) 

n = size(points1, 1);

A = zeros(2, 9, n);

for i=1:n
    A(:,:,i) = compute_A(points1(:,i), points2(:,i));
end

new_A = zeros(2*n, 9);

for i=1:n
    j = i*2;
    new_A(j-1:j,:) = A(:,:,i);
end

A = new_A;

[~,~,V] = svd(A);

h = V(:,end);
H = reshape(h, [3 3])';
