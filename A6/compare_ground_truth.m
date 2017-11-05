function mean_squared_error = compare_ground_truth(ground_truth, approx_model)

if length(ground_truth) == 2
    a_truth = ground_truth(1);
    b_truth = ground_truth(2);

    a_approx = approx_model(1);
    b_approx = approx_model(2);

    x = linspace(0, 100);
    y_truth = a_truth*x + b_truth;
    y_approx = a_approx*x + b_approx;

    mean_squared_error = immse(y_truth, y_approx);

else
end


end
