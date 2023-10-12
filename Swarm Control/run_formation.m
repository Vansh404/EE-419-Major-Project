clearvars;
sim('UAVFormation')
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

% figure('Name','Performance')
% subplot(3,3,1);
% plot(tout, x, tout, xd);