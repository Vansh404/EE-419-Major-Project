syms x y

f=-pi*(x^2)*y;
c=2*pi*(x^2) + 2*pi*x*y - 24*pi;
% disp(solve(diff(f) == 0))
% 
% gdott=diff(diff(f))
% ck=subs(gdott,x,6/5);
% display(ck)