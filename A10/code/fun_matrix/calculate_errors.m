function errors = calculate_errors(F, points1, points2) 
% Calculates Sampson error for all points

n = length(points1);
errors = zeros(1, n);

for i=1:n
    xFx = (points2(:,i)'*F*points1(:,i));
    Fx1 = F*points1(:,i);
    Fx2 = F'*points2(:,i);

    errors(i) = xFx^2 / ( Fx1(1)^2 + Fx1(2)^2 + Fx2(1)^2 + Fx2(2)^2  );
end
