function F = calculate_F(points1, points2) 

n = length(points1);

A = zeros(n, 9);

for i=1:n
    A(i,:) = compute_A_row(points1(:,i), points2(:,i));
end

[~,~,V] = svd(A);

f1 = V(:,end-1);
F1 = reshape(f1, [3 3])';

f2 = V(:,end);
F2 = reshape(f2, [3 3])';

a = sym('a');

solv_a = solve( det( a*F1 + (1-a)*F2 ) == 0, a);
n = 0;
threshold = 1e-12;

while n < 1
    a = double(solv_a);
    a = real( a(logical(imag(a) < threshold)) );
    n = length(a);
    F = zeros(3, 3, n);
    threshold = threshold*10;
end

for i=1:n
    F(:,:,i) = a(i)*F1 + (1-a(i))*F2;
end

