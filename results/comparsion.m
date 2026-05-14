basedir = 'C:\Users\wzy\Desktop\Dissertation\test04\results\';

s0x_filename = [basedir 's06rra.mat'];

X = load(s0x_filename);
x = X.TN_r_hip_jcf_res_BW;
%x = TN_r_hip_jcf_res_BW(:);
y = time_normalised_Fres(:);

% Resample to same length-
N = 100;

x_rs = interp1(linspace(0,1,length(x)), x, linspace(0,1,N));
y_rs = interp1(linspace(0,1,length(y)), y, linspace(0,1,N));

% remove NaNs
x_rs(isnan(x_rs)) = 0;
y_rs(isnan(y_rs)) = 0;

% Normalize 
x_rs = (x_rs - mean(x_rs)) / std(x_rs);
y_rs = (y_rs - mean(y_rs)) / std(y_rs);

% Circular comparison
rmse_vals = zeros(N,1);
corr_vals = zeros(N,1);

for k = 0:N-1

    y_shift = circshift(y_rs, k);

    diff = x_rs - y_shift;

    rmse_vals(k+1) = sqrt(mean(diff.^2));

    corr_vals(k+1) = sum(x_rs .* y_shift) / (N - 1);

end

[best_rmse, idx] = min(rmse_vals);
best_shift = idx - 1;

y_best = circshift(y_rs, best_shift);


% Output
fprintf('Circular RMSE: %.6f\n', best_rmse);
fprintf('Best shift: %d samples\n', best_shift);

% Plot
figure;
plot(x_rs, 'LineWidth', 2); hold on;
plot(y_best,  'LineWidth', 2);
xlabel('Norminlized Time'); ylabel('Norminlized Hip Contact Force');
legend('simulated' , 'Telemetric' ,'Location','best');
title('Circular alignment of two cycles');
grid on;

psavefolder = [basedir 'comparsion\'];

saveas(gcf, fullfile(psavefolder,'s06rra_comparsion.png'))
%saveas(gcf, 'Circular alignment of two cycles.png');

figure;
plot(0:N-1, rmse_vals, 'LineWidth', 2);
xlabel('Shift'); ylabel('RMSE');
title('Circular RMSE vs Shift');
grid on;

%saveas(gcf, 'Circular RMSE vs Shift.png');