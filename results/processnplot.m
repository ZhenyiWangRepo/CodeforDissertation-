%% process and plot the telemetric force of s00w

filename = 'C:\Users\wzy\Desktop\Dissertation\test04\ebr135a.txt';  

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

totalTime = time(end);
numCycles = floor(totalTime); 

numPoints = 100;             
cycleTime = linspace(0,1,numPoints);

FxCycles   = [];
FyCycles   = [];
FzCycles   = [];
FresCycles = [];

for i = 1:numCycles
    idx = find(time >= (i-1) & time < i);
    % Normalize cycle time to 0-1
    cycleTimeRaw = time(idx) - (i-1);
    
    FxCycles   = [FxCycles;   interp1(cycleTimeRaw, Fx_norm(idx),   cycleTime, 'linear')]; 
    FyCycles   = [FyCycles;   interp1(cycleTimeRaw, Fy_norm(idx),   cycleTime, 'linear')]; 
    FzCycles   = [FzCycles;   interp1(cycleTimeRaw, Fz_norm(idx),   cycleTime, 'linear')]; 
    FresCycles = [FresCycles; interp1(cycleTimeRaw, Fres_norm(idx), cycleTime, 'linear')]; 
end

s00w_FxMean   = mean(FxCycles, 1);
s00w_FyMean   = mean(FyCycles, 1);
s00w_FzMean   = mean(FzCycles, 1);
s00w_FresMean = mean(FresCycles, 1);

% --- Plot all components ---
figure;
plot(cycleTime, s00w_FxMean,   'r', 'LineWidth', 0.8); hold on;
plot(cycleTime, s00w_FyMean,   'g', 'LineWidth', 0.8);
plot(cycleTime, s00w_FzMean,   'b', 'LineWidth', 0.8);
plot(cycleTime, s00w_FresMean, 'k', 'LineWidth', 2); 
xlabel('Normalized Time (% cycle)');
ylabel('Normalized Force (BW)');
title('Telemetric Force Norminlized');
legend('Fx','Fy','Fz','Fres','Location','best');
grid on;

ebr135asavefoler = 'C:\Users\wzy\Desktop\Dissertation\test04\';
%saveas(gcf,fullfile(ebr135asavefoler,'ebr135a.png'));    % saves as PNG