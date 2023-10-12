clc,clear all;
g = 9.81; 
m = 0.468;
k = 2.980e-6; % Thrust factor of rotor (depends on density
              % geometry, etc)
           % to the centre of gravity           
l = 0.225; % Linear distance from the centre of the rotor
b = 1.140e-7; % Drag constant
Im = 3.357e-5; % Inertia moment of the rotor

% Inertia 
I_xx = 4.856e-3; % kg*m^2
I_yy = 4.856e-3; % kg*m^2
I_zz = 8.801e-3; % kg*m^2


% Initial configuration
roll_i = 0;   % rad
pitch_i = 0;  % rad
yaw_i = 0;      % rad
altitude_i = 0;  % meters



% Desired configuration
desired_roll = -0.3;   % rad
desired_pitch = 0.9;     % rad
desired_yaw = pi;     % rad
desired_altitude = 5;  % metersdesired_vx=4;

sim("normal_dynamics")



%%Plotting
plot3(x, y, z)
xlabel("Position x")
ylabel("Position y")
zlabel("Position z")
title("Positions")
grid on


figure('Name', 'Roll angle', 'NumberTitle','off')
plot(tout, roll, tout, ones(size(tout))*desired_roll);
xlabel('Time (s)')
l = legend('$\phi$ Current roll angle', '$\phi_d$ Desired roll angle');
set(l, 'interpreter', 'latex')

figure('Name', 'Pitch angle', 'NumberTitle','off')
plot(tout, pitch, tout, ones(size(tout))*desired_pitch);
xlabel('Time (s)')
l = legend('$\phi$ Current pitch angle', '$\phi_d$ Desired pitch angle');
set(l, 'interpreter', 'latex')

figure('Name', 'Yaw angle', 'NumberTitle','off')
plot(tout, yaw, tout, ones(size(tout))*desired_yaw);
xlabel('Time (s)')
l = legend('$\phi$ Current yaw angle', '$\phi_d$ Desired yaw angle');
set(l, 'interpreter', 'latex')

figure('Name', 'Altitude', 'NumberTitle','off')
plot(tout, z, tout, ones(size(tout))*desired_altitude);
xlabel('Time (s)')
l = legend('$\phi$ Current altitude', '$\phi_d$ Desired altitude');
set(l, 'interpreter', 'latex')

%error_plots= generate_errorresp(err_roll,err_yaw,err_pitch,err_altitude);

function error_plots= generate_errorresp(err_roll,err_yaw,err_pitch,err_altitude)
figure;
plot(err_altitude)
title('Altitude Error over Time')

figure;
plot(err_roll)
title('Roll Error over Time')


figure;
plot(err_pitch)
title('Pitch Error over Time')


figure;
plot(err_yaw)
title('Yaw Error over Time')



error_plots=0;
end