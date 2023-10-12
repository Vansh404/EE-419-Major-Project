
clc, clear all;
% Constants
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
J=0.85;

y_i=0;
x_i=0;

y_i1=2;
x_i1=0;
% Initial configuration
roll_i = 0;   % rad
pitch_i = 0;  % rad
yaw_i = 0;      % rad
altitude_i = 0;  % meters


% Desired configuration
roll_d = 0.1;   % radPHI
pitch_d = -0.1;     % radTHETA
yaw_d = 0.3;     % radPSI
altitude_d = 5;  % meters

yaw_d1=0.3;
roll_d1 = 0.1;   % radPHI
pitch_d1 = -0.1;     % radTHETA

sim("formation") % Initialize Simulink 

% Plot the movements
figure('Name', 'Positions', 'NumberTitle','off')
plot3(x, y, z)
hold on
% plot3(x1,y1,z1)
%plot3(x2,y2,z2)

xlabel("Position x")
l = legend(' Leader Position', ' Follower Position');
ylabel("Position y")
zlabel("Position z")
title("Positions")
grid on

% figure('Name', 'Roll angle', 'NumberTitle','off')
% plot(tout, roll, tout, roll_desiredsim);
% xlabel('Time (s)', 'interpreter', 'latex')
% l = legend('$\phi$ Current roll angle', '$\phi_d$ Desired roll angle');
% set(l, 'interpreter', 'latex')
% 
% figure('Name', 'Pitch angle', 'NumberTitle','off')
% plot(tout, pitch, tout, pitch_desiredsim1);
% xlabel('Time (s)', 'interpreter', 'latex')
% l = legend('$\theta$ Current pitch angle', '$\theta_d$ Desired pitch angle');
% set(l, 'interpreter', 'latex')
% 
% figure('Name', 'Yaw angle', 'NumberTitle','off')
% plot(tout, yaw, tout, ones(size(tout))*yaw_d);
% xlabel('Time (s)', 'interpreter', 'latex')
% l = legend('$\psi$ Current yaw angle', '$\psi_d$ Desired yaw angle');
% set(l, 'interpreter', 'latex')
% 
% figure('Name', 'Altitude', 'NumberTitle','off')
% plot(tout, z, tout, ones(size(tout))*altitude_d);
% xlabel('Time (s)', 'interpreter', 'latex')
% l = legend('$\phi$ Current altitude', '$\phi_d$ Desired altitude');
% set(l, 'interpreter', 'latex')


figure('Name', 'Altitude', 'NumberTitle','off')
plot(tout, z, tout, z_given);
xlabel('Time (s)', 'interpreter', 'latex')
l = legend('$\phi$ Current altitude', '$\phi_d$ Desired altitude');
set(l, 'interpreter', 'latex')

figure('Name', 'X Direction', 'NumberTitle','off')
plot(tout, x, tout, x_given);
xlabel('Time (s)', 'interpreter', 'latex')
l = legend('$\phi$ Current X ', '$\phi_d$ Desired X');
set(l, 'interpreter', 'latex')

figure('Name', 'Y Direction', 'NumberTitle','off')
plot(tout, y, tout, y_given);
xlabel('Time (s)', 'interpreter', 'latex')
l = legend('$\phi$ Current Y ', '$\phi_d$ Desired Y');
set(l, 'interpreter', 'latex')
