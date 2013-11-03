clear all;
close all;
clc;
impath = '../../images/';
% Set up simulation parameters
t_stop = 250;
fpses =      [10, 10, 30];
stepBounds = [60, 60, 1];
rFactors =   [inf,  1, inf];
results = cell(length(fpses),5);

%% Uniform plots
pP = [-2:2:2]';
disp('With length');
[positions, ~, times, ~, active] = atomicSim(10, t_stop, 20, 1.002, pP, 0.8);
fi1 = figure();
plot(times, positions);
hold on;
for i = 1:size(active,2)
    updPoints = find(active(:,i));
    plot(times(updPoints),positions(:,updPoints),'xg');
end
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps)');

disp('Without length');
[positions, ~, times, ~] = atomicSim(10, t_stop, 1, NaN, pP, 0.8);
fi2 = figure();

plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps)');

%% Multi-scale plots
t_stop = 250;
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
[positions, ~, times, ~, active] = atomicSim(10, t_stop, 10, NaN, pP, 0.8, 0.5,0.5);
fi3 = figure();
plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 10)');

[positions, ~, times, ~,~] = atomicSim(10, t_stop, 68, NaN, pP, 0.8, 0.5, 0.5);
fi4 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 68)');

[positions, ~, times, switches,~] = atomicSim(10, t_stop, 69, NaN, pP, 0.8, 0.5, 0.5);
fi5 = figure();
plot(times, positions);
hold on
for j = 1:size(switches,1)
    time = switches(j,1);
    ind1 = switches(j,2);
    ind2 = switches(j,3);
    plot(time,positions(ind1, times == time),'xr','MarkerSize', 10);
    plot(time,positions(ind2, times == time),'xr','MarkerSize', 10);
end
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 69)');

[positions, ~, times, switches,~] = atomicSim(10, t_stop, 10, 1.01, pP, 0.8, 0.5, 0.5);
fi6 = figure();
plot(times, positions);
hold on
for j = 1:size(switches,1)
    time = switches(j,1);
    ind1 = switches(j,2);
    ind2 = switches(j,3);
    plot(time,positions(ind1, times == time),'xr','MarkerSize', 10);
    plot(time,positions(ind2, times == time),'xr','MarkerSize', 10);
end
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 10, threshold = 1.01)');

fi = [fi1 fi2 fi3 fi4 fi5 fi6];
set(fi, 'PaperPosition', [-0.2 -0.25 6 5.5]);
set(fi, 'PaperSize', [5.4 5.2]);

saveas(fi1, [impath 'atomic_uniform_10fps_0'],'pdf');
saveas(fi2, [impath 'atomic_uniform_10fps_1'],'pdf');
saveas(fi3, [impath 'atomic_multiscale_10fps_10sbound'],'pdf');
saveas(fi4, [impath 'atomic_multiscale_10fps_68sbound'],'pdf');
saveas(fi5, [impath 'atomic_multiscale_10fps_69sbound'],'pdf');
saveas(fi6, [impath 'atomic_multiscale_10fps_both'],'pdf');
