clear all;
close all;
clc;

% Set up simulation parameters
t_stop = 250;
impath = '../../images/';

%% Multi-scale plots
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
[positions, ~, times, switches] = switchSim(1, t_stop, true, pP);
fi1 = figure();
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
title('Adapt-on-switch simulation (1 fps, relative)');
saveas(fi1, [impath 'switch_multiscale_1fps_relative.png'])

[positions, ~, times, switches] = switchSim(1, t_stop, false, pP);
fi2 = figure();
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
title('Adapt-on-switch simulation (1 fps, absolute)');
saveas(fi2, [impath 'switch_multiscale_1fps_absolute.png'])
