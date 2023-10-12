function [ desired_state ]=leader_trajectory(t)
x=sin(t);
y=cos(t);
z=5t;
desired_state=[x y z];