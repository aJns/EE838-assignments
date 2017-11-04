function d = calc_error(point, model)

x = point(1);
y = point(2);

if length(model) == 2
    a = model(1);
    b = model(2);
    d = abs(a*x - y + b)/sqrt(a^2 + 1^2);
else
    a = model(1);
    b = model(2);
    r = model(3);
    d = abs(sqrt( (x-a)^2  + (y-b)^2 ) -r );
end

end
