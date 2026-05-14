%% process and plot the telemetric force of s00

filename = 'C:\Users\wzy\Desktop\Dissertation\test04\ebl4721a_jump.txt';  

BW = 600;

data = readmatrix(filename, 'NumHeaderLines', 1);
time = data(:,1);
Fx = data(:,2);
Fy = data(:,3);
Fz = data(:,4);
Fres = data(:,5);

Fx_norm   = Fx / BW;
Fy_norm   = Fy / BW;
Fz_norm   = Fz / BW;
Fres_norm = Fres / BW;

t_cycle_start = 4.18;  
t_cycle_end   = 4.63; 
cycle_time = linspace(0,100,101);
abs_qtime  = linspace(t_cycle_start, t_cycle_end, 101);
time_normalised_Fx = interp1(time, Fx_norm , abs_qtime, 'makima');
time_normalised_Fy = interp1(time, Fy_norm , abs_qtime, 'makima');
time_normalised_Fz = interp1(time, Fz_norm , abs_qtime, 'makima');
time_normalised_Fres = interp1(time, Fres_norm , abs_qtime, 'makima');


% --- Plot all components ---
figure;
%plot(cycle_time, time_normalised_Fx  ,   'b', 'LineWidth', 0.8); hold on;
%plot(cycle_time, time_normalised_Fy  ,   'g', 'LineWidth', 0.8);
%plot(cycle_time, time_normalised_Fz  ,   'b', 'LineWidth', 0.8);
plot(cycle_time, time_normalised_Fres,   'r', 'LineWidth', 2); 
xlabel('Normalized Time (% cycle)');
ylabel('Normalized Force (BW)');
title('Telemetric Force Norminlized of s00');
legend('Fres','Location','best');
grid on;


savefoler = 'C:\Users\wzy\Desktop\Dissertation\test04\results';
%saveas(gcf, fullfile(savefoler,'ebl4721a_jump.png'))