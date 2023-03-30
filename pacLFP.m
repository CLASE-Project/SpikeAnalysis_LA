% Step 1: Create simulated time series signals with theta-gamma coupling
fs = 1000; % Sampling frequency (Hz)
T = 10; % Total time (s)
t = 0:1/fs:T-1/fs; % Time vector

% Theta and gamma frequencies
f_theta = 8; % Hz
f_gamma = 40; % Hz

% Generate theta signal
theta_signal = sin(2 * pi * f_theta * t);

% Generate gamma signal
gamma_signal = sin(2 * pi * f_gamma * t);

% Create amplitude-modulated gamma signal
mod_gamma_signal = (1 + 0.5 * theta_signal) .* gamma_signal;

% Combine theta and gamma signals
combined_signal = theta_signal + mod_gamma_signal;

% Step 2: Compute amplitude-phase coupling using Hilbert transform
theta_analytic = hilbert(theta_signal);
theta_phase = angle(theta_analytic);




%%

% Step 2 (cont.): Compute amplitude-phase coupling using Hilbert transform
gamma_analytic = hilbert(mod_gamma_signal);
gamma_amp = abs(gamma_analytic);

% Step 3: Generate comodulogram to visualize coupling
num_bins = 18;
bin_edges = linspace(-pi, pi, num_bins+1);
bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;

% Compute phase-amplitude coupling
pac = zeros(1, num_bins);
for i = 1:num_bins
    idx = theta_phase >= bin_edges(i) & theta_phase < bin_edges(i+1);
    pac(i) = mean(gamma_amp(idx));
end

% Normalize PAC
pac_normalized = pac / sum(pac);

% Visualize comodulogram
figure;
bar(bin_centers, pac);
title('Comodulogram: Theta-Gamma Coupling');
xlabel('Theta Phase (rad)');
ylabel('Normalized Gamma Amplitude');


%%

% Step 3 (cont.): Generate heat plot to visualize coupling
theta_range = linspace(4, 12, 25); % Define theta frequency range (Hz)
gamma_range = linspace(30, 80, 25); % Define gamma frequency range (Hz)

% Compute phase-amplitude coupling for each theta-gamma frequency pair
pac_matrix = zeros(length(theta_range), length(gamma_range));
for i = 1:length(theta_range)
    for j = 1:length(gamma_range)
        theta_signal_temp = sin(2 * pi * theta_range(i) * t);
        mod_gamma_signal_temp = (1 + 0.5 * theta_signal_temp) .* sin(2 * pi * gamma_range(j) * t);

        theta_analytic_temp = hilbert(theta_signal_temp);
        theta_phase_temp = angle(theta_analytic_temp);

        gamma_analytic_temp = hilbert(mod_gamma_signal_temp);
        gamma_amp_temp = abs(gamma_analytic_temp);

        pac_temp = zeros(1, num_bins);
        for k = 1:num_bins

            idx = theta_phase_temp >= bin_edges(k) & theta_phase_temp < bin_edges(k+1);
            pac_temp(k) = mean(gamma_amp_temp(idx));
        end

        pac_normalized_temp = pac_temp / sum(pac_temp);
        pac_matrix(i, j) = max(pac_normalized_temp);
    end
end

% Visualize heat plot for the comodulogram
figure;
imagesc(gamma_range, theta_range, pac_matrix);
title('Heat Plot: Theta-Gamma Coupling');
xlabel('Gamma Frequency (Hz)');
ylabel('Theta Frequency (Hz)');
colorbar;
axis xy;



%%

% Step 1: Create simulated time series signals with theta-gamma coupling
fs = 1000; % Sampling frequency (Hz)
T = 10; % Total time (s)
t = 0:1/fs:T-1/fs; % Time vector

% Theta and gamma frequencies
f_theta = 8; % Hz
f_gamma = 40; % Hz

% Generate theta signal with random noise
theta_signal = sin(2 * pi * f_theta * t) + 0.1 * randn(size(t));

% Generate bursty gamma signal
burst_duration = 0.1; % 100 ms burst duration
burst_period = 1; % 1s interval between bursts
burst_t = 0:1/fs:burst_duration-1/fs;
gamma_burst = sin(2 * pi * f_gamma * burst_t);
gamma_signal = repmat([gamma_burst, zeros(1, fs * (burst_period - burst_duration))], 1, T / burst_period);
gamma_signal = gamma_signal(1:length(t));

% Create amplitude

% Create amplitude-modulated gamma signal
mod_gamma_signal = (1 + 0.5 * theta_signal) .* gamma_signal;

% Add random noise to the gamma signal
mod_gamma_signal = mod_gamma_signal + 0.2 * randn(size(t));

% Combine theta and gamma signals
combined_signal = theta_signal + mod_gamma_signal;

% Visualize the simulated signals
figure;
subplot(3, 1, 1);
plot(t, theta_signal);
title('Theta Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, mod_gamma_signal);
title('Modulated Gamma Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(t, combined_signal);
title('Combined Signal');
xlabel('Time (s)');
ylabel('Amplitude');



