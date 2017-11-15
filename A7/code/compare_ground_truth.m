% This function calculates the MSE from the ground truth model to the RANSAC
% approximated model. Very useful for assessing RANSAC performance.

function mean_squared_error = compare_ground_truth(ground_truth, approx_model)

% line
if length(ground_truth) == 2
    % get model params
    a_truth = ground_truth(1);
    b_truth = ground_truth(2);

    a_approx = approx_model(1);
    b_approx = approx_model(2);

    % calculate the actual points
    x = linspace(0, 100);
    y_truth = a_truth*x + b_truth;
    y_approx = a_approx*x + b_approx;

    % error!
    mean_squared_error = immse(y_truth, y_approx);

    % circle
else
    a_truth = ground_truth(1);
    b_truth = ground_truth(2);
    r_truth = ground_truth(3);

    a_approx = approx_model(1);
    b_approx = approx_model(2);
    r_approx = approx_model(3);

    ang=linspace(0, 2*pi);
    x_truth = (r_truth*cos(ang) + a_truth)';
    y_truth = (r_truth*sin(ang) + b_truth)';
    x_approx = (r_approx*cos(ang) + a_approx)';
    y_approx = (r_approx*sin(ang) + b_approx)';

    truth = [x_truth y_truth];
    approx = [x_approx y_approx];

    mean_squared_error = immse(truth, approx);

end


end
