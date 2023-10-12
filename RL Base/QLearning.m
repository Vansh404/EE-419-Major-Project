% CartPole Q-learning in MATLAB

% Define environment constants
num_states = 4;          % Number of state variables
num_actions = 2;         % Number of possible actions (left or right)

% Hyperparameters
alpha = 0.1;             % Learning rate
gamma = 0.99;            % Discount factor
epsilon = 0.2;           % Exploration rate
num_episodes = 500;     % Number of training episodes
max_steps = 500;         % Maximum number of steps per episode

% Initialize Q-table
Q = rand(num_states, num_actions); % Random initialization

% Training loop
for episode = 1:num_episodes
    % Reset the environment
    state = [0, 0, 0, 0];  % Initial state
    total_reward = 0;
    
    for step = 1:max_steps
        % Epsilon-greedy exploration
        if rand < epsilon
            action = randi([1, num_actions]);
        else
            [~, action] = max(Q(state, :));
        end
        
        % Take the action and observe the next state and reward
        [next_state, reward, done] = cartpole_step(state, action);
        
        % Update Q-table using Q-learning equation
        Q(state, action) = Q(state, action) + alpha * (reward + gamma * max(Q(next_state, :)) - Q(state, action));
        
        state = next_state;
        total_reward = total_reward + reward;
        
        if done
            break;
        end
    end
    
    fprintf('Episode %d, Total Reward: %d\n', episode, total_reward);
end

% Testing the trained Q-learning agent
num_test_episodes = 10;
test_rewards = zeros(1, num_test_episodes);

for episode = 1:num_test_episodes
    % Reset the environment
    state = [0, 0, 0, 0];  % Initial state
    total_reward = 0;
    
    while true
        [~, action] = max(Q(state, :));
        [next_state, reward, done] = cartpole_step(state, action);
        
        state = next_state;
        total_reward = total_reward + reward;
        
        if done
            break;
        end
    end
    
    test_rewards(episode) = total_reward;
    fprintf('Test Episode %d, Total Reward: %d\n', episode, total_reward);
end

avg_test_reward = mean(test_rewards);
fprintf('Average Test Reward: %f\n', avg_test_reward);

% Helper function for simulating CartPole environment
function [next_state, reward, done] = cartpole_step(state, action)
    % Constants
    gravity = 9.8;
    mass_cart = 1.0;
    mass_pole = 0.1;
    total_mass = mass_cart + mass_pole;
    length_pole = 0.5;
    pole_mass_length = mass_pole * length_pole;
    force_mag = 10.0;
    tau = 0.02;  % Time step

    % Unpack state variables
    x, x_dot, theta, theta_dot = state;
    
    % Calculate common terms
    costheta = cos(theta);
    sintheta = sin(theta);
    
    % Calculate the derivatives
    temp = (force_mag * action + pole_mass_length * theta_dot^2 * sintheta) / total_mass;
    thetaacc = (gravity * sintheta - costheta * temp) / (length_pole * (4.0/3.0 - mass_pole * costheta^2 / total_mass));
    xacc = temp - pole_mass_length * thetaacc * costheta / total_mass;
    
    % Update state variables
    x = x + tau * x_dot;
    x_dot = x_dot + tau * xacc;
    theta = theta + tau * theta_dot;
    theta_dot = theta_dot + tau * thetaacc;
    
    % Check if episode is done
    done = (x < -2.4 || x > 2.4 || theta < -12 * pi / 360 || theta > 12 * pi / 360);
    
    % Define reward
    if ~done
        reward = 1;
    else
        reward = 0;
    end
    
    % Pack next state
    next_state = [x, x_dot, theta, theta_dot];
end
