function score = calc_msac_score(test_data, model, threshold)

score = 0;
for k=1:length(test_data)
    d = calc_error(test_data(k,:), model);
    if d < threshold
        score = score + (1 - d/threshold);
    end
end

