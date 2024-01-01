plot3(xd,yd,zd)
hold on
plot3(x,y,z)
grid on
l=legend('Desired Trajectory','Actual Trajectory');


figure('Name','Formation Errors for Follower 1')
subplot(3,1,1);
plot(tout,x-xd);
title('Formation Error in X Direction For Follower 1');

subplot(3,1,2);
plot(tout,y-yd);
title('Formation Error in Y Direction For Follower 1')


subplot(3,1,3);
plot(tout,z-zd);
title('Formation Error in z Direction For Follower 2');
%%%%%%%%%%%%%
figure('Name','Phi Errors for Follower 1')
subplot(3,1,1);
plot(tout,phi-phid);
title('Angle Error in X Direction For Follower 1');

subplot(3,1,2);
plot(tout,psi-psid);
title('Psi Error in Y Direction For Follower 1')


subplot(3,1,3);
plot(tout,theta-thetad);
title('Theta Error in X Direction For Follower 2');