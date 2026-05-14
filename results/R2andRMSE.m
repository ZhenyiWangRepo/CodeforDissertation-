basedir = 'C:\Users\wzy\Desktop\Dissertation\test04\results\';

s0x_filename = [basedir 's01rra.mat'];

X = load(s0x_filename);
x = X.TN_r_hip_jcf_res_BW;
%x = TN_r_hip_jcf_res_BW(:);
y = time_normalised_Fres(:);
%y = Fres_norm(:);



%x = interp1(linspace(0,1,length(x)), x, linspace(0,1,101));
%y = interp1(linspace(0,1,length(y)), y, linspace(0,1,101));


x = x(:);
y = y(:);

N = length(x);

% -----------------------------
% NORMALISATION (for shape comparison)
% -----------------------------
x_norm = (x - mean(x)) / std(x);
y_norm = (y - mean(y)) / std(y);

% -----------------------------
% PREALLOCATE
% -----------------------------
rmse_vals = zeros(N,1);
corr_vals = zeros(N,1);

% -----------------------------
% CIRCULAR SHIFT SEARCH
% -----------------------------
for k = 0:N-1

    y_shift = circshift(y_norm, k);

    diff = x_norm - y_shift;

    rmse_vals(k+1) = sqrt(mean(diff.^2));

    corr_vals(k+1) = corr(x_norm, y_shift);

end

% -----------------------------
% BEST ALIGNMENT
% -----------------------------
[best_rmse, idx_rmse] = min(rmse_vals);
[best_corr, idx_corr] = max(corr_vals);

best_shift = idx_rmse - 1;

% align telemetric signal to simulation
y_aligned = circshift(y, best_shift);

% -----------------------------
% COMPUTE R² (IMPORTANT FIX)
% reference = telemetric (y)
% -----------------------------
SS_res = sum((y_aligned - x).^2);
SS_tot = sum((y_aligned - mean(y_aligned)).^2);

R2 = 1 - SS_res / SS_tot;

% -----------------------------
% OPTIONAL: relative RMSE
% -----------------------------
rRMSE = best_rmse / max(abs(y));   % normalised to telemetric peak

% -----------------------------
% DISPLAY RESULTS
% -----------------------------
fprintf('Circular RMSE: %.4f\n', best_rmse);
fprintf('Relative RMSE: %.2f %%\n', rRMSE*100);
fprintf('Max Correlation: %.4f\n', best_corr);
fprintf('R^2: %.4f\n', R2);
fprintf('Best Shift: %d samples\n', best_shift);

% -----------------------------
% PLOT
% -----------------------------
figure;
plot(y, 'LineWidth', 1.5); hold on;
plot(x, '--', 'LineWidth', 1.5);
plot(y_aligned, ':', 'LineWidth', 1.5);

legend('Telemetric (reference)', ...
       'Simulation (original)', ...
       'Telemetric (aligned)', ...
       'Location', 'northwest');

title(sprintf('cRMSE = %.4f, R^2 = %.4f', best_rmse, R2));
xlabel('Time (% gait cycle)');
ylabel('Force');
grid on;