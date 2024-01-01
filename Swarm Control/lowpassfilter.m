% Low-pass filter design parameters
cutoff_frequency = 0.9;  % Adjust this value according to your requirements
filter_order = 1;      % Adjust this value according to your requirements

% Design the low-pass filter using fir1
b = fir1(filter_order, cutoff_frequency);

% Frequency response plot
freqz(b, 1, 1024, 'half');
title('Frequency Response of Low-Pass Filter');
xlabel('Frequency (normalized)');
ylabel('Magnitude');

% Apply the filter to a signal (example)
input_signal = (x-x1);  % Replace with your actual signal
output_signal = filter(b, 1, input_signal);

% Plot the input and output signals
figure;
subplot(2, 1, 1);
plot(input_signal);
title('Input Signal');

subplot(2, 1, 2);
plot(output_signal-0.9);
title('Formation Error in X');
