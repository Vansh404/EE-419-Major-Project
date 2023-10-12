syms Z X1 X2 Z1

Z=-X1-X2;
fsurf(Z);

Z1=-X1^2-X2;
figure;fsurf(Z1);
Z2=-X1-X2^2;
figure;fsurf(Z2);

Z3=-X1^2-X2^2;
figure;fsurf(Z3);

% Z=X1+X2<4;