function F = F_from_DLT(points1, points2) 

n = length(points1);

A = zeros(n, 9);

for i=1:n
    A(i,:) = compute_A_row(points1(:,i), points2(:,i));
end

[~,~,V] = svd(A);

f = V(:,end);
F = reshape(f, [3 3])';
