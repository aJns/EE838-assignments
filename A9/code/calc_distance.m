function distance = calc_distance(point1, point2, F) 

xFx = point2'*F*point1;

Fx = F*point1;
% Fx = Fx(1:2)/Fx(3);

FTx = F'*point2;
% FTx = FTx(1:2)/FTx(3);

distance = (xFx^2) / ( Fx(1)^2 + Fx(2)^2 + FTx(1)^2 + FTx(2)^2 );
