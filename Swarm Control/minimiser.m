

% Set the initial guess for optimization
initial_guess = [0, 0];

% Define lower and upper bounds (empty for no bounds)
lb = [];
ub = [];

% Define options for the optimization
options = optimoptions('fmincon', 'Display', 'iter');  % Display optimization progress

% Perform constrained minimization
[x_opt, f_opt] = fmincon(@objective_function, initial_guess, [], [], [], [], lb, ub, @constraints, options);

% Display the optimal solution
disp('Optimal solution:');
disp(['x_opt = ', num2str(x_opt)]);
disp(['f_opt = ', num2str(f_opt)]);


% Define the objective function
function f = objective_function(x)
    % Replace this with your actual objective function
    f = +(x(1))^2 + (x(2))^2 - x(1)*x(2) - 7*x(1) - 4*x(2) ;
end

% Define the constraints
function [c, ceq] = constraints(x)
    c1=2*(x(1))+ 3*x(2) - 24;
    c2=-5*(x(1)) + 12*x(2) - 24;
    c3=x(2) - 4;
    % Inequality constraints
    c = [c1;c2;c3];
    
    % No equality constraints, set ceq as an empty array
    
    ceq=[];
end
