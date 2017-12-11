function pts_3d = triangulate_points(P1, P2, pts1, pts2) 
% Triangulation implemented simply with the linear algorithm. The points should
% probably be normalized, but good results are obtained even without it.

n = length(pts1);
pts_3d = zeros(4, n);

for i=1:n
    x1 = pts1(1,i);
    y1 = pts1(2,i);
    x2 = pts2(1,i);
    y2 = pts2(2,i);

    A = [
        x1*P1(3,:)-P1(1,:);
        y1*P1(3,:)-P1(2,:);
        x2*P2(3,:)-P2(1,:);
        y2*P2(3,:)-P2(2,:)
    ];

    [~,~,V] = svd(A);

    pts_3d(:,i) = V(:,end);
end
