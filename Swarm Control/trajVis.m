plot3(xd,yd,zd)
hold on
plot3(x,y,z)
grid on
l=legend('Desired Trajectory','Actual Trajectory');

figure('Name','Formation Errors for Follower 1')
subplot(1,2,1);
plot(xd-x,tout);
title(' Error in X Direction ');

subplot(1,2,2);
plot(yd-y,tout);
title(' Error in Y Direction ')

