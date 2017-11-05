function test_data = gen_data_sets(nb_points, range, inlier_th, inlier_ratios, model)

test_data = zeros(nb_points, 2, length(inlier_th), length(inlier_ratios));

for i=1:length(inlier_th)
    for j=1:length(inlier_ratios)
        test_data(:,:,i,j) = generate_data(nb_points, range, inlier_th(i), inlier_ratios(j), model);
    end
end


end
