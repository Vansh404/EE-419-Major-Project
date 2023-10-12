% syms s
% 
% A=[(s-2) 3 8;0 (s-5) -3;3 5 (s+4)];
% display(inv(A))
syms z

Q=[1-z 0 0 1 1;0 1-z 0 -1 1;0 0 1-z 0 1;1 -1 0 0 0;1 1 1 0 0];
display(det(Q))