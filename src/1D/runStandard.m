% Set up simulation parameters
t_stop = 500;

%% Uniform plots
pP = [-2:1:2];
[positions, ~, times, ~] = springSim(30, t_stop, pP);
fi1 = figure();
impath = '../../images/';

plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('Standard simulation (30 fps)');
saveas(fi1, [impath 'standard_uniform_30fps.png'])

[positions, ~, times, ~] = springSim(1, t_stop, pP);
fi2 = figure();
impath = '../../images/';

plot(times, positions);
hold on;
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('Standard simulation (1 fps)');
saveas(fi2, [impath 'standard_uniform_1fps.png'])

%% Multi-scale plots
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
[positions, ~, times, ~] = springSim(30, t_stop, pP);
fi3 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('Standard simulation (30 fps)');
saveas(fi3, [impath 'standard_multiscale_30fps.png'])

[positions, ~, times, ~] = springSim(1, t_stop, pP);
fi4 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('Standard simulation (1 fps)');
saveas(fi4, [impath 'standard_multiscale_1fps.png'])
