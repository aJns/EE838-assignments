function model = approx_model(x, y)

if length(x) == 2
    a = (y(2)-y(1))/(x(2)-x(1));
    b = y(1)-x(1)*( (y(2)-y(1)) / (x(2)-x(1)) );
    model = [a b];
else
    m12 = (y(2) - y(1))/(x(2) - x(1));
    m23 = (y(3) - y(2))/(x(3) - x(2));

    x12 = (x(1) + x(2))/2;
    y12 = (y(1) + y(2))/2;

    x23 = (x(2) + x(3))/2;
    y23 = (y(2) + y(3))/2;

    a = ( m12*m23*(y23-y12)+m12*x23-m23*x12 ) / ( m12-m23 );
    b = (-1/m12)*(a-x12)-y12;
    r = sqrt( (x(1)-a)^2 + (y(1)-b)^2 );
    model = [a b r];
end


end
