sim("UAVFormation")

figure('Name', 'Positions', 'NumberTitle','off')
plot3(x, y, z)
hold on
plot3(x1,y1,z1)
plot3(x2,y2,z2)
plot3(x3,y3,z3)
xlabel("Position x")
l = legend(' Leader Position', ' Follower 1 Position','Follower 2 Position','Follower 3 Position');
ylabel("Position y")
zlabel("Position z")
title("Positions")
grid on

figure('Name','Formation Errors for Follower 1')
subplot(2,1,1);
plot(tout,x-x1);
title('Formation Error in X Direction For Follower 1');

subplot(2,1,2);
plot(tout,y-y1);
title('Formation Error in Y Direction For Follower 1')

figure('Name','Formation Errors for Follower 2')
subplot(2,1,1);
plot(tout,x-x2);
title('Formation Error in X Direction For Follower 2');

subplot(2,1,2);
plot(tout,y-y2);
title('Formation Error in Y Direction For Follower 2')

figure('Name','Formation Errors for Follower 3')
subplot(2,1,1);
plot(tout,x-x3);
title('Formation Error in X Direction For Follower 3');

subplot(2,1,2);
plot(tout,y-y3);
title('Formation Error in Y Direction For Follower 3')
