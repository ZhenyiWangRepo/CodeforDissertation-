Subject = ["S01"; "S03"; "S05"; "S06"; "S00"];

Weight = [78.71; 87.01; 65.31; 91.30; 62];
Height = [1.79; 1.83; 1.71; 1.78; 1.68];
Force  = [4.5; 1.4; 2.7; 3.6; 2.6];

Weight_fit = Weight(1:4);
Height_fit = Height(1:4);
Force_fit  = Force(1:4);

mdl_weight = fitlm(Weight_fit, Force_fit);

disp('=== Force vs Weight Regression ===');
disp(mdl_weight);

Force_pred_w = predict(mdl_weight, Weight_fit);


figure;
hold on;

plot(Weight_fit, Force_pred_w, 'r-', 'LineWidth', 1.5);

plot(Weight_fit, Force_fit, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);

plot(Weight(5), Force(5), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);

xlabel('Weight (kg)');
ylabel('Force (BW)');
title('Force vs Weight Regression Analysis');
grid on;
legend('Regression Fit', 'experimental Data (S01–S06)', 'telemetric Data (S00)', 'Location','Southwest');

exportgraphics(gcf, 'Force_vs_Weight.png', 'Resolution', 300);
hold off;

mdl_height = fitlm(Height_fit, Force_fit);

disp('=== Force vs Height Regression ===');
disp(mdl_height);

Force_pred_h = predict(mdl_height, Height_fit);

figure;
hold on;

plot(Height_fit, Force_pred_h, 'r-', 'LineWidth', 1.5);

plot(Height_fit, Force_fit, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);

plot(Height(5), Force(5), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);

xlabel('Height (m)');
ylabel('Force (BW)');
title('Force vs Height Regression Analysis ');
grid on;
legend('Regression Fit', 'experimental Data (S01–S06)', 'telemetric Data (S00)', 'Location','Southwest');

exportgraphics(gcf, 'Force_vs_Height.png', 'Resolution', 300);
hold off;