% Set up simulation parameters
t_stop = 500;
impath = '../../images/';

%% Multi-scale plots
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
[positions, ~, times, ~] = switchSim(1, t_stop, true, pP);
fi1 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('Standard simulation (1 fps, relative)');
saveas(fi1, [impath 'switch_multiscale_1fps_relative.png'])

[positions, ~, times, ~] = switchSim(1, t_stop, false, pP);
fi2 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('Standard simulation (1 fps, absolute)');
saveas(fi2, [impath 'switch_multiscale_1fps_absolute.png'])
