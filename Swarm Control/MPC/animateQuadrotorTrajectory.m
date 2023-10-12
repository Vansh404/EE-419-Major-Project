figure('Name','QuadrotorAnimation');
hold on
for i=1:size(xHistory,1)
    clf;
    animateQuadrotor(time(i), xHistory(i,:));
    pause(Ts);    
end