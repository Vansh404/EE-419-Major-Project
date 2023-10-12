dx=-0.691790139955803;
dy=-0.349795785474519;
dz=-2.46660114555652e-09;
yaw=0.30001;

buff_pos=(dx*sin(yaw)-dy*cos(yaw))/((dx^2)+(dy^2)+(dz+g)^2);
%THIS IS ROLL
phi123=asin(buff_pos)
buff_pos1=(dx*cos(yaw)+dy*sin(yaw))/(g+dz);
%THIS IS PITCH
theta123=atan(buff_pos1)