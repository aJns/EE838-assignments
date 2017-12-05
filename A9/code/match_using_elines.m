function matches = match_using_elines(F, keypoints1, descriptors1, keypoints2, descriptors2) 

dist_t = 1.5;
match_t = 3;

n = length(keypoints1);
matches1 = zeros(2, n);
epi_lines = epipolarLine(F, keypoints1');
for i=1:n
    line = epi_lines(i, :);
    indices = close_enough_points(line, keypoints2, dist_t);
    temp = vl_ubcmatch(descriptors1(:,i), descriptors2(:,indices), match_t);
    if ~isempty(temp)
        matches1(2, i) = indices(temp(2));
        matches1(1, i) = i;
    end
end
matches1( :, ~any(matches1,1) ) = [];

%n = length(keypoints2);
%matches2 = zeros(2, n);
%epi_lines = epipolarLine(F', keypoints2');
%for i=1:n
%    line = epi_lines(i, :);
%    indices = close_enough_points(line, keypoints1, dist_t);
%    temp = vl_ubcmatch(descriptors2(:,i), descriptors1(:,indices), match_t);
%    if ~isempty(temp)
%        matches2(:, i) = temp;
%        matches2(1, i) = i;
%    end
%end
%
%if length(matches1) < length(matches2)
%    matches = build_match_array(matches1, matches2);
%else
%    matches = build_match_array(matches2, matches1);
%end

matches = matches1;
