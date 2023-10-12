time = 0:Ts:Duration;
yreftot = QuadrotorReferenceTrajectory(time)';

% Plot the states.
figure('Name','States')

subplot(2,3,1)
hold on
plot(time,xHistory(:,1))
plot(time,yreftot(:,1))
grid on
xlabel('time')
ylabel('x')
legend('actual','reference','Location','southeast')
title('Qruadrotor x position')

subplot(2,3,2)
hold on
plot(time,xHistory(:,2))
plot(time,yreftot(:,2))
grid on
xlabel('time')
ylabel('y')
legend('actual','reference','Location','southeast')
title('Qruadrotor y position')

subplot(2,3,3)
hold on
plot(time,xHistory(:,3))
plot(time,yreftot(:,3))
grid on
xlabel('time')
ylabel('z')
legend('actual','reference','Location','southeast')
title('Qruadrotor z position')