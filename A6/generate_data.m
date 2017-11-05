function test_data = generate_data(nb_points, range, inlier_th, inlier_ratios, model)

x = zeros(nb_points, 1);
y = zeros(nb_points, 1);

if length(model) == 2
    a = model(1);
    b = model(2);

    x = (range(2)-range(1))*rand(nb_points, 1) + range(1);
    y = a*x + b;

else
    a = model(1);
    b = model(2);
    r = model(3);

    ang=linspace(0, 2*pi, nb_points);
    x=(r*cos(ang) + a)';
    y=(r*sin(ang) + b)';
end

variance = [-20, 20];

nb_inside_th = nb_points * [inlier_ratios 1];
temp_length = length(nb_inside_th);
for i=0:temp_length - 2
    nb_inside_th(temp_length - i) = nb_inside_th(temp_length - i) - nb_inside_th(temp_length - 1 - i);
end

for i=1:nb_points
    while 1
        temp_y = y(i) + (variance(2)-variance(1))*rand(1, 1) + variance(1);

        if length(model) == 2
            temp_x = x(i);
            d = abs(a*temp_x - temp_y + b)/sqrt(a^2 + 1^2);
        else
            temp_x = x(i) + (variance(2)-variance(1))*rand(1, 1) + variance(1);
            d = abs(sqrt( (temp_x-a)^2  + (temp_y-b)^2 ) -r );
        end

        point_okay = 0;
        for j=1:length(inlier_th)
            if d < inlier_th(j)
                if nb_inside_th(j) > 0
                    nb_inside_th(j) = nb_inside_th(j) - 1;
                    point_okay = 1;
                end
                break;
            end
        end
        if point_okay == 1
            x(i) = temp_x;
            y(i) = temp_y;
            break;
        else
            if nb_inside_th(end) > 0
                nb_inside_th(end) = nb_inside_th(end) - 1;
                x(i) = temp_x;
                y(i) = temp_y;
                break;
        end
    end
end

test_data = [x y];













end
