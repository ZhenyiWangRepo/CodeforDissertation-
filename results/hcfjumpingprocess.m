base_dir = 'C:\Users\wzy\Desktop\Dissertation\test04\';
BW = 65.31 * 9.8; 

% compose name of file with joint contact forces to read ------------------
file     = 's05rra_JointReaction_ReactionLoads.sto';
filename = [ base_dir '\results\' file ];

% read some selected results from the Joint Reaction analysis now ---------
variables = { 'time', ...
              'hip_r_on_femur_r_in_ground_fx', 'hip_r_on_femur_r_in_ground_fy', 'hip_r_on_femur_r_in_ground_fz' };

[ data, var_names, info ] = read_select_opensim_data(filename, variables);


% assign data to some more meaningful variable names, normalise to BW -----
time             = data.matrix(:,1);
r_hip_jcf_vec    = data.matrix(:,2:4);
r_hip_jcf_Fx      = data.matrix(:,2);
r_hip_jcf_Fy      = data.matrix(:,3);
r_hip_jcf_Fz      = data.matrix(:,4);

% normalise force components to [BW]
r_hip_jcf_Fx_BW      = r_hip_jcf_Fx/BW;
r_hip_jcf_Fy_BW      = r_hip_jcf_Fy/BW;
r_hip_jcf_Fz_BW      = r_hip_jcf_Fz/BW;
r_hip_jcf_vec_BW     = r_hip_jcf_vec/BW;
 
% calculate resultant hip joint contact force in [N] and [BW}
r_hip_jcf    = vecnorm(r_hip_jcf_vec,2,2);
r_hip_jcf_BW = vecnorm(r_hip_jcf_vec_BW,2,2);


% interpolate & time-normalise data. 
t_cycle_start = 4.18;  
t_cycle_end   = 4.73;  

cycle_time = linspace(0,100,101);
abs_qtime  = linspace(t_cycle_start, t_cycle_end, 101);

% in the following, we interpolate ALL data in the data.matrix  
time_normalised_data = interp1(time, data.matrix, abs_qtime, 'makima');
% interpolate & time-normalise data 


% name some of the interpolated, time-normalised data for easier access 
TN_r_hip_jcf_vec    = time_normalised_data(:,2:4);
TN_r_hip_jcf_vec_BW = TN_r_hip_jcf_vec/BW;
TN_r_hip_jcf_res_BW = vecnorm(TN_r_hip_jcf_vec_BW,2,2); 
%%%TN_r_hip_jcf_res_BW = time_normalised_data(:,2);

fs = 100; % sampling frequency
fc = 15;   % cutoff frequency

[b, a] = butter(4, fc/(fs/2));
TN_r_hip_jcf_res_BW = filtfilt(b, a, TN_r_hip_jcf_res_BW);


% plot the interpolated HCF components (in the FEMUR CS) for a gait cycle -
figure(100); hold on;
% resultant force, in black, thicker line 
xlabel('Norminlized time [%gait cycle]');
ylabel('Norminlized Force [BW]');
title({'bone-on-bone joint contact forces at the right hip during jumping'});

plot(cycle_time, TN_r_hip_jcf_res_BW ,'k', 'LineWidth', 2);
%plot(cycle_time, abs(TN_r_hip_jcf_vec_BW(:,1)) ,'r', 'LineWidth', 0.8);
%plot(cycle_time, abs(TN_r_hip_jcf_vec_BW(:,2)) ,'g', 'LineWidth', 0.8);
%plot(cycle_time, abs(TN_r_hip_jcf_vec_BW(:,3)) ,'k', 'LineWidth', 0.8);

legend('Fres','Location','northwest')
grid on;

% saves results-------------------------------------------------
%saveas(gcf, 's05rra.png');

savefoler = 'C:\Users\wzy\Desktop\Dissertation\test04\results';

%saveas(gcf, fullfile(savefoler,'s05rra.png'))
%save(fullfile(savefoler, 's05rra.mat'),'TN_r_hip_jcf_res_BW');
