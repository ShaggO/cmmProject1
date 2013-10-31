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
[positions, ~, times, ~] = atomicSim(10, t_stop, 100, 0.1);
fi1 = figure();

plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps)');
saveas(fi1, [impath 'atomic_uniform_10fps_0.png'])

[positions, ~, times, ~] = atomicSim(10, t_stop, 1, inf);
fi2 = figure();

plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps)');
saveas(fi2, [impath 'atomic_uniform_10fps_1.png'])

%% Multi-scale plots
t_stop = 250;
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
[positions, ~, times, ~,~] = atomicSim(10, t_stop, 10, inf, pP, 0.8, 0.5,0.5);
fi3 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 10)');
saveas(fi3, [impath 'atomic_multiscale_10fps_10sbound.png'])

[positions, ~, times, ~,~] = atomicSim(10, t_stop, 68, inf, pP, 0.8, 0.5, 0.5);
fi4 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('AUH simulation (10 fps, sbound = 68)');
saveas(fi4, [impath 'atomic_multiscale_10fps_68sbound.png'])

[positions, ~, times, switches,~] = atomicSim(10, t_stop, 69, inf, pP, 0.8, 0.5, 0.5);
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
saveas(fi5, [impath 'atomic_multiscale_10fps_69sbound.png'])
