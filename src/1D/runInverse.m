clear all;
close all;
clc;
impath = '../../images/';
% Set up simulation parameters
t_stop = 500;
fpses =      [10, 10, 30];
stepBounds = [60, 60, 1];
rFactors =   [inf,  0.2, inf];
results = cell(length(fpses),5);

%% Uniform plots
pP = [-2:2:2];
[positions, ~, times, ~] = inverseSim(10, t_stop, 1, inf);
fi1 = figure();

plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps)');
saveas(fi1, [impath 'inverse_uniform_10fps_0.png'])

[positions, ~, times, ~] = inverseSim(30, t_stop, 1, inf);
fi2 = figure();

plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps)');
saveas(fi2, [impath 'inverse_uniform_10fps_1.png'])

return

%% Multi-scale plots
t_stop = 250;
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
[positions, ~, times, ~,~] = inverseSim(10, t_stop, 10, inf, pP, 0.8, 0.5,0.5);
fi3 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 10)');
saveas(fi3, [impath 'inverse_multiscale_10fps_0.png'])

[positions, ~, times, ~,~] = inverseSim(10, t_stop, 68, inf, pP, 0.8, 0.5, 0.5);
fi4 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 68)');
saveas(fi4, [impath 'inverse_multiscale_10fps_1.png'])
